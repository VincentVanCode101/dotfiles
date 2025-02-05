#!/bin/bash
#
# Script to add specified attributes to every object in a JSON array.
#
# Usage: add_json_attributes.sh <filepath> <attribute1=value1> [<attribute2=value2> ...]
#
# The script modifies the JSON file in place, adding the specified attributes
# with their values to every object in the array.
#
# Globals:
#   None
# Arguments:
#   filepath - Path to the JSON file to process.
#   attribute1=value1 ... attributeN=valueN - Attributes and their values to add.
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
    err "Usage: $0 <filepath> <attribute1=value1> [<attribute2=value2> ...]"
  fi

  local filepath="$1"
  shift
  local attributes=("$@")

  if [[ ! -f "${filepath}" || ! -w "${filepath}" ]]; then
    err "File '${filepath}' does not exist or is not writable."
  fi

  # Build the jq argument string for adding attributes
  local jq_args
  for attr in "${attributes[@]}"; do
    if [[ "${attr}" != *=* ]]; then
      err "Invalid attribute format: '${attr}'. Expected format is attribute=value."
    fi

    local key value
    key="${attr%%=*}"       # Extract the key (attribute name)
    value="${attr#*=}"      # Extract the value
    jq_args+=" .${key}=\"${value}\" |"
  done
  jq_args=${jq_args%|} # Remove trailing pipe

  # Process the JSON file in place
  local tmp_file
  tmp_file=$(mktemp) || err "Failed to create a temporary file."
  jq "map(${jq_args})" "${filepath}" > "${tmp_file}" || err "Failed to process the JSON file."
  mv "${tmp_file}" "${filepath}" || err "Failed to overwrite the original file."

  echo "Successfully added attributes: ${attributes[*]} to ${filepath}"
}

main "$@"
