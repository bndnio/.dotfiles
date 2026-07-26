#!/usr/bin/env bash
# Idempotent machine bootstrap for this dotfiles repo.
# Safe to re-run.
#   SKIP_OPEN_APPS=1 ./setup.sh
#   HOMEBREW_PREFIX=...  # used by test sandbox / custom installs
set -euo pipefail

DOTFILES="$(cd "$(dirname "$0")" && pwd)"
BREW_BIN=""

log()  { printf '==> %s\n' "$*"; }
warn() { printf '!!  %s\n' "$*" >&2; }

have() { command -v "$1" >/dev/null 2>&1; }

ensure_line() {
  # ensure_line <file> <line>
  local file="$1" line="$2"
  mkdir -p "$(dirname "$file")"
  touch "$file"
  grep -Fqx "$line" "$file" 2>/dev/null || echo "$line" >>"$file"
}

resolve_brew() {
  # When HOMEBREW_PREFIX is set (custom install / test sandbox), only use that prefix.
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

############################
# SSH agent (optional key) #
############################
log "SSH agent"
eval "$(ssh-agent -s)" >/dev/null
SSH_KEY="$HOME/.ssh/id_ed25519"
if [[ -f "$SSH_KEY" ]]; then
  ssh-add --apple-use-keychain "$SSH_KEY" 2>/dev/null || ssh-add "$SSH_KEY" 2>/dev/null || warn "Could not add $SSH_KEY"
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
# Shell links              #
############################
log "Linking ~/.zshrc"
if [[ -e "$HOME/.zshrc" && ! -L "$HOME/.zshrc" ]]; then
  if [[ ! -e "$HOME/.zshrc.pre-dotfiles" ]]; then
    mv "$HOME/.zshrc" "$HOME/.zshrc.pre-dotfiles"
    log "Backed up existing ~/.zshrc → ~/.zshrc.pre-dotfiles"
  else
    mv "$HOME/.zshrc" "$HOME/.zshrc.pre-dotfiles.$(date +%Y%m%d%H%M%S)"
  fi
fi
ln -sfn "$DOTFILES/.zshrc" "$HOME/.zshrc"

if [[ ! -f "$DOTFILES/zsh/local.zsh" && -f "$DOTFILES/zsh/local.zsh.example" ]]; then
  cp "$DOTFILES/zsh/local.zsh.example" "$DOTFILES/zsh/local.zsh"
  log "Created zsh/local.zsh from example"
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

# Put brew on PATH for this process + future login shells (once)
SHELLENV_LINE="$(brew_shellenv_line | tr -d '\n')"
ensure_line "$HOME/.zprofile" "$SHELLENV_LINE"
eval "$SHELLENV_LINE"
resolve_brew

# Homebrew 6+ may require trusting third-party taps from the Brewfile
if "$BREW_BIN" trust --help >/dev/null 2>&1; then
  "$BREW_BIN" trust timescam/tap 2>/dev/null || true
fi

log "brew bundle"
"$BREW_BIN" bundle --file="$DOTFILES/Brewfile"

############################
# Cursor extensions        #
############################
# brew bundle installs vscode.* into VS Code only
if have cursor; then
  log "Installing Brewfile extensions into Cursor"
  while read -r ext; do
    [[ -n "$ext" ]] || continue
    cursor --install-extension "$ext" >/dev/null || warn "Failed: $ext"
  done < <(sed -n 's/^vscode "\([^"]*\)".*/\1/p' "$DOTFILES/Brewfile")
else
  warn "cursor CLI not on PATH — in Cursor: Shell Command: Install 'cursor' command in PATH"
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
else
  log "Skipping app opens (SKIP_OPEN_APPS=1)"
fi

############################
# Cleanup                  #
############################
log "brew cleanup"
"$BREW_BIN" cleanup

log "Done. Open a new shell (or: exec zsh) to pick up PATH/theme changes."
