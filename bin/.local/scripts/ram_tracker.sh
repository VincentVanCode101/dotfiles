#!/bin/bash
# File: ram_tracker.sh

# Define the log file location. Change this path if needed.
LOGFILE="$HOME/ram_usage.log"

# Inform the user that logging has started.
echo "Starting RAM usage logging. Logging every 5 seconds to: $LOGFILE"

# Run an infinite loop that logs the RAM usage every 5 seconds.
while true; do
    # Get the current timestamp.
    timestamp=$(date '+%Y-%m-%d %H:%M:%S')

    # Get RAM usage details using the 'free' command.
    # This example calculates the used memory as a percentage.
    # The 'free' command output is assumed to be in the format where the second line contains memory info.
    read total used free shared buff_cache available < <(free -m | awk 'NR==2{print $2, $3, $4, $5, $6, $7}')

    # Calculate usage percentage (if total is not zero).
    if [ "$total" -ne 0 ]; then
        usage_percent=$(awk -v used="$used" -v total="$total" 'BEGIN {printf "%.2f", used*100/total}')
    else
        usage_percent="N/A"
    fi

    # Write the timestamp and RAM usage to the log file.
    echo "$timestamp - Total: ${total}MB, Used: ${used}MB (${usage_percent}%), Free: ${free}MB" >>"$LOGFILE"

    # Sleep for 5 seconds before logging the next entry.
    sleep 5
done
