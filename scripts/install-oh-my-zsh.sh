#!/bin/bash
set -e

# Detect OS
if [[ "$(uname)" == "Darwin" ]]; then _OS="mac"; else _OS="linux"; fi

echo "==> Installing Oh My Zsh..."

if [[ "$_OS" == "mac" ]]; then
  # macOS: clone Oh My Zsh and plugins from git
  if [ -d "$HOME/.oh-my-zsh" ]; then
    echo "    Oh My Zsh already installed, skipping."
  else
    RUNZSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  fi

  ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

  echo "==> Installing zsh plugins..."

  # zsh-syntax-highlighting
  if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
  else
    echo "    zsh-syntax-highlighting already installed."
  fi

  # zsh-autosuggestions
  if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions.git "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
  else
    echo "    zsh-autosuggestions already installed."
  fi

  # zsh-history-substring-search
  if [ ! -d "$ZSH_CUSTOM/plugins/zsh-history-substring-search" ]; then
    git clone https://github.com/zsh-users/zsh-history-substring-search.git "$ZSH_CUSTOM/plugins/zsh-history-substring-search"
  else
    echo "    zsh-history-substring-search already installed."
  fi

  echo "==> Installing Powerlevel10k theme..."

  if [ ! -d "$ZSH_CUSTOM/themes/powerlevel10k" ]; then
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$ZSH_CUSTOM/themes/powerlevel10k"
  else
    echo "    Powerlevel10k already installed."
  fi
else
  # Linux/Arch: plugins installed via pacman, just need symlinks
  echo "    On Linux, Oh My Zsh and plugins are installed via pacman."
  echo "    Running setup-arch.sh for symlinks..."
  DOTFILES_DIR="$(cd "$(dirname "$0")/.." && pwd)"
  "$DOTFILES_DIR/scripts/setup-arch.sh"
fi

echo "==> Oh My Zsh setup complete!"
