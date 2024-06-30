#!/usr/bin/env bash

BRANCH=$(cat .git-branch-types | fzf)

if [[ -z $BRANCH ]]; then
    exit 0
fi

BRANCH_TYPE=$(echo "$BRANCH" | cut -d ':' -f 1)

read -p "Enter branch scope: " SCOPE
read -p "Enter branch subject: " SUBJECT 

SUBJECT=$(echo "$SUBJECT" | tr '[:upper:]' '[:lower:]' | tr ' ' '_')

BRANCH_NAME="${BRANCH_TYPE}(${SCOPE}):_${SUBJECT}"

git checkout -b "$BRANCH_NAME"

