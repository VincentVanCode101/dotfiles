#!/bin/bash

i3-msg "workspace 1; append_layout /home/christoph/.config/i3/workspace-1.json"

exec --no-startup-id "i3-msg 'workspace 1; append_layout /home/christoph/.config/i3/workspace-1.json'"

i3-msg "workspace 1; exec obsidian"
i3-msg "workspace 1; exec /usr/bin/nautilus"
i3-msg "workspace 1; exec /usr/bin/gnome-terminal --working-directory='/home/christoph/privat/notes' "
