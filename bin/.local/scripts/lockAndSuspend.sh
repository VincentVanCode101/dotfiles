#!/bin/bash

# Lock the screen
i3lock -i ~/Pictures/lock.jpg

# Wait for a moment to give i3lock time to engage
sleep 3

# Put the system into standby/suspend
systemctl suspend

