if command -v uv 1>/dev/null 2>&1; then
  eval "$(uv generate-shell-completion zsh)"
fi
