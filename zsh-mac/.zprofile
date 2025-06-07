alias k="kubectl"
alias dfu="docker compose -f docker-compose.dev.yml up"
alias dfd="docker compose -f docker-compose.dev.yml down"
alias dfb="docker compose -f docker-compose.dev.yml build"
alias dcb="docker compose build"
alias dcu="docker compose up"
alias dcd="docker compose down"
alias fd="fdfind"
alias bat="batcat"

export PATH="$PATH:$HOME/little-projects/unix-shell-scripts"
export PATH="$PATH:$HOME/docker-apps/bin"
export PATH="$PATH:$HOME/projects/toolbox-exec"
export PATH="$PATH:$HOME/.local/scripts"

######################################################################################
# Custom Keyboard Shortcuts
######################################################################################

# Alt+e
bindkey -s "^[e" "connectToContainer.sh\n"

# Alt+a
bindkey -s "^[a" "gitAdd.sh\n"

# Alt+g
bindkey -s "^[g" "gitcheckoutFZF\n"

# Ctrl+f
bindkey -s ^f "tmux-sessionizer\n"

bindkey "^[r" fzf-history-widget

eval "$(/opt/homebrew/bin/brew shellenv)"

# Added by OrbStack: command-line tools and integration
# This won't be added again if you remove it.
source ~/.orbstack/shell/init.zsh 2>/dev/null || :

source /opt/homebrew/share/powerlevel10k/powerlevel10k.zsh-theme


export FZF_DEFAULT_COMMAND="find ~/ -maxdepth 4 -type d ! -path '*/.git/*' ! -path '*/.vscode/*' 2> /dev/null"

export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_DEFAULT_OPTS="--height 90% --ansi"

if [[ $FIND_IT_FASTER_ACTIVE -eq 1 ]]; then
  FZF_DEFAULT_OPTS='--height=70%'
fi

source <(fzf --zsh)