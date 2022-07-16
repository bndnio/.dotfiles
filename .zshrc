################################################
# ------------- OH MY ZSH config
################################################

# Path to your oh-my-zsh installation.

export ZSH=$HOME/.oh-my-zsh
export SSH=$HOME/.ssh

# Set name of the theme to load
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="spaceship"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS=true

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
    docker      #docker autocomplete
    git         #git shortcuts https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/git
    history     #history shortcuts (h, hs, _hsi_)
    npm         #npm autocomplete & shortcuts https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/npm
    pip         #pip autocomplete
    yarn        #yarn autocompelte
)

source $ZSH/oh-my-zsh.sh


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
alias ohmyzshconfig="vim ~/.oh-my-zsh"
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

source $SSH/certn-ssh.sh
