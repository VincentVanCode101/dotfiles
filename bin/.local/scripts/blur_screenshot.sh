#!/bin/bash

SCREENSHOT_DIR="$HOME/Pictures/Screenshots"
mkdir -p "$SCREENSHOT_DIR"

PRIMARY_MONITOR=$(xrandr --query | grep ' connected primary' | cut -d" " -f1)

if [ "$PRIMARY_MONITOR" = "eDP-1" ]; then
    FILE_NAME="Screenshot_${PRIMARY_MONITOR}_$(date +'%Y-%m-%d_%H-%M-%S').jpg"
    FULL_PATH="$SCREENSHOT_DIR/$FILE_NAME"

    maim -g "$(xrandr --query | grep "$PRIMARY_MONITOR" | grep -oP '\d+x\d+\+\d+\+\d+')" > "$FULL_PATH"

    if [ -f "$FULL_PATH" ]; then
        convert "$FULL_PATH" -blur 0x12 "$FULL_PATH"
        echo "Screenshot saved and blurred: $FULL_PATH"
    else
        echo "Failed to take screenshot of $PRIMARY_MONITOR."
    fi
else
    echo "eDP-1 is not connected or not the primary monitor."
fi

