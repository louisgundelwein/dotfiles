#!/bin/bash
set -e

echo "==> Setting up NVM and Node versions..."

export NVM_DIR="$HOME/.nvm"

# Load NVM
if [ -s "/opt/homebrew/opt/nvm/nvm.sh" ]; then
  . "/opt/homebrew/opt/nvm/nvm.sh"
elif [ -s "/usr/share/nvm/init-nvm.sh" ]; then
  . "/usr/share/nvm/init-nvm.sh"
elif [ -s "$NVM_DIR/nvm.sh" ]; then
  . "$NVM_DIR/nvm.sh"
else
  echo "    NVM not found. Install it first (brew install nvm / sudo pacman -S nvm)."
  exit 1
fi

echo "==> Installing Node v22 (LTS)..."
nvm install 22

echo "==> Installing Node v25..."
nvm install 25

echo "==> Setting Node v22 as default..."
nvm alias default 22

echo "==> Node versions installed:"
nvm ls

echo "==> NVM setup complete!"
