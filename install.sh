#!/bin/bash
# Remote one-liner entry point:
#   bash <(curl -fsSL https://raw.githubusercontent.com/louisgundelwein/dotfiles/main/install.sh)
set -e

DOTFILES_DIR="$HOME/dotfiles"
REPO_URL="https://github.com/louisgundelwein/dotfiles.git"

# Check for git
if ! command -v git &>/dev/null; then
  echo "Error: git is not installed."
  if [[ "$(uname)" == "Darwin" ]]; then
    echo "  Run: xcode-select --install"
  else
    echo "  Run: sudo pacman -S git"
  fi
  exit 1
fi

# Clone or update
if [ -d "$DOTFILES_DIR" ]; then
  echo "~/dotfiles already exists."
  read -rp "Pull latest changes? [y/N]: " PULL
  if [[ "$PULL" =~ ^[Yy]$ ]]; then
    cd "$DOTFILES_DIR"
    git pull --rebase
  else
    echo "Aborted."
    exit 0
  fi
else
  echo "Cloning dotfiles..."
  git clone --recursive "$REPO_URL" "$DOTFILES_DIR"
fi

# Run bootstrap
exec bash "$DOTFILES_DIR/bootstrap.sh"
