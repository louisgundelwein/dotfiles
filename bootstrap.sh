#!/bin/bash
set -e

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

# Source libraries
source "$DOTFILES_DIR/lib/detect.sh"
source "$DOTFILES_DIR/lib/ui.sh"
source "$DOTFILES_DIR/lib/packages.sh"

# -----------------------------------------------
# Installation functions
# -----------------------------------------------

install_xcode_tools() {
  if [[ "$DOTFILES_OS" != "mac" ]]; then return; fi
  if ! xcode-select -p &>/dev/null; then
    info "Installing Xcode Command Line Tools..."
    xcode-select --install
    echo "    Press any key after Xcode tools finish installing..."
    read -rn 1
  else
    success "Xcode Command Line Tools already installed."
  fi
}

install_homebrew() {
  if [[ "$DOTFILES_OS" != "mac" ]]; then return; fi
  if ! command -v brew &>/dev/null; then
    info "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/opt/homebrew/bin/brew shellenv)"
  else
    success "Homebrew already installed."
  fi
}

install_dev_tools() {
  info "Installing dev tools..."
  if [[ "$DOTFILES_OS" == "mac" ]]; then
    install_brew_packages "$DOTFILES_DIR/Brewfile"
  elif [[ "$DOTFILES_DISTRO" == "arch" ]]; then
    install_pacman_packages "$DOTFILES_DIR/packages/pacman-essential.txt"
    install_aur_packages "$DOTFILES_DIR/packages/aur-essential.txt"
  fi
}

install_shell() {
  info "Setting up shell..."
  "$DOTFILES_DIR/scripts/install-oh-my-zsh.sh"
}

install_node() {
  info "Setting up Node via NVM..."
  "$DOTFILES_DIR/scripts/install-nvm-versions.sh"
}

install_apps() {
  info "Installing apps..."
  if [[ "$DOTFILES_OS" == "mac" ]]; then
    success "Apps installed via Brewfile."
  elif [[ "$DOTFILES_DISTRO" == "arch" ]]; then
    success "Apps installed via pacman/AUR."
  fi
}

install_cloud_deploy() {
  info "Installing cloud/deploy tools..."
  if [[ "$DOTFILES_OS" == "mac" ]]; then
    success "Cloud tools installed via Brewfile."
  elif [[ "$DOTFILES_DISTRO" == "arch" ]]; then
    warn "Cloud tools (supabase, stripe, nixpacks) - install manually or via AUR."
  fi
}

link_dotfiles() {
  info "Linking dotfiles..."
  "$DOTFILES_DIR/scripts/link.sh"
}

init_submodules() {
  info "Initializing git submodules (nvim config)..."
  cd "$DOTFILES_DIR"
  git submodule update --init --recursive
}

setup_macos_defaults() {
  if [[ "$DOTFILES_OS" != "mac" ]]; then
    warn "macOS defaults only available on macOS. Skipping."
    return
  fi
  read -rp "Apply macOS defaults (Dock, Finder, keyboard)? [y/N]: " MACOS
  if [[ "$MACOS" =~ ^[Yy]$ ]]; then
    "$DOTFILES_DIR/scripts/setup-macos-defaults.sh"
  fi
}

setup_arch() {
  if [[ "$DOTFILES_DISTRO" != "arch" ]]; then return; fi
  info "Running Arch-specific setup..."
  "$DOTFILES_DIR/scripts/setup-arch.sh"
}

install_optional() {
  echo ""
  read -rp "Install optional packages (gaming, 3D, music, etc.)? [y/N]: " OPTIONAL
  if [[ ! "$OPTIONAL" =~ ^[Yy]$ ]]; then return; fi

  if [[ "$DOTFILES_OS" == "mac" ]]; then
    install_brew_packages "$DOTFILES_DIR/Brewfile.optional"
  elif [[ "$DOTFILES_DISTRO" == "arch" ]]; then
    install_pacman_packages "$DOTFILES_DIR/packages/pacman-optional.txt"
    install_aur_packages "$DOTFILES_DIR/packages/aur-optional.txt"
  fi
}

patch_claude_settings() {
  local settings_file="$HOME/.claude/settings.json"
  if [ -f "$settings_file" ]; then
    if grep -q "/Users/louisgundelwein/" "$settings_file" 2>/dev/null; then
      sed -i.bak "s|/Users/louisgundelwein/|${HOME}/|g" "$settings_file"
      rm -f "${settings_file}.bak"
      success "Patched Claude settings with correct home path."
    fi
  fi
}

setup_secrets() {
  echo ""
  warn "Secrets setup:"
  if [ ! -f "$HOME/.env.local" ]; then
    echo "    Copy the template and fill in your tokens:"
    echo "    cp $DOTFILES_DIR/.env.local.template ~/.env.local"
  else
    success "~/.env.local already exists."
  fi
}

# -----------------------------------------------
# Run a category by number
# -----------------------------------------------
run_category() {
  case "$1" in
    1) install_dev_tools ;;
    2) install_shell; setup_arch ;;
    3) install_node ;;
    4) install_apps ;;
    5) install_cloud_deploy ;;
    6) link_dotfiles; patch_claude_settings ;;
    7) init_submodules ;;
    8) setup_macos_defaults ;;
    9) install_optional ;;
  esac
}

# -----------------------------------------------
# Main
# -----------------------------------------------
banner

echo "Choose an installation mode:"
echo ""
echo "  1) Full Installation (everything)"
echo "  2) Custom Installation (choose categories)"
echo "  3) Symlinks Only"
echo "  4) Packages Only"
echo ""
read -rp "Selection [1-4]: " CHOICE

case "$CHOICE" in
  1)
    install_xcode_tools
    install_homebrew
    install_dev_tools
    install_shell
    install_node
    init_submodules
    link_dotfiles
    setup_arch
    patch_claude_settings
    setup_macos_defaults
    install_optional
    setup_secrets
    ;;
  2)
    select_categories
    install_xcode_tools
    install_homebrew
    for cat_num in "${SELECTED_CATEGORIES[@]}"; do
      run_category "$cat_num"
    done
    setup_secrets
    ;;
  3)
    link_dotfiles
    patch_claude_settings
    ;;
  4)
    install_xcode_tools
    install_homebrew
    install_dev_tools
    ;;
  *)
    error "Invalid selection."
    exit 1
    ;;
esac

echo ""
success "Setup complete!"
echo ""
echo "Next steps:"
echo "  - Open a new terminal to load the new config"
echo "  - Set up secrets: cp .env.local.template ~/.env.local"
echo "  - Import SSH keys to 1Password (see README.md)"
echo ""
