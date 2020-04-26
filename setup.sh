# Install Oh-My-ZSH
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Install Brew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

# Install Mac-CLI
sh -c "$(curl -fsSL https://raw.githubusercontent.com/guarinogabriel/mac-cli/master/mac-cli/tools/install)"

# Install Brew Apps (from Brewfile)
brew  bundle

## Config nvm
mkdir ~/.nvm
echo '# -- NVM CONFIG --' >> ~/.zshrc
echo 'export NVM_DIR="$HOME/.nvm"
[ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/usr/local/opt/nvm/etc/bash_completion.d/nvm" ] && . "/usr/local/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion' >> ~/.zshrc

## Config pyenv
echo "\n# -- PYENV CONFIG --" >> ~/.zshrc
echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.zshrc
echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.zshrc
echo -e 'if command -v pyenv 1>/dev/null 2>&1; then\n  eval "$(pyenv init -)"\nfi' >> ~/.zshrc
pyenv install 3.6.10
pyenv global 3.6.10

## Config pyenv virtualenv
echo "\n# -- PYENV-VIRTUALENV CONFIG --" >> ~/.zshrc
echo 'eval "$(pyenv virtualenv-init -)"\n' >> ~/.zshrc

# Start apps that need manual config
APPS="/Applications"
open $APPS/1Password\ 7.app
open $APPS/Docker.app
# open $APPS/Dropbox.app
open $APPS/JetBrains\ Toolbox.app

# Cleanup
brew cleanup --force
rm -f -r /Library/Caches/Homebrew/*

# Other instructions
echo "Follow https://gist.github.com/kevin-smets/8568070 to setup a nice terminal"
