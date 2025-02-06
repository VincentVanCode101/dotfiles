#!/bin/bash
# onedrive-restart.sh
#
# This script reloads the systemd user daemon and restarts the OneDrive service.
#
# Usage: ./onedrive-restart.sh

set -e

echo "Reloading systemd user daemon..."
systemctl --user daemon-reload

echo "Restarting OneDrive service..."
systemctl --user restart onedrive.service

echo "OneDrive service restarted. Check status with:"
echo "  systemctl --user status onedrive.service"

# Check for "Active: failed" in systemctl --user status onedrive.service
# When failed, run this manually
# systemctl --user daemon-reload                                                                                                                                                    3 ✘  05:31:59
# systemctl --user restart onedrive.service

# Trouble-shooting may look like this:
# onedrive --sync --verbose                                                                                                                                               ✔  05:35:03
# Reading configuration file: /home/christoph/.config/onedrive/config
# Configuration file successfully loaded
# Using 'user' configuration path for application config and state data: /home/christoph/.config/onedrive
# D-Bus message bus daemon is available; GUI notifications are now enabled

# WARNING: Your cURL/libcurl version (7.81.0) has known HTTP/2 bugs that impact the use of this client.
#          Please report this to your distribution, requesting an update to a newer cURL version, or consider upgrading it yourself for optimal stability.
#          Downgrading all client operations to use HTTP/1.1 to ensure maximum operational stability.
#          Please read https://github.com/abraunegg/onedrive/blob/master/docs/usage.md#compatibility-with-curl for more information.

# Application configuration file has been updated, checking if --resync needed

# An application configuration change has been detected where a --resync is required

# Then:
# onedrive --sync --resync --resync-auth --verbose
