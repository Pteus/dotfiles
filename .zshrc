# Path to your Oh My Zsh installation
export ZSH="$HOME/.oh-my-zsh"

# Theme
ZSH_THEME=""

# Speed up `compinit` by skipping security checks on most startups
autoload -Uz compinit
ZSH_COMPDUMP="${ZSH_COMPDUMP:-$HOME/.zcompdump}"
if [[ -f "$ZSH_COMPDUMP" && -z "$(find "$ZSH_COMPDUMP" -mmin +1440)" ]]; then
  compinit -C  # Fast mode (skips security check)
else
  compinit     # Full check (runs once per day)
fi

# Plugins (Keep only essentials)
plugins=(git)

source $ZSH/oh-my-zsh.sh

# Language settings
export LC_ALL='en_US.UTF-8'
export LANG='en_US.UTF-8'

# ZigUp
export PATH="$HOME/Zig/zigup:$PATH"

# NPM global installs
export PATH="$HOME/.npm-global/bin:$PATH"

# PostgreSQL
export PATH="/usr/local/opt/libpq/bin:$PATH"

# Go environment
eval "$(goenv init -)"

# Zoxide (Fast directory navigation)
eval "$(zoxide init --cmd cd zsh)"

# Aliases
alias vim=nvim
alias air="$HOME/go/1.23.3/bin/air"
alias python="python3"

eval "$(starship init zsh)"

# zsh autosuggestions
source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# zsh syntax highlightning
source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh