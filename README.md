# Dotfiles

Cross-platform setup for **macOS** and **Linux (Arch/CachyOS)**. Managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Quick Start

### One-liner (fresh machine)

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/louisgundelwein/dotfiles/main/install.sh)
```

This clones the repo to `~/dotfiles` and launches the interactive bootstrap.

### Manual

```bash
git clone --recursive git@github.com:louisgundelwein/dotfiles.git ~/dotfiles
cd ~/dotfiles
./bootstrap.sh
```

## Bootstrap Modes

The bootstrap script detects your OS automatically and offers:

1. **Full Installation** — All packages, configs, and symlinks
2. **Custom Installation** — Pick categories interactively:
   - `[1]` Dev Tools - CLI tools (neovim, ripgrep, lazygit, etc.)
   - `[2]` Shell Setup - Zsh + Oh My Zsh + Plugins + Powerlevel10k
   - `[3]` Node.js - NVM + Node v22/v25
   - `[4]` Apps - GUI apps (Browser, Editor, Terminal, etc.)
   - `[5]` Cloud/Deploy - supabase, stripe, nixpacks, etc.
   - `[6]` Dotfiles - Symlink configs via Stow
   - `[7]` Neovim - LazyVim config (git submodule)
   - `[8]` macOS Defaults - Dock, Finder, Keyboard (macOS only)
   - `[9]` Optional - Gaming, 3D, Music, etc.
3. **Symlinks Only** — Just link dotfiles (packages already installed)
4. **Packages Only** — Just install packages (no symlinks)

### What bootstrap does

**macOS:**
1. Installs Xcode Command Line Tools
2. Installs [Homebrew](https://brew.sh/)
3. Runs `brew bundle` from `Brewfile`

**Linux (Arch/CachyOS):**
1. Installs packages via `pacman` from `packages/pacman-essential.txt`
2. Installs AUR packages via `paru`/`yay` from `packages/aur-essential.txt`
3. Symlinks pacman-installed zsh plugins into Oh My Zsh

**Both:**
4. Sets up Oh My Zsh + plugins + Powerlevel10k
5. Installs Node.js versions via NVM
6. Initializes git submodules (Neovim config)
7. Links all dotfiles via GNU Stow
8. Patches Claude settings with correct home path

## What's Included

| Directory | Contents | Symlinks to |
|-----------|----------|-------------|
| `zsh/` | Shell config (`.zshrc`, `.zprofile`, `.zshenv`, `.p10k.zsh`) | `~/` |
| `git/` | Git config + global gitignore | `~/` |
| `ssh/` | SSH host aliases (IPs stored separately, see below) | `~/.ssh/` |
| `gh/` | GitHub CLI config | `~/.config/gh/` |
| `claude/` | Claude Code settings, hooks, RTK config | `~/.claude/` |
| `ghostty/` | Ghostty terminal config (Dracula+ theme) | `~/.config/ghostty/` |
| `nvim/` | Neovim config (git submodule -> [LazyVim](https://github.com/LazyVim/starter)) | -- |
| `scripts/` | Helper scripts (not symlinked) | -- |
| `lib/` | Shared shell functions (detect, ui, packages) | -- |
| `packages/` | Linux package lists (pacman/AUR) | -- |

## Linux Package Lists

Package lists in `packages/` are plain text files with one package per line. Comments (`#`) and inline comments are supported:

```
# Dev Tools
neovim
ripgrep
github-cli    # (brew: gh)
```

| File | Contents |
|------|----------|
| `pacman-essential.txt` | Core Arch packages (maps to Brewfile) |
| `pacman-optional.txt` | Optional Arch packages |
| `aur-essential.txt` | Essential AUR packages |
| `aur-optional.txt` | Optional AUR packages |

## How Stow Works

Each top-level directory is a "stow package". The folder structure inside mirrors your home directory. When you run `stow zsh`, it creates symlinks from `zsh/.zshrc` -> `~/.zshrc`, etc.

The `scripts/link.sh` wrapper handles all packages at once using `--adopt` mode -- if a file already exists at the target, stow adopts it, then `git checkout` restores the repo version so the repo always wins.

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

### After adding a new package

```bash
# macOS
brew bundle --file=~/dotfiles/Brewfile

# Arch
sudo pacman -S --needed package-name
```

### Pulling changes on another machine

```bash
cd ~/dotfiles
git pull
./scripts/link.sh    # Re-link in case new packages were added
```

## Optional Apps

Gaming, 3D printing, music/DJ, and other optional apps:

```bash
# macOS
brew bundle --file=Brewfile.optional

# Arch (via bootstrap menu or manually)
sudo pacman -S --needed - < packages/pacman-optional.txt
paru -S --needed - < packages/aur-optional.txt
```

## Secrets

Tokens and secrets are stored in `~/.env.local` (never committed). The `.zshrc` sources this file automatically.

```bash
cp .env.local.template ~/.env.local
# Edit ~/.env.local and add your tokens (NPM_TOKEN, etc.)
```

## SSH Keys & Host IPs

SSH keys are managed via **1Password SSH Agent** -- no private keys on disk needed.

Host **IP addresses** are stored in `~/.ssh/hosts.local` (not in this repo). On a new machine:

1. Install 1Password and enable the SSH Agent (Settings -> Developer)
2. Run `./bootstrap.sh` to link the SSH config
3. Copy `ssh/.ssh/hosts.local.template` to `~/.ssh/hosts.local` and fill in the IPs
4. Tip: Store `hosts.local` as a document in 1Password for easy transfer between machines

```bash
cp ~/dotfiles/ssh/.ssh/hosts.local.template ~/.ssh/hosts.local
# Fill in the real IPs, then test:
ssh ucm-staging
```

## macOS Defaults

The setup script applies some system preferences (macOS only):

- Dock: autohide enabled, smaller icon size
- Finder: show path bar, show hidden files
- Keyboard: fast key repeat, short delay
- Trackpad: tap to click

Re-apply anytime: `./scripts/setup-macos-defaults.sh`

## Structure

```
~/dotfiles/
├── install.sh                # Remote one-liner entry point
├── bootstrap.sh              # Main setup script (OS-aware, interactive)
├── Brewfile                  # Essential Homebrew packages (macOS)
├── Brewfile.optional         # Optional Homebrew packages (macOS)
├── .env.local.template       # Secrets template
├── CLAUDE.md                 # Claude Code project instructions
├── README.md
│
├── lib/                      # Shared shell functions
│   ├── detect.sh             #   OS/Distro/Package manager detection
│   ├── ui.sh                 #   Colors, prompts, menu functions
│   └── packages.sh           #   Package install abstraction
│
├── packages/                 # Linux package lists
│   ├── pacman-essential.txt  #   Arch core packages
│   ├── pacman-optional.txt   #   Arch optional packages
│   ├── aur-essential.txt     #   AUR essential packages
│   └── aur-optional.txt      #   AUR optional packages
│
├── zsh/                      # <- stow package (cross-platform)
├── git/                      # <- stow package
├── ssh/                      # <- stow package
├── gh/                       # <- stow package
├── claude/                   # <- stow package
├── ghostty/                  # <- stow package
├── nvim/                     # <- git submodule
│
└── scripts/
    ├── link.sh               # GNU Stow wrapper
    ├── install-oh-my-zsh.sh  # Oh My Zsh + plugins + P10k (OS-aware)
    ├── install-nvm-versions.sh # Node.js via NVM (OS-aware)
    ├── setup-macos-defaults.sh # macOS system preferences
    └── setup-arch.sh         # Arch-specific setup (plugin symlinks)
```
