#!/bin/bash
# Arch-specific setup: symlink pacman-installed zsh plugins/themes into Oh My Zsh
set -e

ZSH_DIR="/usr/share/oh-my-zsh"
ZSH_CUSTOM="${ZSH_CUSTOM:-$ZSH_DIR/custom}"

echo "==> Setting up Arch-specific symlinks..."

# Create custom dirs if needed
mkdir -p "$ZSH_CUSTOM/plugins" "$ZSH_CUSTOM/themes"

# Plugin symlinks (pacman installs to /usr/share/zsh/plugins/)
declare -A PLUGINS=(
  ["zsh-syntax-highlighting"]="/usr/share/zsh/plugins/zsh-syntax-highlighting"
  ["zsh-autosuggestions"]="/usr/share/zsh/plugins/zsh-autosuggestions"
  ["zsh-history-substring-search"]="/usr/share/zsh/plugins/zsh-history-substring-search"
)

for plugin in "${!PLUGINS[@]}"; do
  src="${PLUGINS[$plugin]}"
  dest="$ZSH_CUSTOM/plugins/$plugin"
  if [ -d "$src" ] && [ ! -e "$dest" ]; then
    sudo ln -sf "$src" "$dest"
    echo "    Linked $plugin"
  elif [ -e "$dest" ]; then
    echo "    $plugin already linked"
  else
    echo "    Warning: $src not found, skipping $plugin"
    continue
  fi
  # Oh My Zsh expects <name>.plugin.zsh -- create it if only <name>.zsh exists
  plugin_file="$dest/${plugin}.plugin.zsh"
  zsh_file="$dest/${plugin}.zsh"
  if [ ! -f "$plugin_file" ] && [ -f "$zsh_file" ]; then
    sudo ln -sf "$zsh_file" "$plugin_file"
    echo "    Created .plugin.zsh symlink for $plugin"
  fi
done

# Powerlevel10k theme symlink
P10K_SRC="/usr/share/zsh-theme-powerlevel10k"
P10K_DEST="$ZSH_CUSTOM/themes/powerlevel10k"
if [ -d "$P10K_SRC" ] && [ ! -e "$P10K_DEST" ]; then
  ln -sf "$P10K_SRC" "$P10K_DEST"
  echo "    Linked powerlevel10k theme"
elif [ -e "$P10K_DEST" ]; then
  echo "    powerlevel10k already linked"
fi

# Enable ollama service if installed
if command -v ollama &>/dev/null; then
  echo "==> Enabling ollama service..."
  sudo systemctl enable --now ollama.service 2>/dev/null || true
fi

echo "==> Arch setup complete!"
