#!/usr/bin/env bash
set -euo pipefail

DOTFILES="$(cd "$(dirname "$0")" && pwd)"

# Setup SSH for GH
eval "$(ssh-agent -s)"
ssh-add --apple-use-keychain ~/.ssh/id_ed25519

# Install Oh My Zsh (theme/plugins live in repo .zshrc)
if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
  RUNZSH=no CHSH=no KEEP_ZSHRC=yes \
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# Link repo .zshrc (backs up an existing non-symlink file)
if [[ -e "$HOME/.zshrc" && ! -L "$HOME/.zshrc" ]]; then
  mv "$HOME/.zshrc" "$HOME/.zshrc.pre-dotfiles"
fi
ln -sfn "$DOTFILES/.zshrc" "$HOME/.zshrc"

# Optional machine-local overrides
if [[ ! -f "$DOTFILES/zsh/local.zsh" && -f "$DOTFILES/zsh/local.zsh.example" ]]; then
  cp "$DOTFILES/zsh/local.zsh.example" "$DOTFILES/zsh/local.zsh"
fi

# Install Brew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
# Prompted brew configuration (as of Oct 2023)
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"

# Install Mac-CLI
sh -c "$(curl -fsSL https://raw.githubusercontent.com/guarinogabriel/mac-cli/master/mac-cli/tools/install)"

# Install Brew Apps (from Brewfile)
brew bundle --file="$DOTFILES/Brewfile"

# Install Brewfile vscode extensions into Cursor as well
# (brew bundle only targets VS Code; Cursor needs the CLI)
if command -v cursor >/dev/null 2>&1; then
  while read -r ext; do
    cursor --install-extension "$ext"
  done < <(sed -n 's/^vscode "\([^"]*\)".*/\1/p' "$DOTFILES/Brewfile")
else
  echo "cursor CLI not on PATH — open Cursor and run: Shell Command: Install 'cursor' command in PATH"
  echo "Then re-run: sed -n 's/^vscode \"\\([^\"]*\\)\".*/\\1/p' \"$DOTFILES/Brewfile\" | xargs -L1 cursor --install-extension"
fi

## Config fnm
fnm install --lts
fnm default lts-latest

## Config uv
uv python install 3.12 --default

# Start apps that need manual config
APPS="/Applications"
open "$APPS/1Password.app"
open "$APPS/Docker.app"
open "$APPS/Ghostty.app"

# Cleanup
brew cleanup
rm -f -r ~/Library/Caches/Homebrew/*
