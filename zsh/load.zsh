# OMZ only auto-sources top-level *.zsh — load the rest in order.
for dir in config tools; do
  for file in "$ZSH_CUSTOM/$dir"/*.zsh(N); do
    source "$file"
  done
done

[[ -f "$ZSH_CUSTOM/local.zsh" ]] && source "$ZSH_CUSTOM/local.zsh"
