# Setup SSH for GH
eval "$(ssh-agent -s)"
ssh-add --apple-use-keychain ~/.ssh/id_ed25519

# Install Oh-My-ZSH
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh | sed '/\s*env\s\s*zsh\s*/d')"
mv .zshrc .zshrc.pre-dot-files
ln -s .zshrc ~/.zshrc
chmod 744 ~/.oh-my-zsh/oh-my-zsh.sh

# Theme Oh-My-ZSH
git clone https://github.com/spaceship-prompt/spaceship-prompt.git "$ZSH/themes/spaceship-prompt" --depth=1
ln -s "$ZSH/themes/spaceship-prompt/spaceship.zsh-theme" "$ZSH/themes/spaceship.zsh-theme"
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

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
open $APPS/Warp.app
open $APPS/Google\ Chrome.app


# Cleanup
brew cleanup
rm -f -r ~/Library/Caches/Homebrew/*

# Other instructions
echo "Follow https://gist.github.com/kevin-smets/8568070 to setup a nice terminal"
