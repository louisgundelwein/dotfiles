# Dotfiles Repo

Mac setup backup & restore managed with GNU Stow.

## Structure

Each top-level directory is a **stow package** that mirrors the target layout relative to `$HOME`:
- `zsh/.zshrc` → `~/.zshrc`
- `git/.gitconfig` → `~/.gitconfig`
- `ssh/.ssh/config` → `~/.ssh/config`
- `gh/.config/gh/config.yml` → `~/.config/gh/config.yml`
- `claude/.claude/` → `~/.claude/`
- `ghostty/.config/ghostty/config` → `~/.config/ghostty/config`

`nvim/` is a git submodule (LazyVim/starter), not a stow package.

## Stow Packages

The active packages are listed in `scripts/link.sh` in the `STOW_PACKAGES` array. When adding a new package:
1. Create the directory with the correct nested structure mirroring `$HOME`
2. Add the package name to `STOW_PACKAGES` in `scripts/link.sh`
3. Add a row to the table in `README.md`

## Key Conventions

- **No secrets in the repo.** Tokens, keys, and credentials go in `~/.env.local` (sourced by `.zshrc`). The template is `.env.local.template`.
- **No SSH private keys.** Only `~/.ssh/config` is tracked. Keys are managed by 1Password SSH Agent.
- **Brewfile split:** `Brewfile` = essential dev tools (always installed). `Brewfile.optional` = gaming, 3D, music, etc.
- **bootstrap.sh** is the main entry point for fresh Mac setup.
- **scripts/link.sh** uses `stow --adopt --restow` then `git checkout -- .` to ensure repo versions always win over local files.

## Adding New Dotfiles

```bash
# Example: adding a new tool config
mkdir -p ~/dotfiles/toolname/.config/toolname
cp ~/.config/toolname/config ~/dotfiles/toolname/.config/toolname/
# Add "toolname" to STOW_PACKAGES in scripts/link.sh
# Run: ./scripts/link.sh
```
