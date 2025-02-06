#!/bin/bash
# bisync.sh
#
# This script performs a three-phase rclone bisync:
#   1. Dry-run with --resync to verify the union of files.
#   2. Actual sync with --resync to force a full union.
#   3. Final sync without --resync for regular updates.
#
# Adjust variables below as needed.
# Docs: https://rclone.org/bisync/#resync

set -e

# Define your local and remote paths.
LOCAL="$HOME/personal/notes/secondBrain"
REMOTE="google:secondBrain"

# Define common options:
# - Excludes the .git directory.
# - Uses check-access for safety.
# - Other flags per your requirements.
# Added: --resync-mode newer to choose the newer file as the winner.
EXTRA_OPTS="--create-empty-src-dirs \
  --compare size,modtime,checksum \
  --slow-hash-sync-only \
  --resilient \
  -MvP \
  --drive-skip-gdocs \
  --fix-case \
  --exclude '.git/**' \
  --check-access \
  --check-filename RCLONE_TEST \
  --resync-mode newer"

# rclone bisync command base.
RCLONE_CMD="rclone bisync"

# Log file path (adjust as needed).
LOGFILE="$HOME/bisync.log"

# Function to log messages with a timestamp.
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >>"$LOGFILE"
}

# ---------------------------
# Step 1: Dry-run with --resync
# ---------------------------
log "Starting bisync dry-run with --resync."
$RCLONE_CMD $LOCAL $REMOTE $EXTRA_OPTS --resync --dry-run >>"$LOGFILE" 2>&1
if [ $? -ne 0 ]; then
    log "Dry-run failed. Aborting bisync."
    exit 1
fi
log "Dry-run successful."

# ---------------------------
# Step 2: Actual sync with --resync
# ---------------------------
log "Running actual bisync with --resync."
$RCLONE_CMD $LOCAL $REMOTE $EXTRA_OPTS --resync >>"$LOGFILE" 2>&1
if [ $? -ne 0 ]; then
    log "Actual sync with --resync failed. Aborting bisync."
    exit 1
fi
log "Actual sync with --resync completed successfully."

# ---------------------------
# Step 3: Final sync without --resync
# ---------------------------
log "Running final bisync sync without --resync."
$RCLONE_CMD $LOCAL $REMOTE $EXTRA_OPTS >>"$LOGFILE" 2>&1
if [ $? -ne 0 ]; then
    log "Final sync without --resync failed."
    exit 1
fi
log "Final sync without --resync completed successfully."
log "Bisync process completed successfully."
