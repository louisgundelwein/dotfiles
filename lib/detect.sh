#!/bin/bash
# OS/Distro/Package Manager detection
# Sets global variables used by bootstrap.sh and other scripts

detect_os() {
  case "$(uname -s)" in
    Darwin) DOTFILES_OS="mac" ;;
    Linux)  DOTFILES_OS="linux" ;;
    *)      DOTFILES_OS="unknown" ;;
  esac

  # Distro detection (Linux only)
  DOTFILES_DISTRO="unknown"
  if [[ "$DOTFILES_OS" == "linux" ]] && [ -f /etc/os-release ]; then
    local id id_like
    id=$(grep "^ID=" /etc/os-release | cut -d= -f2 | tr -d '"')
    id_like=$(grep "^ID_LIKE=" /etc/os-release | cut -d= -f2 | tr -d '"')
    if [[ "$id" == "arch" || "$id_like" == *"arch"* ]]; then
      DOTFILES_DISTRO="arch"
    fi
  fi

  # Package manager
  if [[ "$DOTFILES_OS" == "mac" ]]; then
    DOTFILES_PKG_MGR="brew"
  elif [[ "$DOTFILES_DISTRO" == "arch" ]]; then
    DOTFILES_PKG_MGR="pacman"
  else
    DOTFILES_PKG_MGR="unknown"
  fi

  # AUR helper detection
  DOTFILES_AUR_HELPER=""
  if [[ "$DOTFILES_DISTRO" == "arch" ]]; then
    if command -v paru &>/dev/null; then
      DOTFILES_AUR_HELPER="paru"
    elif command -v yay &>/dev/null; then
      DOTFILES_AUR_HELPER="yay"
    fi
  fi

  export DOTFILES_OS DOTFILES_DISTRO DOTFILES_PKG_MGR DOTFILES_AUR_HELPER
}

detect_os
