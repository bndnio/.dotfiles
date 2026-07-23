# Path to Oh My Zsh
export ZSH="$HOME/.oh-my-zsh"

# Theme + plugins
ZSH_THEME="robbyrussell"
plugins=(git)

# Repo root (works when ~/.zshrc is a symlink). OMZ loads zsh/load.zsh → config/, tools/, local.zsh
export DOTFILES="${${(%):-%N}:A:h}"
export ZSH_CUSTOM="$DOTFILES/zsh"

source "$ZSH/oh-my-zsh.sh"
