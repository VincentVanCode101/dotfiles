#!/usr/bin/env bash
set -Eeou pipefail
selected=$(cat ~/.tmux-cht-languages ~/.tmux-cht-command | fzf)
if [[ -z $selected ]]; then
    exit 0
fi

read -p "Enter Query: " query

if grep -qs "$selected" ~/.tmux-cht-languages; then
    query=$(echo "$query" | tr ' ' '/')
    response=$(curl -s "cht.sh/$selected/$query")
    echo -e "$response"
else
    response=$(curl -s "cht.sh/$selected")
    echo -e "$response" | less
fi
