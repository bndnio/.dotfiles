
#################################################
# ----------------- MY config ----------------- #
#################################################

# ---------------- ENV VARS -------------------
# Language environment
export LANG=en_CA.UTF-8

# ---------------- ALIASES --------------------
# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. For a full list of active aliases, run `alias`.
alias zshconfig="code $HOME/.zshrc"
alias ll="ls -l"
alias lla="ls -la"
function fix-xcode-command-line-tools () "sudo xcode-select --install"

# ---------------- FNM CONFIG -----------------
if command -v fnm 1>/dev/null 2>&1; then
  eval "$(fnm env --use-on-cd --shell zsh)"
fi
# ---------------- UV CONFIG ------------------
if command -v uv 1>/dev/null 2>&1; then
  eval "$(uv generate-shell-completion zsh)"
fi

# ---------------- THEFUCK CONFIG -------------
eval $(thefuck --alias fuck)

# ---------------- EXTRA SCRIPTS --------------
