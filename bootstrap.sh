#!/bin/bash
set -e

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

info() { echo -e "${BLUE}==> $1${NC}"; }
success() { echo -e "${GREEN}==> $1${NC}"; }
warn() { echo -e "${YELLOW}==> $1${NC}"; }

echo ""
echo "╔══════════════════════════════════════╗"
echo "║     Mac Dotfiles Bootstrap Setup     ║"
echo "╚══════════════════════════════════════╝"
echo ""
echo "Choose an installation mode:"
echo ""
echo "  1) Full Installation (Essential + Optional)"
echo "  2) Essential Only"
echo "  3) Symlinks Only (dotfiles already set up)"
echo "  4) Brewfile Only (install packages)"
echo ""
read -rp "Selection [1-4]: " CHOICE

install_xcode_tools() {
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
  if ! command -v brew &>/dev/null; then
    info "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/opt/homebrew/bin/brew shellenv)"
  else
    success "Homebrew already installed."
  fi
}

install_brewfile() {
  info "Installing essential Brew packages..."
  brew bundle --file="$DOTFILES_DIR/Brewfile"

  if [ "${1:-}" = "full" ]; then
    echo ""
    read -rp "Install optional apps (gaming, 3D, music, etc.)? [y/N]: " OPTIONAL
    if [[ "$OPTIONAL" =~ ^[Yy]$ ]]; then
      info "Installing optional Brew packages..."
      brew bundle --file="$DOTFILES_DIR/Brewfile.optional"
    fi
  fi
}

install_oh_my_zsh() {
  info "Setting up Oh My Zsh..."
  "$DOTFILES_DIR/scripts/install-oh-my-zsh.sh"
}

install_node() {
  info "Setting up Node via NVM..."
  "$DOTFILES_DIR/scripts/install-nvm-versions.sh"
}

link_dotfiles() {
  info "Linking dotfiles..."
  "$DOTFILES_DIR/scripts/link.sh"
}

setup_macos() {
  read -rp "Apply macOS defaults (Dock, Finder, keyboard)? [y/N]: " MACOS
  if [[ "$MACOS" =~ ^[Yy]$ ]]; then
    "$DOTFILES_DIR/scripts/setup-macos-defaults.sh"
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

init_submodules() {
  info "Initializing git submodules (nvim config)..."
  cd "$DOTFILES_DIR"
  git submodule update --init --recursive
}

case "$CHOICE" in
  1)
    install_xcode_tools
    install_homebrew
    install_brewfile "full"
    install_oh_my_zsh
    install_node
    init_submodules
    link_dotfiles
    setup_macos
    setup_secrets
    ;;
  2)
    install_xcode_tools
    install_homebrew
    install_brewfile
    install_oh_my_zsh
    install_node
    init_submodules
    link_dotfiles
    setup_macos
    setup_secrets
    ;;
  3)
    link_dotfiles
    ;;
  4)
    install_brewfile "full"
    ;;
  *)
    echo "Invalid selection."
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
