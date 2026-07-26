#!/usr/bin/env bash
# Idempotent machine bootstrap for this dotfiles repo.
# Safe to re-run.
#   SKIP_OPEN_APPS=1 ./setup.sh
set -euo pipefail

DOTFILES="$(cd "$(dirname "$0")" && pwd)"
BREW_BIN=""

log()  { printf '==> %s\n' "$*"; }
warn() { printf '!!  %s\n' "$*" >&2; }

have() { command -v "$1" >/dev/null 2>&1; }

ensure_line() {
  local file="$1" line="$2"
  mkdir -p "$(dirname "$file")"
  touch "$file"
  grep -Fqx "$line" "$file" 2>/dev/null || echo "$line" >>"$file"
}

link_dotfile() {
  # link_dotfile <repo-relative-or-abs-source> <destination>
  local src="$1" dest="$2"
  if [[ "$src" != /* ]]; then
    src="$DOTFILES/$src"
  fi
  mkdir -p "$(dirname "$dest")"
  if [[ -e "$dest" && ! -L "$dest" ]]; then
    local backup="${dest}.pre-dotfiles"
    if [[ ! -e "$backup" ]]; then
      mv "$dest" "$backup"
      log "Backed up $dest → $backup"
    else
      mv "$dest" "${dest}.pre-dotfiles.$(date +%Y%m%d%H%M%S)"
    fi
  fi
  ln -sfn "$src" "$dest"
}

resolve_brew() {
  if [[ -n "${HOMEBREW_PREFIX:-}" ]]; then
    if [[ -x "${HOMEBREW_PREFIX}/bin/brew" ]]; then
      BREW_BIN="${HOMEBREW_PREFIX}/bin/brew"
    else
      BREW_BIN=""
    fi
    return
  fi

  if have brew; then
    BREW_BIN="$(command -v brew)"
  elif [[ -x /opt/homebrew/bin/brew ]]; then
    BREW_BIN="/opt/homebrew/bin/brew"
  elif [[ -x /usr/local/bin/brew ]]; then
    BREW_BIN="/usr/local/bin/brew"
  else
    BREW_BIN=""
  fi
}

brew_shellenv_line() {
  if [[ -n "${HOMEBREW_PREFIX:-}" ]]; then
    printf 'eval "$(%s/bin/brew shellenv)"\n' "$HOMEBREW_PREFIX"
  elif [[ -x /opt/homebrew/bin/brew ]]; then
    printf '%s\n' 'eval "$(/opt/homebrew/bin/brew shellenv)"'
  elif [[ -x /usr/local/bin/brew ]]; then
    printf '%s\n' 'eval "$(/usr/local/bin/brew shellenv)"'
  else
    printf 'eval "$(%s shellenv)"\n' "$BREW_BIN"
  fi
}

resolve_cursor() {
  if have cursor; then
    command -v cursor
    return 0
  fi
  local candidate="/Applications/Cursor.app/Contents/Resources/app/bin/cursor"
  if [[ -x "$candidate" ]]; then
    echo "$candidate"
    return 0
  fi
  return 1
}

############################
# Xcode Command Line Tools #
############################
log "Xcode Command Line Tools"
if xcode-select -p >/dev/null 2>&1; then
  log "Command Line Tools already installed"
else
  log "Installing Command Line Tools (GUI prompt may appear)"
  touch /tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress 2>/dev/null || true
  if have softwareupdate; then
    label="$(softwareupdate -l 2>/dev/null | awk -F'*' '/Command Line Tools/ {print $2}' | sed 's/^ *//' | tail -n1 || true)"
    if [[ -n "${label:-}" ]]; then
      softwareupdate -i "$label" --verbose || warn "softwareupdate failed; falling back to xcode-select --install"
    fi
  fi
  if ! xcode-select -p >/dev/null 2>&1; then
    xcode-select --install || true
    warn "Finish the Command Line Tools install dialog, then re-run ./setup.sh"
    exit 1
  fi
fi

############################
# SSH agent (optional key) #
############################
log "SSH agent"
eval "$(ssh-agent -s)" >/dev/null
SSH_KEY="$HOME/.ssh/id_ed25519"
if [[ -f "$SSH_KEY" ]]; then
  ssh-add --apple-use-keychain "$SSH_KEY" 2>/dev/null || ssh-add "$SSH_KEY" 2>/dev/null || warn "Could not add $SSH_KEY"
  # Ensure allowed_signers exists for SSH commit signing
  if [[ ! -f "$HOME/.ssh/allowed_signers" && -f "${SSH_KEY}.pub" ]]; then
    awk '{print $3" "$1" "$2}' "${SSH_KEY}.pub" >"$HOME/.ssh/allowed_signers"
    log "Created ~/.ssh/allowed_signers from ${SSH_KEY}.pub"
  fi
else
  warn "No $SSH_KEY — skip ssh-add (create a key before pushing to GitHub)"
fi

############################
# Oh My Zsh                #
############################
if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
  log "Installing Oh My Zsh"
  RUNZSH=no CHSH=no KEEP_ZSHRC=yes \
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
  log "Oh My Zsh already installed"
fi

############################
# Dotfile links            #
############################
log "Linking dotfiles"
link_dotfile ".zshrc" "$HOME/.zshrc"
link_dotfile "git/gitconfig" "$HOME/.gitconfig"

if [[ ! -f "$DOTFILES/zsh/local.zsh" && -f "$DOTFILES/zsh/local.zsh.example" ]]; then
  cp "$DOTFILES/zsh/local.zsh.example" "$DOTFILES/zsh/local.zsh"
  log "Created zsh/local.zsh from example — add secrets there"
fi

############################
# Homebrew                 #
############################
resolve_brew
if [[ -z "$BREW_BIN" ]]; then
  log "Installing Homebrew"
  NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  resolve_brew
fi

if [[ -z "$BREW_BIN" ]]; then
  warn "Homebrew not found after install; aborting"
  exit 1
fi

SHELLENV_LINE="$(brew_shellenv_line | tr -d '\n')"
ensure_line "$HOME/.zprofile" "$SHELLENV_LINE"
eval "$SHELLENV_LINE"
resolve_brew

if "$BREW_BIN" trust --help >/dev/null 2>&1; then
  "$BREW_BIN" trust timescam/tap 2>/dev/null || true
fi

log "brew bundle"
warn "Mac App Store apps need you signed into the App Store first (Bear, Things, djay Pro)"
export HOMEBREW_NO_AUTO_UPDATE="${HOMEBREW_NO_AUTO_UPDATE:-1}"
if ! "$BREW_BIN" bundle --file="$DOTFILES/Brewfile"; then
  warn "brew bundle reported errors (sudo prompts, App Store auth, or network)."
  warn "Fix those and re-run ./setup.sh — earlier steps are safe to repeat."
fi

############################
# Cursor extensions        #
############################
CURSOR_BIN="$(resolve_cursor || true)"
if [[ -n "${CURSOR_BIN:-}" ]]; then
  log "Installing Brewfile extensions into Cursor ($CURSOR_BIN)"
  while read -r ext; do
    [[ -n "$ext" ]] || continue
    "$CURSOR_BIN" --install-extension "$ext" >/dev/null || warn "Failed: $ext"
  done < <(sed -n 's/^vscode "\([^"]*\)".*/\1/p' "$DOTFILES/Brewfile")
else
  warn "cursor CLI not found — open Cursor → Command Palette → Shell Command: Install 'cursor' command in PATH"
  warn "Then re-run: ./setup.sh"
fi

############################
# Runtimes                 #
############################
if have fnm; then
  log "fnm: ensure Node LTS"
  eval "$(fnm env --shell bash)"
  fnm install --lts
  fnm default lts-latest
else
  warn "fnm not installed"
fi

if have uv; then
  log "uv: ensure Python 3.12"
  uv python install 3.12 --default
else
  warn "uv not installed"
fi

############################
# First-run apps           #
############################
open_if_needed() {
  local app="$1"
  [[ -d "$app" ]] || return 0
  local name
  name="$(basename "$app" .app)"
  if osascript -e "application \"$name\" is running" 2>/dev/null | grep -qi true; then
    return 0
  fi
  open "$app"
}

if [[ "${SKIP_OPEN_APPS:-0}" != "1" ]]; then
  log "Opening apps that usually need first-run setup"
  open_if_needed "/Applications/Ghostty.app"
  open_if_needed "/Applications/1Password.app"
  open_if_needed "/Applications/Docker.app"
  open_if_needed "/Applications/Cursor.app"
else
  log "Skipping app opens (SKIP_OPEN_APPS=1)"
fi

############################
# Cleanup                  #
############################
log "brew cleanup"
"$BREW_BIN" cleanup

log "Done. Open a new shell (or: exec zsh) to pick up PATH/theme changes."
