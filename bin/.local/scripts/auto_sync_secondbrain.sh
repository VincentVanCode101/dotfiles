#!/bin/bash
set -euo pipefail

REPO="/home/christoph/personal/notes/second-brain"

cd "$REPO" || {
    echo "Error: Could not change directory to $REPO" >&2
    exit 1
}

BRANCH=$(git symbolic-ref --short HEAD 2>/dev/null || echo "main")

log_push() {
    echo "$(date +'%Y-%m-%d %H:%M:%S') - Pushed local changes"
}

log_pull() {
    echo "$(date +'%Y-%m-%d %H:%M:%S') - Pulled remote changes"
}

commit_and_push() {

    if [ -n "$(git status --porcelain)" ]; then

        git add -A

        if git commit -m "Auto commit on $(date)" >/dev/null 2>&1 &&
            git push origin "$BRANCH" >/dev/null 2>&1; then
            log_push
        fi

    fi
}

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

# Main loop: wait for local changes, or after a timeout check for remote updates.
while true; do
    # Wait for local file events with a 60‑second timeout.
    if inotifywait -r -e modify,create,delete,move -t 60 . >/dev/null 2>&1; then
        sleep 20
        commit_and_push
    else
        pull_remote_if_needed
    fi
done
