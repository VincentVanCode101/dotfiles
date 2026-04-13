#!/bin/bash

# Check if input file is given
if [[ $# -ne 1 ]]; then
  echo "Usage: $0 <input_file>"
  exit 1
fi

INPUT_FILE="$1"

# Check if input file exists
if [[ ! -f "$INPUT_FILE" ]]; then
  echo "Error: File '$INPUT_FILE' not found."
  exit 1
fi

# Split file by section headings
awk '
  /^## / {
    # Close previous file if open
    if (out) close(out)
    
    # Extract title (remove "## " prefix)
    title = substr($0, 4)
    
    # Sanitize filename (remove forbidden/special characters)
    gsub(/[^A-Za-z0-9._ -]/, "", title)
    
    # Append .txt extension
    out = title ".txt"
    
    next
  }
  out { print > out }
' "$INPUT_FILE"
