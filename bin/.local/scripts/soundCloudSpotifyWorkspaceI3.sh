#!/usr/bin/env bash

swaymsg workspace "Sountify"

soundcloud_url="https://soundcloud.com/discover"

open_soundcloud() {
    google-chrome --profile-directory="Profile 2" --app="$soundcloud_url" --class="Soundcloud" &
}

# Check sway tree for any window whose name contains "soundcloud"
soundcloud_open() {
    swaymsg -t get_tree \
        | jq -r '[.. | objects | select(.name?) | .name] | .[]' \
        | grep -qi soundcloud
}

if ! soundcloud_open; then
    open_soundcloud
fi

# Spotify: check by app_id or window name
spotify_open() {
    swaymsg -t get_tree \
        | jq -r '[.. | objects | select(.app_id? or .name?) | (.app_id // ""), (.name // "")] | .[]' \
        | grep -qi spotify
}

if ! spotify_open; then
    spotify &
fi
