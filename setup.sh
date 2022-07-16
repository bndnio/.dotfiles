# Setup SSH for GH
eval "$(ssh-agent -s)"
ssh-add --apple-use-keychain ~/.ssh/id_ed25519

# Symlink .zshrc
ln -s .zshrc ~/.zshrc

# Install Oh-My-ZSH
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh | sed '/\s*env\s\s*zsh\s*/d')"

# Install Brew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
# Prompted configuration (July 2022)
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
open $APPS/JetBrains\ Toolbox.app

# Cleanup
brew cleanup
# rm -f -r /Library/Caches/Homebrew/*

# Other instructions
echo "Follow https://gist.github.com/kevin-smets/8568070 to setup a nice terminal"
