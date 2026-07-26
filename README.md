# .dotfiles

macOS bootstrap: Homebrew apps, Oh My Zsh, git config, and shell config. Safe to re-run.

## New machine

### 1. Prerequisites
1. Install / finish **Xcode Command Line Tools** if prompted (or let `setup.sh` start it).
2. Create an SSH key (can do before or after clone):
   ```sh
   ssh-keygen -t ed25519 -C "your_email@example.com"
   ```
3. Clone this repo (**HTTPS works before the key is on GitHub**):
   ```sh
   git clone https://github.com/bndnio/.dotfiles.git ~/.dotfiles
   cd ~/.dotfiles
   ```
   After the key is on GitHub, you can switch the remote:
   ```sh
   git remote set-url origin git@github.com:bndnio/.dotfiles.git
   ```
4. Sign into the **Mac App Store** (needed for `mas` apps: Bear, Things, djay Pro).

### 2. Run setup
```sh
./setup.sh
```

Idempotent — safe to re-run.

| Flag | Effect |
|------|--------|
| `SKIP_OPEN_APPS=1` | Don’t launch Ghostty / 1Password / Docker / Cursor |
| `SKIP_MACOS_DEFAULTS=1` | Don’t apply trackpad defaults |

```sh
SKIP_OPEN_APPS=1 SKIP_MACOS_DEFAULTS=1 ./setup.sh
```

Trackpad prefs (tap to click, faster tracking, three-finger drag) are applied by `macos/defaults.sh`. Re-run just that with:
```sh
./macos/defaults.sh
```

### 3. After setup checklist
- [Add your public SSH key to GitHub](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account)
- Put secrets and machine-only PATH tweaks in `zsh/local.zsh` (gitignored; created from the example on first run)
- If Cursor extensions were skipped: Cursor → Command Palette → **Shell Command: Install 'cursor' command in PATH**, then re-run `./setup.sh`
- Open a new terminal (or `exec zsh`)
- Sign into 1Password, Docker, Slack, etc.

## What `setup.sh` does
- Ensures **Xcode Command Line Tools**
- Installs **Oh My Zsh** if missing (`robbyrussell` theme, `git` plugin)
- Symlinks `~/.zshrc`, `~/.gitconfig`, and `~/.ssh/config` from this repo (backs up non-symlinks once)
- Creates `zsh/local.zsh` and `~/.ssh/config.local` from examples if missing
- Installs **Homebrew** if missing; appends `brew shellenv` to `~/.zprofile` **once**
- Trusts `timescam/tap` when needed (for `pay-respects`)
- Runs `brew bundle` against `Brewfile`
- Installs Brewfile `vscode "..."` extensions into **Cursor** (PATH or app bundle binary)
- Ensures **fnm** Node LTS and **uv** Python 3.12
- Applies **macOS trackpad defaults** (`macos/defaults.sh`)
- Opens first-run apps unless already running / skipped

## Layout

```
.zshrc                 # Oh My Zsh bootstrap (theme, plugins, ZSH_CUSTOM)
Brewfile               # formulae, casks, mas apps, VS Code extensions
git/gitconfig          # user identity + SSH commit signing
macos/defaults.sh      # trackpad / system preference tweaks
setup.sh               # idempotent bootstrap
ssh/
  config               # shared SSH config (linked to ~/.ssh/config)
  config.local.example # template for host-specific overrides
zsh/
  load.zsh             # OMZ entrypoint → config/, tools/, local.zsh
  config/              # env, aliases
  tools/               # fnm, uv, pay-respects
  local.zsh.example    # template for machine-specific overrides
  local.zsh            # gitignored local overrides (secrets, bun, …)
```

## Brewfile overview
- **CLI:** aws/azure CLIs, gh, fnm, uv, ripgrep, pay-respects, …
- **Apps:** Cursor, Ghostty, Docker Desktop, 1Password, Affinity, Figma, Linear, …
- **Mac App Store:** Bear, Things, djay Pro (`mas` — requires App Store sign-in)
- **Extensions:** `vscode "..."` lines; `brew bundle` → VS Code, `setup.sh` → Cursor

Sync Cursor extensions anytime:
```sh
sed -n 's/^vscode "\([^"]*\)".*/\1/p' Brewfile | xargs -L1 cursor --install-extension
```

## Shell & git notes
- Theme: `ZSH_THEME="robbyrussell"` in `.zshrc`
- Oh My Zsh only auto-loads top-level `zsh/*.zsh`; `load.zsh` pulls in `config/` and `tools/`
- `pay-respects` is aliased to `fuck`
- Git uses **SSH commit signing**; `setup.sh` will create `~/.ssh/allowed_signers` from your pubkey if missing
- Work-specific git config can live in `~/.gitconfig-dopa` (included for `~/Code/Dopa/`)
- SSH: shared `ssh/config` + per-machine `~/.ssh/config.local` (via `Include`). Private keys stay out of the repo.
