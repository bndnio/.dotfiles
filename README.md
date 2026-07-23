# When setting up a new computer

## Device settings
* Trackpad -> enable "Tap to Click"
* Trackpad -> speed up pointer speed
* Accessibility -> Pointer Control -> Trackpad Options -> enable dragging w/ "Three Finger Draging"

## Pre-Requisites for running setup.sh
* [Create an ssh key](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent) using `ssh-keygen -t ed25519 -C "your_email@example.com"`
* Clone the .dotfiles repo into your home directory: `git clone https://github.com/bndnio/.dotfiles.git ~/.dotfiles`
* run `chmod 744 setup.sh` in the repo to allow execution

## What setup.sh configures
* Oh My Zsh (`robbyrussell` theme, `git` plugin)
* Symlinks `~/.zshrc` → this repo's `.zshrc` (loads `zsh/*.zsh`)
* Homebrew + Brewfile apps
* fnm (Node LTS) + uv (Python)

## Shell layout
* `.zshrc` — Oh My Zsh bootstrap only
* `zsh/load.zsh` — loads the folders below (OMZ only auto-sources top-level `*.zsh`)
* `zsh/config/` — env, aliases
* `zsh/tools/` — fnm, uv, thefuck, …
* `zsh/local.zsh` — machine-specific overrides (gitignored; copy from `local.zsh.example`)

## After running setup.sh
* [Add public ssh key to GitHub](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account)
* Edit `zsh/local.zsh` for secrets / one-off PATH entries (bun, tokens, etc.)
