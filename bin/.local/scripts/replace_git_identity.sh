#!/bin/bash
# replace_git_identity.sh
#
# Usage:
#   ./replace_git_identity.sh <new_git_name> <new_git_email> [<branch>]
#
# This script rewrites the commit history on the specified branch (or the current branch if none is provided)
# by replacing the author and committer information with the new git name and email.
#
# WARNING: This rewrites history. If the branch is shared, you must force-push after running this script.

# Ensure we're inside a git repository.
if ! git rev-parse --git-dir >/dev/null 2>&1; then
    echo "Error: This script must be run inside a git repository."
    exit 1
fi

# Check that at least 2 arguments (name and email) are provided.
if [ "$#" -lt 2 ]; then
    echo "Usage: $0 <new_git_name> <new_git_email> [<branch>]"
    exit 1
fi

NEW_NAME="$1"
NEW_EMAIL="$2"
# Use the provided branch or default to the current branch.
BRANCH="${3:-$(git symbolic-ref --short HEAD)}"

echo "Replacing git identity on branch: $BRANCH"
echo "New Name:  $NEW_NAME"
echo "New Email: $NEW_EMAIL"
echo ""
echo "WARNING: This will rewrite commit history on branch '$BRANCH'."
read -p "Are you sure you want to proceed? (y/n): " CONFIRM
if [[ "$CONFIRM" != "y" && "$CONFIRM" != "Y" ]]; then
    echo "Aborting."
    exit 0
fi

# Rewrite every commit on the specified branch.
git filter-branch -f --env-filter '
export GIT_AUTHOR_NAME="'"$NEW_NAME"'"
export GIT_AUTHOR_EMAIL="'"$NEW_EMAIL"'"
export GIT_COMMITTER_NAME="'"$NEW_NAME"'"
export GIT_COMMITTER_EMAIL="'"$NEW_EMAIL"'"
' "$BRANCH"

echo ""
echo "Git identity replaced on branch '$BRANCH'."
echo "If you have already pushed this branch, you will need to force-push:"
echo "  git push --force origin $BRANCH"
