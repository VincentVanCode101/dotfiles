#!/bin/bash

# append_layout is i3-specific and not supported in sway — layout restore omitted
# swaymsg "workspace 1; append_layout /home/christoph/.config/i3/workspace-1.json"

swaymsg "workspace 1; exec obsidian"
swaymsg "workspace 1; exec /usr/bin/nautilus"
swaymsg "workspace 1; exec /usr/bin/gnome-terminal --working-directory='/home/christoph/privat/notes'"
