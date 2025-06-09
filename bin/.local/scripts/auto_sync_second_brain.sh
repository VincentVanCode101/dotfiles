#!/usr/bin/env bash

export HOME="${HOME:-/Users/christoph}"
export PATH="/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"

set -euo pipefail

OS_TYPE=$(uname -s)
GTIMEOUT=$(command -v gtimeout || echo "/opt/homebrew/bin/gtimeout")

WATCH_DIR="$HOME/personal/notes/second-brain"
LOG_OUT="/tmp/auto-sync-second-brain.out"
LOG_ERR="/tmp/auto-sync-second-brain.err"

cd "$WATCH_DIR" || {
    echo "$(date) - [ERROR] Could not cd to $WATCH_DIR" >> "$LOG_ERR"
    exit 1
}

echo "$(date) - [START] Auto sync watcher started" >> "$LOG_OUT"

commit_and_push() {
    if [ -n "$(git status --porcelain)" ]; then
        git add -A
        if git commit -m "Auto commit $(date)"; then
            if git push origin "$(git rev-parse --abbrev-ref HEAD)"; then
                echo "$(date) - [PUSHED] Changes pushed" >> "$LOG_OUT"
            else
                echo "$(date) - [ERROR] Git push failed" >> "$LOG_ERR"
            fi
        else
            echo "$(date) - [ERROR] Git commit failed" >> "$LOG_ERR"
        fi
    fi
}

pull_remote_if_needed() {
    if git fetch origin; then
        local_head=$(git rev-parse HEAD)
        remote_head=$(git rev-parse "origin/$(git rev-parse --abbrev-ref HEAD)")
        if [ "$local_head" != "$remote_head" ]; then
            if git pull --rebase origin "$(git rev-parse --abbrev-ref HEAD)"; then
                echo "$(date) - [PULLED] Remote changes pulled" >> "$LOG_OUT"
            else
                echo "$(date) - [ERROR] Git pull failed" >> "$LOG_ERR"
            fi
        fi
    else
        echo "$(date) - [ERROR] Git fetch failed" >> "$LOG_ERR"
    fi
}

while true; do
    if [[ "$OS_TYPE" == "Linux" ]]; then
        if inotifywait -r -e modify,create,delete,move -t 60 .; then
            echo "$(date) - [INFO] Filesystem change detected (Linux)" >> "$LOG_OUT"
            sleep 10
            commit_and_push
        else
            echo "$(date) - [INFO] No changes, checking remote (Linux)" >> "$LOG_OUT"
            pull_remote_if_needed
        fi
    elif [[ "$OS_TYPE" == "Darwin" ]]; then
        if "$GTIMEOUT" 60 fswatch -r -1 .; then
            echo "$(date) - [INFO] Filesystem change detected (macOS)" >> "$LOG_OUT"
            sleep 10
            commit_and_push
        else
            echo "$(date) - [INFO] No changes, checking remote (macOS)" >> "$LOG_OUT"
            pull_remote_if_needed
        fi
    else
        echo "$(date) - [ERROR] Unsupported OS: $OS_TYPE" >> "$LOG_ERR"
        exit 1
    fi
done
