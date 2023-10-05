
#################################################
# ----------------- MY config ----------------- #
#################################################

# ---------------- ENV VARS -------------------
# Language environment
export LANG=en_CA.UTF-8
# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ---------------- ALIASES --------------------
# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
alias zshconfig="vim $HOME/.zshrc"
alias ll="ls -l"
alias lla="ls -la"
function fix-xcode-command-line-tools () "sudo xcode-select --install"

# ---------------- NVM CONFIG -----------------
export NVM_DIR="$HOME/.nvm"
[ -s /usr/local/opt/nvm/nvm.sh ] && . /usr/local/opt/nvm/nvm.sh  # This loads nvm
[ -s /usr/local/opt/nvm/etc/bash_completion.d/nvm ] && . /usr/local/opt/nvm/etc/bash_completion.d/nvm  # This loads nvm bash_completion

# ---------------- PYENV CONFIG ---------------
# -- CORE --
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi
# -- PYENV-VIRTUALENV PLUGIN --
eval "$(pyenv virtualenv-init -)"

# ---------------- THEFUCK CONFIG -------------
eval $(thefuck --alias fuck)

export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

# ---------------- EXTRA SCRIPTS --------------
