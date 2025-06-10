# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh


######################################################################################
# ALIAS
######################################################################################

alias k="kubectl"
alias dfu="docker compose -f docker-compose.dev.yml up"
alias dfd="docker compose -f docker-compose.dev.yml down"
alias dfb="docker compose -f docker-compose.dev.yml build"
alias dcb="docker compose build"
alias dcu="docker compose up"
alias dcd="docker compose down"
alias fd="fdfind"
alias bat="batcat"

######################################################################################
# PATHS
######################################################################################

export PATH="$PATH:/opt/homebrew/bin"
export PATH="$PATH:$HOME/little-projects/unix-shell-scripts"
export PATH="$PATH:$HOME/projects/docker-apps/bin"
export PATH="$PATH:$HOME/projects/toolbox-exec"
export PATH="$PATH:$HOME/.local/scripts"

######################################################################################
# CUSTOM KEYBOARD SHORTCUTS
######################################################################################

# Alt+e
bindkey -s "^[e" "connectToContainer.sh\n"

# Alt+a
bindkey -s "^[a" "gitAdd.sh\n"

# Alt+g
bindkey -s "^[g" "gitcheckoutFZF\n"

# Ctrl+f
bindkey -s ^f "tmux-sessionizer\n"

######################################################################################
# BREW
######################################################################################

eval "$(/opt/homebrew/bin/brew shellenv)"

# Added by OrbStack: command-line tools and integration
# This won't be added again if you remove it.
source ~/.orbstack/shell/init.zsh 2>/dev/null || :

######################################################################################
# P10K
######################################################################################

source /opt/homebrew/share/powerlevel10k/powerlevel10k.zsh-theme

######################################################################################
# 
######################################################################################

export FZF_DEFAULT_COMMAND="find ~/ -maxdepth 4 -type d ! -path '*/.git/*' ! -path '*/.vscode/*' 2> /dev/null"

export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_DEFAULT_OPTS="--height 90% --ansi"

if [[ $FIND_IT_FASTER_ACTIVE -eq 1 ]]; then
  FZF_DEFAULT_OPTS='--height=70%'
fi

source <(fzf --zsh)

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

setopt APPEND_HISTORY             # Append to the history file, don’t overwrite
setopt INC_APPEND_HISTORY         # Write to the history file immediately
setopt SHARE_HISTORY              # Share command history across terminals
setopt HIST_IGNORE_ALL_DUPS       # Prevent duplicates
