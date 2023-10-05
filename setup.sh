# Setup SSH for GH
eval "$(ssh-agent -s)"
ssh-add --apple-use-keychain ~/.ssh/id_ed25519

# Link .zshrc here for user
ln -s "$(eval pwd)/.zshrc" ~/.zshrc

# Install Brew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
# Prompted brew configuration (as of Oct 2023)
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"

# Install Mac-CLI
sh -c "$(curl -fsSL https://raw.githubusercontent.com/guarinogabriel/mac-cli/master/mac-cli/tools/install)"

# Install Brew Apps (from Brewfile)
brew bundle

## Config nvm
mkdir ~/.nvm

## Config pyenv
pyenv install 3.10.5
pyenv global 3.10.5

# Start apps that need manual config
APPS="/Applications"
open $APPS/1Password.app
open $APPS/Docker.app
open $APPS/Warp.app
open $APPS/Google\ Chrome.app

# Cleanup
brew cleanup
rm -f -r ~/Library/Caches/Homebrew/*
