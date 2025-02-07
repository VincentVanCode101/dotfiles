#!/usr/bin/env bash
set -euo pipefail

# Function to display usage information.
usage() {
    echo "Usage: $(basename "$0") <search_pattern> <replace_pattern>" >&2
    exit 1
}

# Ensure exactly two arguments are provided.
if [[ $# -ne 2 ]]; then
    usage
fi

readonly search_pattern="$1"
readonly replace_pattern="$2"

echo "Searching for files containing '${search_pattern}'..."

# Use grep with:
#   -r: recursive search,
#   -l: list only matching filenames,
#   -F: fixed string (not a regex),
#   -Z: output null-separated filenames (for safety with unusual filenames).
# The '|| true' prevents grep's non-zero exit status (when no match is found) from breaking the script.
mapfile -d '' -t files < <(grep -rlFZ "$search_pattern" . || true)

# Check if any files were found.
if [[ ${#files[@]} -eq 0 ]]; then
    echo "No files found containing '${search_pattern}'."
    exit 0
fi

echo "Found ${#files[@]} file(s):"
for file in "${files[@]}"; do
    echo "  $file"
done
echo

echo "Performing replacements..."
# Use xargs with:
#   -0: expect null-delimited input,
#   -t: print the command before executing it.
# The sed command performs an in-place replacement (with the -i flag) on all occurrences.
printf '%s\0' "${files[@]}" | xargs -0 -t sed -i "s/${search_pattern}/${replace_pattern}/g"

echo "Replacement complete."
