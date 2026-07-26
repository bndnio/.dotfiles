# .dotfiles

macOS bootstrap: Homebrew apps, Oh My Zsh, and shell config. Safe to re-run.

## New machine

### 1. Manual device settings
- Trackpad → enable **Tap to Click**
- Trackpad → raise pointer speed
- Accessibility → Pointer Control → Trackpad Options → enable dragging with **Three Finger Drag**

### 2. Prerequisites
1. [Create an SSH key](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent):
   ```sh
   ssh-keygen -t ed25519 -C "your_email@example.com"
   ```
2. Clone this repo into your home directory:
   ```sh
   git clone git@github.com:bndnio/.dotfiles.git ~/.dotfiles
   cd ~/.dotfiles
   ```

### 3. Run setup
```sh
./setup.sh
```

Idempotent — safe to re-run. Useful flags:

| Flag | Effect |
|------|--------|
| `SKIP_OPEN_APPS=1` | Don’t launch 1Password / Docker / Ghostty / Cursor |

Example:
```sh
SKIP_OPEN_APPS=1 ./setup.sh
```

### 4. After setup
- [Add your public SSH key to GitHub](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account)
- Copy and edit machine-local overrides:
  ```sh
  cp zsh/local.zsh.example zsh/local.zsh
  ```
  Use this for secrets, bun, extra `PATH` entries, etc. (`zsh/local.zsh` is gitignored.)
- If Cursor’s CLI isn’t on `PATH`: open Cursor → Command Palette → **Shell Command: Install 'cursor' command in PATH**, then re-run `./setup.sh` (or install extensions manually — see below)
- Open a new terminal (or `exec zsh`) so Oh My Zsh + tool shims load

## What `setup.sh` does
- Installs **Oh My Zsh** if missing (`robbyrussell` theme, `git` plugin)
- Symlinks `~/.zshrc` → this repo’s `.zshrc` (backs up a non-symlink file once)
- Creates `zsh/local.zsh` from the example if missing
- Installs **Homebrew** if missing; appends `brew shellenv` to `~/.zprofile` **once**
- Trusts `timescam/tap` when needed (for `pay-respects`)
- Runs `brew bundle` against `Brewfile`
- Installs each Brewfile `vscode "..."` extension into **Cursor** via `cursor --install-extension`
- Ensures **fnm** Node LTS and **uv** Python 3.12
- Opens first-run apps unless already running / skipped

## Layout

```
.zshrc                 # Oh My Zsh bootstrap (theme, plugins, ZSH_CUSTOM)
Brewfile               # formulae, casks, mas apps, VS Code extensions
setup.sh               # idempotent bootstrap
zsh/
  load.zsh             # OMZ entrypoint → config/, tools/, local.zsh
  config/              # env, aliases
  tools/               # fnm, uv, pay-respects
  local.zsh.example    # template for machine-specific overrides
  local.zsh            # gitignored local overrides
test/sandbox/          # fake-HOME harness for setup.sh
```

## Brewfile overview
- **CLI:** aws/azure CLIs, gh, fnm, uv, ripgrep, pay-respects, …
- **Apps:** Cursor, Ghostty, Docker Desktop, 1Password, Affinity, Figma, Linear, …
- **Mac App Store:** Bear, Things, djay Pro (`mas` — requires App Store sign-in)
- **Extensions:** listed as `vscode "..."`; `brew bundle` installs them into VS Code, and `setup.sh` mirrors them into Cursor

Sync Cursor extensions anytime:
```sh
sed -n 's/^vscode "\([^"]*\)".*/\1/p' Brewfile | xargs -L1 cursor --install-extension
```

## Shell notes
- Theme is set in `.zshrc` as `ZSH_THEME="robbyrussell"`
- Oh My Zsh only auto-loads top-level `zsh/*.zsh`; `load.zsh` pulls in `config/` and `tools/`
- `pay-respects` is aliased to `fuck` (thefuck replacement)

## Testing `setup.sh`
Runs setup twice in a disposable fake `$HOME` with stubbed `curl` / Homebrew / `fnm` / `uv` / `cursor` (no Docker required):

```sh
./test/sandbox/run.sh
```

Checks a fresh install path and idempotent re-run (e.g. brew `shellenv` only written once). This does **not** exercise real Homebrew downloads, casks, or the Mac App Store.
