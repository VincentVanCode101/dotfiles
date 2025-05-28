#!/usr/bin/env bash

# Kill any running polybar instances (via IPC or fallback)
polybar-msg cmd quit 2>/dev/null || killall -q polybar

for m in $(polybar --list-monitors | cut -d: -f1); do
    MONITOR=$m polybar --reload chris 2>&1 | tee -a "/tmp/polybar-$m.log" &
    disown
done

echo "Polybar launched on: $(polybar --list-monitors | cut -d: -f1 | tr '\n' ' ')"
