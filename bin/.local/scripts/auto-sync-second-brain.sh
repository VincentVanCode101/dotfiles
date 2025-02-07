#!/bin/bash
set -euo pipefail

# Change to the directory where this script is located.
cd "$(dirname "$0")" || {
    echo "ERROR: Could not change directory to script location."
    exit 1
}

# Determine the current branch; default to "main" if not found.
BRANCH=$(git symbolic-ref --short HEAD 2>/dev/null || echo "main")

# Logging functions: these output messages only on push or pull events.
log_push() {
    echo "$(date +'%Y-%m-%d %H:%M:%S') - Pushed local changes"
}

log_pull() {
    echo "$(date +'%Y-%m-%d %H:%M:%S') - Pulled remote changes"
}

# Commit and push local changes if any modifications exist.
commit_and_push() {
    if [ -n "$(git status --porcelain)" ]; then
        git add -A
        if git commit -m "Auto commit on $(date)" >/dev/null 2>&1 &&
            git push origin "$BRANCH" >/dev/null 2>&1; then
            log_push
        fi
    fi
}

# Fetch remote changes and pull them if the local HEAD differs from remote.
pull_remote_if_needed() {
    git fetch origin >/dev/null 2>&1
    local local_head remote_head
    local_head=$(git rev-parse HEAD)
    remote_head=$(git rev-parse "origin/$BRANCH")
    if [ "$local_head" != "$remote_head" ]; then
        if git pull --rebase origin "$BRANCH" >/dev/null 2>&1; then
            log_pull
        fi
    fi
}

# Main loop:
# - Waits for local filesystem changes with a 60-second timeout.
# - If an event is detected, waits briefly (debounce), then commits & pushes local changes.
# - If the timeout expires (no local changes), it checks for remote updates.
while true; do
    if inotifywait -r -e modify,create,delete,move -t 60 . >/dev/null 2>&1; then
        sleep 10 # Debounce: wait for rapid changes to settle.
        commit_and_push
    else
        pull_remote_if_needed
    fi
done
