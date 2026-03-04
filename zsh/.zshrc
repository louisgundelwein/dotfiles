# -----------------------------------------------
# Powerlevel10k Instant Prompt (MUST be at top!)
# -----------------------------------------------
typeset -g POWERLEVEL9K_INSTANT_PROMPT=off
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# -----------------------------------------------
# OS Detection
# -----------------------------------------------
if [[ "$(uname)" == "Darwin" ]]; then _OS="mac"; else _OS="linux"; fi

# -----------------------------------------------
# Oh My Zsh Configuration
# -----------------------------------------------
if [[ "$_OS" == "mac" ]]; then
  export ZSH="$HOME/.oh-my-zsh"
else
  export ZSH="/usr/share/oh-my-zsh"
fi
ZSH_THEME="powerlevel10k/powerlevel10k"

# Plugins
plugins=(
  git
  zsh-syntax-highlighting
  zsh-autosuggestions
  zsh-history-substring-search
)

# Enable Oh My Zsh
source $ZSH/oh-my-zsh.sh

# Powerlevel10k configuration
if [ -f ~/.p10k.zsh ]; then
  source ~/.p10k.zsh
fi

# -----------------------------------------------
# Environment Variables
# -----------------------------------------------
export EDITOR=nvim

# -----------------------------------------------
# PATH (consolidated)
# -----------------------------------------------
export PATH="/usr/local/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"

if [[ "$_OS" == "mac" ]]; then
  export PNPM_HOME="$HOME/Library/pnpm"
else
  export PNPM_HOME="$HOME/.local/share/pnpm"
fi
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

if [[ "$_OS" == "mac" ]]; then
  export PATH="/opt/homebrew/opt/postgresql@15/bin:$PATH"
  export PATH="/opt/homebrew/opt/libpq/bin:$PATH"
fi

path=("$HOME/.juliaup/bin" $path)
export PATH

if [[ "$_OS" == "mac" ]]; then
  export ANDROID_HOME=$HOME/Library/Android/sdk
  export PATH="$PATH:$ANDROID_HOME/emulator"
  export PATH="$PATH:$ANDROID_HOME/platform-tools"
fi

export PATH="$HOME/.antigravity/antigravity/bin:$PATH"

# -----------------------------------------------
# NVM Configuration (lazy-loaded for speed)
# -----------------------------------------------
export NVM_DIR="$HOME/.nvm"
if [[ "$_OS" == "mac" ]]; then
  nvm() {
    unfunction nvm node npm npx 2>/dev/null
    [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"
    [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"
    nvm "$@"
  }
  node() { nvm use default >/dev/null 2>&1; node "$@" }
  npm() { nvm use default >/dev/null 2>&1; npm "$@" }
  npx() { nvm use default >/dev/null 2>&1; npx "$@" }
else
  [ -s "/usr/share/nvm/init-nvm.sh" ] && \. "/usr/share/nvm/init-nvm.sh"
fi

# -----------------------------------------------
# 1Password SSH Agent
# -----------------------------------------------
export SSH_AUTH_SOCK=~/.1password/agent.sock

# -----------------------------------------------
# Aliases
# -----------------------------------------------
alias ll="ls -lah"
alias vim="nvim"
alias gs="git status"
alias ga="git add ."
alias gc="git commit -m"
alias gp="git push"

if [[ "$_OS" == "mac" ]]; then
  alias copy="pbcopy"
  alias paste="pbpaste"
else
  alias copy="wl-copy"
  alias paste="wl-paste"
fi

alias dockerbuildllc='grep -v "^[# ]" .env | xargs -I {} docker build -t titanomtechnologies/langenscheidt-language-coach:latest --build-arg {} .'

# -----------------------------------------------
# Custom Functions
# -----------------------------------------------
mkcd() {
  mkdir -p "$1" && cd "$1"
}

extract() {
  if [ -f "$1" ]; then
    case "$1" in
      *.tar.bz2) tar xjf "$1" ;;
      *.tar.gz) tar xzf "$1" ;;
      *.bz2) bunzip2 "$1" ;;
      *.rar) unrar x "$1" ;;
      *.gz) gunzip "$1" ;;
      *.tar) tar xf "$1" ;;
      *.tbz2) tar xjf "$1" ;;
      *.tgz) tar xzf "$1" ;;
      *.zip) unzip "$1" ;;
      *.Z) uncompress "$1" ;;
      *.7z) 7z x "$1" ;;
      *) echo "'$1' cannot be extracted via extract()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

fetch() {
  echo "
const response = await fetch('url', {
	method: 'POST',
	body: JSON.stringify({ object }),
	headers: {
		'Content-Type': 'application/json',
	},
});
"
}

# -----------------------------------------------
# Source secrets (NPM_TOKEN, etc.)
# -----------------------------------------------
[ -f ~/.env.local ] && source ~/.env.local


# -----------------------------------------------
# Claude Environment
# -----------------------------------------------
export CLAUDE_AUTOCOMPACT_PCT_OVERRIDE=50
export CLAUDE_CODE_SUBAGENT_MODEL=haiku

# -----------------------------------------------
# Compiler Flags (macOS only)
# -----------------------------------------------
if [[ "$_OS" == "mac" ]]; then
  export LDFLAGS="-L/opt/homebrew/opt/libomp/lib"
  export CPPFLAGS="-I/opt/homebrew/opt/libomp/include"
  export DYLD_LIBRARY_PATH="/opt/homebrew/opt/libomp/lib:$DYLD_LIBRARY_PATH"
fi

# -----------------------------------------------
# SSH hosts.local check
# -----------------------------------------------
if [[ ! -f ~/.ssh/hosts.local ]] || [[ ! -s ~/.ssh/hosts.local ]]; then
  echo "⚠  ~/.ssh/hosts.local is missing or empty. SSH host aliases won't resolve."
  echo "   Copy the template: cp ~/dotfiles/ssh/.ssh/hosts.local.template ~/.ssh/hosts.local"
fi

# -----------------------------------------------
# System Info
# -----------------------------------------------
fastfetch

