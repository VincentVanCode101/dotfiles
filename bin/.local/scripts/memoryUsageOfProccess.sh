#!/usr/bin/env bash

if [ -z "$1" ]; then
  echo "Usage: $0 <partial_process_name>"
  exit 1
fi

PROCESS_NAME=$1

echo "Fetching memory usage for processes containing '$PROCESS_NAME' (case-insensitive)..."

results=$(ps aux | grep -i "$PROCESS_NAME" | grep -v grep | awk '{printf "%-10s %-15.2f %-10s\n", $2, $6/1024, $11}')

if [ -z "$results" ]; then
  echo "No running processes found containing '$PROCESS_NAME'."
  exit 1
fi

echo "PID        MEMORY(MB)      COMMAND"
echo "----------------------------------------"
echo "$results"

total_mem=$(ps aux | grep -i "$PROCESS_NAME" | grep -v grep | awk '{sum+=$6} END {print sum/1024 " MB"}')

echo "----------------------------------------"
echo "Total Memory: $total_mem"

