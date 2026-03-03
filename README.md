# Dotfiles

Mac setup backup & restore. Managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Quick Start

```bash
# Clone the repo
git clone git@github.com:louisgundelwein/dotfiles.git ~/dotfiles
cd ~/dotfiles

# Run the interactive setup
./bootstrap.sh
```

The bootstrap script offers an interactive menu:

1. **Full Installation** — Essential + Optional Homebrew packages, all configs linked
2. **Essential Only** — Core dev tools and apps only
3. **Symlinks Only** — Just link dotfiles (if packages are already installed)
4. **Brewfile Only** — Just install Homebrew packages (no symlinks)

### What bootstrap does

1. Installs Xcode Command Line Tools (if missing)
2. Installs [Homebrew](https://brew.sh/) (if missing)
3. Runs `brew bundle` to install all packages from `Brewfile`
4. Installs [Oh My Zsh](https://ohmyz.sh/) + plugins + [Powerlevel10k](https://github.com/romkatv/powerlevel10k) theme
5. Installs Node.js versions via [NVM](https://github.com/nvm-sh/nvm)
6. Initializes git submodules (Neovim config)
7. Links all dotfiles via GNU Stow
8. Applies macOS system preferences (Dock, Finder, keyboard)

## What's Included

| Directory | Contents | Symlinks to |
|-----------|----------|-------------|
| `zsh/` | Shell config (`.zshrc`, `.zprofile`, `.zshenv`, `.p10k.zsh`) | `~/` |
| `git/` | Git config + global gitignore | `~/` |
| `ssh/` | SSH host aliases (IPs stored separately, see below) | `~/.ssh/` |
| `gh/` | GitHub CLI config | `~/.config/gh/` |
| `claude/` | Claude Code settings, hooks, RTK config | `~/.claude/` |
| `ghostty/` | Ghostty terminal config (Dracula+ theme) | `~/.config/ghostty/` |
| `nvim/` | Neovim config (git submodule → [LazyVim](https://github.com/LazyVim/starter)) | — |
| `scripts/` | Helper scripts (not symlinked) | — |

## How Stow Works

Each top-level directory is a "stow package". The folder structure inside mirrors your home directory. When you run `stow zsh`, it creates symlinks from `zsh/.zshrc` → `~/.zshrc`, etc.

The `scripts/link.sh` wrapper handles all packages at once using `--adopt` mode — if a file already exists at the target, stow adopts it, then `git checkout` restores the repo version so the repo always wins.

## Adding New Dotfiles

```bash
# 1. Create the directory structure mirroring $HOME
mkdir -p ~/dotfiles/toolname/.config/toolname
cp ~/.config/toolname/config ~/dotfiles/toolname/.config/toolname/

# 2. Add the package name to STOW_PACKAGES in scripts/link.sh

# 3. Re-link
./scripts/link.sh
```

## Updating

### After editing a dotfile

Your dotfiles are symlinked, so edits to `~/.zshrc` directly modify `~/dotfiles/zsh/.zshrc`. Just commit and push:

```bash
cd ~/dotfiles
git add -A
git commit -m "Update zshrc"
git push
```

### After adding a new Homebrew package

```bash
# Add the formula/cask to Brewfile (or Brewfile.optional), then:
brew bundle --file=~/dotfiles/Brewfile
```

### Pulling changes on another machine

```bash
cd ~/dotfiles
git pull
./scripts/link.sh    # Re-link in case new packages were added
brew bundle --file=Brewfile  # Install any new packages
```

## Optional Apps

Gaming, 3D printing, music/DJ, and other optional apps are in a separate file:

```bash
brew bundle --file=Brewfile.optional
```

## Secrets

Tokens and secrets are stored in `~/.env.local` (never committed). The `.zshrc` sources this file automatically.

```bash
cp .env.local.template ~/.env.local
# Edit ~/.env.local and add your tokens (NPM_TOKEN, etc.)
```

## SSH Keys & Host IPs

SSH keys are managed via **1Password SSH Agent** — no private keys on disk needed.

Host **IP addresses** are stored in `~/.ssh/hosts.local` (not in this repo). On a new machine:

1. Install 1Password and enable the SSH Agent (Settings → Developer)
2. Run `./bootstrap.sh` to link the SSH config
3. Copy `ssh/.ssh/hosts.local.template` to `~/.ssh/hosts.local` and fill in the IPs
4. Tip: Store `hosts.local` as a document in 1Password for easy transfer between machines

```bash
cp ~/dotfiles/ssh/.ssh/hosts.local.template ~/.ssh/hosts.local
# Fill in the real IPs, then test:
ssh ucm-staging
```

## macOS Defaults

The setup script applies some system preferences:

- Dock: autohide enabled, smaller icon size
- Finder: show path bar, show hidden files
- Keyboard: fast key repeat, short delay
- Trackpad: tap to click

Re-apply anytime: `./scripts/setup-macos-defaults.sh`

## Structure

```
~/dotfiles/
├── bootstrap.sh              # Main setup script (interactive)
├── Brewfile                   # Essential Homebrew packages
├── Brewfile.optional          # Optional apps (gaming, 3D, music)
├── .env.local.template        # Secrets template
├── CLAUDE.md                  # Claude Code project instructions
├── README.md
│
├── zsh/                       # ← stow package
├── git/                       # ← stow package
├── ssh/                       # ← stow package
├── gh/                        # ← stow package
├── claude/                    # ← stow package
├── ghostty/                   # ← stow package
├── nvim/                      # ← git submodule
│
└── scripts/
    ├── link.sh                # GNU Stow wrapper
    ├── install-oh-my-zsh.sh   # Oh My Zsh + plugins + P10k
    ├── install-nvm-versions.sh # Node.js via NVM
    └── setup-macos-defaults.sh # macOS system preferences
```
