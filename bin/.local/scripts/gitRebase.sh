#!/usr/bin/env bash

# Count the number of unpushed commits since origin/HEAD
commit_count=$(git rev-list --count HEAD ^origin/HEAD)

# Check if there are any commits to rebase
if [ "$commit_count" -gt 0 ]; then
  echo "Found $commit_count unpushed commits. Starting interactive rebase..."
  git rebase -i HEAD~$commit_count
else
  echo "No unpushed commits found. Nothing to rebase."
fi

