#!/bin/bash
set -e

DOTFILES_DIR="$(cd "$(dirname "$0")/.." && pwd)"
STOW_PACKAGES=(zsh git ssh gh claude ghostty)

echo "==> Linking dotfiles with GNU Stow..."

if ! command -v stow &>/dev/null; then
  echo "    Error: GNU Stow not installed. Run: brew install stow (macOS) or sudo pacman -S stow (Arch)"
  exit 1
fi

for pkg in "${STOW_PACKAGES[@]}"; do
  echo "    Linking $pkg..."

  # Use --adopt to move existing files into the stow directory,
  # then restore them from git to ensure repo version wins.
  stow --dir="$DOTFILES_DIR" --target="$HOME" --adopt --restow "$pkg" 2>&1 || true
  echo "    $pkg linked."
done

# Restore repo versions (--adopt may have overwritten them with existing files)
echo "==> Restoring repo versions..."
cd "$DOTFILES_DIR"
git checkout -- .

echo "==> All dotfiles linked!"
