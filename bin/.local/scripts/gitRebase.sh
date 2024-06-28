#!/bin/bash

# Get the current branch name
CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)

# Get the number of commits the local branch is ahead of the remote branch
COMMITS_AHEAD=$(git rev-list --count origin/"$CURRENT_BRANCH"..HEAD)

git rebase -i HEAD~"$COMMITS_AHEAD"

