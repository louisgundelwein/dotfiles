#!/bin/bash
# Package installation abstraction

# Read a package list file, strip comments and blank lines
_read_package_list() {
  grep -v '^\s*#' "$1" | grep -v '^\s*$' | sed 's/\s*#.*//' | tr -s ' '
}

install_pacman_packages() {
  local file="$1"
  if [ ! -f "$file" ]; then
    warn "Package list not found: $file"
    return 1
  fi
  local packages
  packages=$(_read_package_list "$file")
  if [ -z "$packages" ]; then
    warn "No packages found in $file"
    return 0
  fi
  info "Installing pacman packages from $(basename "$file")..."
  echo "$packages" | xargs sudo pacman -S --needed --noconfirm
}

install_aur_packages() {
  local file="$1"
  if [ ! -f "$file" ]; then
    warn "Package list not found: $file"
    return 1
  fi
  if [ -z "$DOTFILES_AUR_HELPER" ]; then
    warn "No AUR helper found (paru/yay). Skipping AUR packages."
    return 1
  fi
  local packages
  packages=$(_read_package_list "$file")
  if [ -z "$packages" ]; then
    warn "No packages found in $file"
    return 0
  fi
  info "Installing AUR packages from $(basename "$file")..."
  echo "$packages" | xargs "$DOTFILES_AUR_HELPER" -S --needed --noconfirm
}

install_brew_packages() {
  local file="$1"
  if [ ! -f "$file" ]; then
    warn "Brewfile not found: $file"
    return 1
  fi
  info "Installing Brew packages from $(basename "$file")..."
  brew bundle --file="$file"
}
