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
