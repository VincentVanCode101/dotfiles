#!/bin/bash
set -euo pipefail

# Logging functions
log_info() {
    echo "$(date +'%Y-%m-%d %H:%M:%S') - INFO: $1"
}

log_error() {
    # Log errors to stderr
    echo "$(date +'%Y-%m-%d %H:%M:%S') - ERROR: $1" >&2
}

log_push() {
    log_info "Pushed local changes"
}

log_pull() {
    log_info "Pulled remote changes"
}

trap 'log_error "Error on line ${LINENO}: Command '\''$BASH_COMMAND'\'' exited with status $?"' ERR

# Define the target directory where git operations should occur.
TARGET_DIR="/home/christoph/personal/notes/second-brain"

# Change to the target directory.
cd "$TARGET_DIR" || {
    log_error "Could not change directory to $TARGET_DIR."
    exit 1
}

# Determine the current branch; default to "main" if not found.
BRANCH=$(git symbolic-ref --short HEAD 2>/dev/null || echo "main")

# Commit and push local changes if any modifications exist.
commit_and_push() {
    if [ -n "$(git status --porcelain)" ]; then
        git add -A
        if git commit -m "Auto commit on $(date)"; then
            if git push origin "$BRANCH"; then
                log_push
            else
                log_error "Git push failed."
            fi
        else
            log_error "Git commit failed."
        fi
    fi
}

# Fetch remote changes and pull them if the local HEAD differs from remote.
pull_remote_if_needed() {
    if git fetch origin; then
        local local_head remote_head
        local_head=$(git rev-parse HEAD)
        remote_head=$(git rev-parse "origin/$BRANCH")
        if [ "$local_head" != "$remote_head" ]; then
            if git pull --rebase origin "$BRANCH"; then
                log_pull
            else
                log_error "Git pull failed."
            fi
        fi
    else
        log_error "Git fetch failed."
    fi
}

# Main loop:
# - Waits for local filesystem changes with a 60-second timeout.
# - If an event is detected, waits briefly (debounce) then commits & pushes local changes.
# - If the timeout expires (no local changes), it checks for remote updates.
while true; do
    log_info $(pwd)
    if inotifywait -r -e modify,create,delete,move -t 60 .; then
        sleep 10 # Debounce: wait for rapid changes to settle.
        commit_and_push
    else
        pull_remote_if_needed
    fi
done
