#!/usr/bin/env bash

# uppercase_headings.sh
# Usage: ./uppercase_headings.sh input.md [output.md]

set -e

if [[ $# -lt 1 ]]; then
  echo "Usage: $0 input.md [output.md]"
  exit 1
fi

infile="$1"
outfile="${2:-}"

# If no output file specified, do an in-place edit (with backup)
if [[ -z "$outfile" ]]; then
  # create a backup
  backup="${infile}.bak"
  mv "$infile" "$backup"
  awk '
    # If line starts with one or more #, toupper the whole line
    /^#{1,}/ { print toupper($0); next }
    { print }
  ' "$backup" >"$infile"
  echo "Headings in '$infile' uppercased (backup at '$backup')."
else
  # write to a separate output file
  awk '
    /^#{1,}/ { print toupper($0); next }
    { print }
  ' "$infile" >"$outfile"
  echo "Headings in '$infile' uppercased into '$outfile'."
fi
