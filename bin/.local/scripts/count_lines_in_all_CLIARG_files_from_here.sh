#!/usr/bin/env bash

if [ -z "$1" ]; then
  echo "Usage: $0 <file_extension>"
  exit 1
fi

FILE_EXT="$1"

find . -name "*.${FILE_EXT}" -type f -exec wc -l {} + | awk '{total += $1} END {print total}'
