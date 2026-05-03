#!/bin/bash

## 1. Get all output names (both connected and disconnected)
## 2. Filter out eDP-1
## 3. Turn each one off
outputs=$(xrandr | grep "connected" | awk '{ print $1 }' | grep -v "eDP-1")

for display in $outputs; do
    echo "Disabling $display..."
        xrandr --output "$display" --off
        done

        # Optional: Reset the desktop size to fit eDP-1 exactly
        xrandr --output eDP-1 --auto
