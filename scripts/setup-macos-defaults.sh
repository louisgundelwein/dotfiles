#!/bin/bash
set -e

echo "==> Configuring macOS defaults..."

# Dock: auto-hide
defaults write com.apple.dock autohide -bool true

# Dock: minimize animation
defaults write com.apple.dock mineffect -string "scale"

# Finder: show path bar
defaults write com.apple.finder ShowPathbar -bool true

# Finder: show status bar
defaults write com.apple.finder ShowStatusBar -bool true

# Finder: show file extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Keyboard: fast key repeat
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15

# Trackpad: tap to click
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true

# Screenshots: save to clipboard by default
defaults write com.apple.screencapture target -string "clipboard"

# Disable auto-correct
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

# Show hidden files in Finder
defaults write com.apple.finder AppleShowAllFiles -bool true

echo "==> Restarting Dock and Finder..."
killall Dock 2>/dev/null || true
killall Finder 2>/dev/null || true

echo "==> macOS defaults configured!"
