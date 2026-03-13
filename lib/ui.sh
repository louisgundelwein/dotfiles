#!/bin/bash
# UI functions: colors, prompts, menus

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
BOLD='\033[1m'
NC='\033[0m'

info()    { echo -e "${BLUE}==> $1${NC}"; }
success() { echo -e "${GREEN}==> $1${NC}"; }
warn()    { echo -e "${YELLOW}==> $1${NC}"; }
error()   { echo -e "${RED}==> $1${NC}"; }

banner() {
  local os_label
  if [[ "$DOTFILES_OS" == "mac" ]]; then
    os_label="macOS (Homebrew)"
  elif [[ "$DOTFILES_DISTRO" == "arch" ]]; then
    os_label="Linux (Arch/CachyOS)"
  else
    os_label="Linux (unknown distro)"
  fi

  echo ""
  echo "╔══════════════════════════════════════╗"
  echo "║       Dotfiles Bootstrap Setup       ║"
  echo "╚══════════════════════════════════════╝"
  echo ""
  echo -e "  Detected: ${BOLD}${os_label}${NC}"
  echo -e "  Package Manager: ${BOLD}${DOTFILES_PKG_MGR}${NC}"
  if [[ -n "$DOTFILES_AUR_HELPER" ]]; then
    echo -e "  AUR Helper: ${BOLD}${DOTFILES_AUR_HELPER}${NC}"
  fi
  echo ""
}

# Interactive category selection
# Sets SELECTED_CATEGORIES array
select_categories() {
  local categories=(
    "Dev Tools      - CLI tools (neovim, ripgrep, lazygit, etc.)"
    "Shell Setup    - Zsh + Oh My Zsh + Plugins + Powerlevel10k"
    "Node.js        - NVM + Node v22/v25"
    "Apps           - GUI apps (Browser, Editor, Terminal, etc.)"
    "Cloud/Deploy   - supabase, stripe, nixpacks, etc."
    "Dotfiles       - Symlink configs via Stow"
    "Neovim         - LazyVim config (git submodule)"
    "macOS Defaults - Dock, Finder, Keyboard (macOS only)"
    "Optional       - Gaming, 3D, Music, etc."
  )

  echo "Select categories to install (space-separated numbers, e.g. 1 2 3 6):"
  echo ""
  for i in "${!categories[@]}"; do
    local num=$((i + 1))
    # Dim macOS Defaults on Linux
    if [[ $num -eq 8 && "$DOTFILES_OS" != "mac" ]]; then
      echo -e "  ${BOLD}[$num]${NC} ${YELLOW}${categories[$i]} (skipped on Linux)${NC}"
    else
      echo -e "  ${BOLD}[$num]${NC} ${categories[$i]}"
    fi
  done
  echo ""
  read -rp "Categories: " CATEGORY_INPUT

  SELECTED_CATEGORIES=()
  for num in $CATEGORY_INPUT; do
    if [[ "$num" =~ ^[1-9]$ ]]; then
      SELECTED_CATEGORIES+=("$num")
    fi
  done
}
