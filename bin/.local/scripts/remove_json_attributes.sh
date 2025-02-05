#!/bin/bash
#
# Script to remove specified attributes from a JSON file.
#
# Usage: remove_json_attributes.sh <filepath> <attribute1> [<attribute2> ...]
#
# The script modifies the JSON file in place, removing the specified attributes
# from every object in the JSON array.
#
# Globals:
#   None
# Arguments:
#   filepath - Path to the JSON file to process.
#   attribute1 ... attributeN - Attributes to remove from the JSON objects.
# Outputs:
#   Modifies the JSON file in place.
# Returns:
#   0 on success, non-zero on error.

set -euo pipefail

# Load utility functions
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/utils.sh"

#######################################
# Main function of the script.
# Globals:
#   None
# Arguments:
#   $@ - All arguments passed to the script.
#######################################
main() {
  need_cmd jq

  if [[ "$#" -lt 2 ]]; then
    err "Usage: $0 <filepath> <attribute1> [<attribute2> ...]"
  fi

  local filepath="$1"
  shift
  local attributes=("$@")

  if [[ ! -f "${filepath}" || ! -w "${filepath}" ]]; then
    err "File '${filepath}' does not exist or is not writable."
  fi

  # Build the jq 'del' argument string
  local del_args
  del_args=$(printf ".%s, " "${attributes[@]}")
  del_args=${del_args%, } # Remove trailing comma

  # Process the JSON file in place
  local tmp_file
  tmp_file=$(mktemp) || err "Failed to create a temporary file."
  jq "map(del(${del_args}))" "${filepath}" > "${tmp_file}" || err "Failed to process the JSON file."
  mv "${tmp_file}" "${filepath}" || err "Failed to overwrite the original file."

  echo "Successfully removed attributes: ${attributes[*]} from ${filepath}"
}

main "$@"
