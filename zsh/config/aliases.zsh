alias zshconfig="${EDITOR:-code} $HOME/.zshrc"
alias ll="ls -l"
alias lla="ls -la"

fix-xcode-command-line-tools() {
  sudo xcode-select --install
}
