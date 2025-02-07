#!/bin/bash
# onedrive-setup.sh
#
# This script sets up the OneDrive client for continuous, bidirectional synchronization
# of a single folder:
#
#   Local folder: $HOME/personal/notes/secondBrain
#   Remote OneDrive folder: secondBrain
#
# It performs the following actions:
#   1. Creates the OneDrive configuration directory and downloads the default config.
#   2. Updates the config to:
#         - Use the desired local sync directory.
#         - Exclude directories named ".git" or "temp".
#   3. Creates a user-level systemd service to run OneDrive in monitor mode with --resync-auth.
#   4. Reloads systemd and enables/starts the OneDrive service.
#
# Usage: ./onedrive-setup.sh

set -e

# Variables
CONFIG_DIR="$HOME/.config/onedrive"
CONFIG_FILE="$CONFIG_DIR/config"
LOCAL_SYNC_DIR="$HOME/personal/notes/secondBrain"
SYSTEMD_USER_DIR="$HOME/.config/systemd/user"
UNIT_FILE="$SYSTEMD_USER_DIR/onedrive.service"

echo "==> Setting up OneDrive configuration..."

# Create the OneDrive config directory if it doesn't exist
mkdir -p "$CONFIG_DIR"

# Download the default configuration file
echo "Downloading default config to $CONFIG_FILE..."
wget -q https://raw.githubusercontent.com/abraunegg/onedrive/master/config -O "$CONFIG_FILE"

# Update the config file to set the sync_dir to the desired folder.
# Remove any existing sync_dir settings (commented or active), then append our setting.
echo "Configuring sync_dir to \"$LOCAL_SYNC_DIR\"..."
sed -i '/^[# ]*sync_dir[ ]*=.*/d' "$CONFIG_FILE"
echo "sync_dir = \"$LOCAL_SYNC_DIR\"" >>"$CONFIG_FILE"

# Add the skip_dir option to exclude ".git" and "temp" directories.
echo "Configuring skip_dir to \".git|temp\"..."
sed -i '/^[# ]*skip_dir[ ]*=.*/d' "$CONFIG_FILE"
echo "skip_dir = \".git|temp\"" >>"$CONFIG_FILE"

echo "Configuration updated:"
grep '^sync_dir' "$CONFIG_FILE"
grep '^skip_dir' "$CONFIG_FILE"

# Ensure the local sync directory exists
mkdir -p "$LOCAL_SYNC_DIR"

echo "==> Setting up systemd user service for OneDrive..."

# Create the user-level systemd directory if it doesn't exist
mkdir -p "$SYSTEMD_USER_DIR"

# Create the systemd unit file for OneDrive in monitor mode if it doesn't already exist
if [ ! -f "$UNIT_FILE" ]; then
    cat <<EOF >"$UNIT_FILE"
[Unit]
Description=OneDrive Client for Linux (Monitor Mode)
After=network-online.target

[Service]
ExecStart=/usr/bin/onedrive --monitor --resync-auth
Restart=on-failure

[Install]
WantedBy=default.target
EOF
    echo "Systemd unit file created at $UNIT_FILE."
else
    echo "Systemd unit file already exists at $UNIT_FILE."
fi

# Reload the systemd user configuration
echo "Reloading systemd user configuration..."
systemctl --user daemon-reload

# Enable and start the OneDrive service
echo "Enabling and starting OneDrive service..."
systemctl --user enable onedrive
systemctl --user start onedrive

echo "==> OneDrive setup complete!"
echo "Local sync directory is set to: $LOCAL_SYNC_DIR"
echo "The OneDrive client is now running in monitor mode (with --resync-auth) and will continuously sync changes bidirectionally."
echo "To check the status at any time, run:"
echo "  systemctl --user status onedrive.service"
