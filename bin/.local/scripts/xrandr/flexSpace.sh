#!/bin/bash
# This script arranges the displays as follows:
#   - eDP-1: primary display at 1920x1080
#   - DP-3-1: 2560x1440 placed above eDP-1
#   - DP-3-3: 2560x1440 placed to the right of DP-3-1

# Set the primary internal display (laptop screen)

xrandr --output eDP-1 --auto --output DP-3-1 --auto --above eDP-1 --output DP-3-3 --auto --right-of DP-3-1
