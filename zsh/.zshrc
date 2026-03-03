# -----------------------------------------------
# Powerlevel10k Instant Prompt (MUST be at top!)
# -----------------------------------------------
typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# -----------------------------------------------
# Oh My Zsh Configuration
# -----------------------------------------------
export ZSH=$HOME/.oh-my-zsh
ZSH_THEME="powerlevel10k/powerlevel10k"

# Plugins
plugins=(
  git
  zsh-syntax-highlighting
  zsh-autosuggestions
  zsh-history-substring-search
  sudo
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

export PNPM_HOME="$HOME/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

export PATH="/opt/homebrew/opt/postgresql@15/bin:$PATH"
export PATH="/opt/homebrew/opt/libpq/bin:$PATH"

path=("$HOME/.juliaup/bin" $path)
export PATH

export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH="$PATH:$ANDROID_HOME/emulator"
export PATH="$PATH:$ANDROID_HOME/platform-tools"

export PATH="$HOME/.antigravity/antigravity/bin:$PATH"

# -----------------------------------------------
# NVM Configuration
# -----------------------------------------------
export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"

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
alias copy="pbcopy"
alias paste="pbpaste"
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
# Tool Completions
# -----------------------------------------------
if command -v openclaw &>/dev/null; then
  source <(openclaw completion --shell zsh)
fi

# -----------------------------------------------
# Claude Environment
# -----------------------------------------------
export CLAUDE_AUTOCOMPACT_PCT_OVERRIDE=50
export CLAUDE_CODE_SUBAGENT_MODEL=haiku

# -----------------------------------------------
# Compiler Flags (libomp)
# -----------------------------------------------
export LDFLAGS="-L/opt/homebrew/opt/libomp/lib"
export CPPFLAGS="-I/opt/homebrew/opt/libomp/include"
export DYLD_LIBRARY_PATH="/opt/homebrew/opt/libomp/lib:$DYLD_LIBRARY_PATH"

# -----------------------------------------------
# System Info (at end)
# -----------------------------------------------
fastfetch
