#!/usr/bin/env bash

i3-msg workspace "Sountify"

soundcloud_regex="soundcloud.com__discover"
soundcloud_url="https://soundcloud.com/discover"


open_soundcloud() {
    google-chrome --profile-directory="Profile 2" --app="$soundcloud_url" --class="Soundcloud" &
}


chrome_windows=$(xdotool search --onlyvisible --class "Google-chrome")
if [ -z "$chrome_windows" ]; then
    open_soundcloud
else
    soundcloud_found=false
    for win_id in $chrome_windows; do
        wm_class=$(xprop -id "$win_id" WM_CLASS)
        if [[ $wm_class =~ $soundcloud_regex ]]; then
            soundcloud_found=true
            break
        fi
    done
    
    if [ "$soundcloud_found" = false ]; then
        open_soundcloud
    fi
fi

spotify_regex="spotify"

spotify_windows=$(xdotool search --class "Spotify")

if [ -z "$spotify_windows" ]; then
    spotify &
else
    for win_id in $spotify_windows; do
        wm_class=$(xprop -id "$win_id" WM_CLASS)
        if [[ ! $wm_class =~ $spotify_regex ]]; then
            spotify &
            break
        fi
    done
fi
