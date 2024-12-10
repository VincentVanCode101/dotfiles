#!/usr/bin/env bash

#-------------------------------------------------------------
# Title: template.sh
# Description: This is a script template that follows some
# best practices for shell scripting. It includes features 
# such as named parameters (required or optional), date and
# time handling, logging, colored output, and error handling.
# Author: Eduardo Silva
#
# RECOMMENDATIONS:
# NOT use command arguments abbreviations (Ex.: sed -e / sed -expression)
# OPTIONAL send useless output to (Ex.: command > /dev/null 2>&1)
#-------------------------------------------------------------

# FAULT CONFIGURATION
set -Eeuo pipefail
trap cleanup SIGINT SIGTERM ERR EXIT

# CONSTANTS
readonly __dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly __file="${__dir}/$(basename "${BASH_SOURCE[0]}")"
readonly __file_name="$(basename "$__file")"
readonly __base="$(basename "${__file}" .sh)"

readonly _MSG_PARAMETER_REQUIRED="Missing required parameter: parameter (-p or --parameter) arg"

#-------------------------------------------------------------
# MAIN FUNCTION
# This function is the main entry point of the script. It 
# executes the core functionality of the script.
# 
# Usage:
#   This function should be called to initiate the main 
#   functionality of the script.
# 
# Example usage:
#   main
#-------------------------------------------------------------
main() {
    ensure_not_empty "$_parameter" "$_MSG_PARAMETER_REQUIRED"
    echo "hello world: ${_parameter}"
}

#-------------------------------------------------------------
# DISPLAY HOW TO USE THE SCRIPT
# This function displays usage information for the script,
# including a summary of available options and their descriptions.
# 
# Usage:
#   This function should be called to display usage 
#   information for the script.
# 
# Example usage:
#   usage
#-------------------------------------------------------------
usage() {
  cat <<EOF
Usage: $(basename "$__file_name") [-h] [-v] [-f] -p param_value arg1 [arg2...]
Script description here.
Available options:
-h, --help              Print this help and exit
-v, --verbose           Print script debug info
-f, --flag              Some flag description
-p, --parameter         Some param description
-t, --tag               Some tag description
EOF
  exit
}

#-------------------------------------------------------------
# PARSE SCRIPT PARAMETERS
# This function parses the parameters passed to the script
# and initializes corresponding variables with default values.
# It also handles options and flags specified by the user.
# 
# Usage:
#   parse_params "$@"
# 
# Arguments:
#   $@: The parameters passed to the script.
# 
# Options:
#   -h, --help              : Display usage information and exit.
#   -v, --verbose           : Enable verbose mode.
#   --no-color              : Disable color output.
#   -f, --flag              : Example flag.
#   -p, --parameter <value> : Example named parameter with a value.
#-------------------------------------------------------------
parse_params() {
  # default values of variables set from params
  _flag=0
  _parameter=

  while :; do
    case "${1-}" in
    -h | --help) usage ;;
    -v | --verbose) set -x ;;
    --no-color) NO_COLOR=1 ;;
    -f | --flag) _flag=1 ;;      # example flag
    -p | --parameter)           # example named parameter
        ensure_not_empty "${2-}" "$_MSG_PARAMETER_REQUIRED"
        _parameter="${2-}"
      shift
      ;;
    -?*) die "Unknown option: $1" ;;
    *) break ;;
    esac
    shift
  done

  args=("$@")

  return 0
}

#-------------------------------------------------------------
# SCRIPT CLEANUP
# This function is executed when the script finishes, whether
# it completes successfully, is terminated by a signal, or 
# encounters an error. It is used to perform cleanup tasks
# such as releasing resources or deleting temporary files.
# 
# Usage:
#   This function should be called at the end of the script
#   to ensure cleanup actions are performed.
# 
# Example usage:
#   cleanup
#-------------------------------------------------------------
cleanup() {
  trap - SIGINT SIGTERM ERR EXIT
  # script cleanup here
}

#-------------------------------------------------------------
# SETUP COLORS CONFIGURATION
# This function configures color output for the script if the
# terminal supports it and colorization is enabled. It assigns
# ANSI color codes to variables for use in printing colored
# output messages.
# 
# Usage:
#   This function should be called at the beginning of the
#   script to set up color configurations.
#-------------------------------------------------------------
setup_colors() {
  if [[ -t 2 ]] && [[ -z "${NO_COLOR-}" ]] && [[ "${TERM-}" != "dumb" ]]; then
    NOFORMAT='\033[0m'  # Reset text format
    RED='\033[0;31m'    # Red color
    GREEN='\033[0;32m'  # Green color
    ORANGE='\033[0;33m' # Orange color
    BLUE='\033[0;34m'   # Blue color
    PURPLE='\033[0;35m' # Purple color
    CYAN='\033[0;36m'   # Cyan color
    YELLOW='\033[1;33m' # Yellow color
  else
    # If colorization is disabled or unsupported, set variables to empty strings
    NOFORMAT=''
    RED=''
    GREEN=''
    ORANGE=''
    BLUE=''
    PURPLE=''
    CYAN=''
    YELLOW=''
  fi
}

#-------------------------------------------------------------
# PRINT MESSAGES
# This function prints messages to standard error with support
# for colorization if configured. It allows printing formatted
# messages with colors and variables.
# 
# Usage examples:
#   msg "${RED}Read parameters:${NOFORMAT}"
#   msg "- flag: ${flag}"
#   msg "- param: ${param}"
#   msg "- arguments: ${args[*]-}"
# 
# Arguments:
#   $1: The message to be printed. It can include color codes
#       or variables.
#-------------------------------------------------------------
msg() {
  echo >&2 -e "${1-}"
}

#-------------------------------------------------------------
# GET DATE AND TIME
# This function retrieves the current date and time in the
# format "YYYY-MM-DD-HH:MM:SS".
# 
# Usage:
#   now
# 
# Returns:
#   The current date and time.
#-------------------------------------------------------------
now(){
  date +%F-%T
}

#-------------------------------------------------------------
# GET DATE
# This function retrieves the current date in the ISO 8601
# format "YYYY-MM-DD".
# 
# Usage:
#   today
# 
# Returns:
#   The current date.
#-------------------------------------------------------------
today(){
  date -I
}

#-------------------------------------------------------------
# INFO MESSAGE
# This function prints an information message with timestamp
# and optional formatting.
# 
# Usage:
#   info "Message text"
# 
# Arguments:
#   $1: The message to be printed.
#-------------------------------------------------------------
info(){
  msg "${BLUE}${__file_name} | $(now) - INFO: ${1-} ${NOFORMAT}"
}

#-------------------------------------------------------------
# LOG MESSAGE
# This function prints a log message with timestamp and 
# optional formatting.
# 
# Usage:
#   log "Message text"
# 
# Arguments:
#   $1: The message to be printed.
#-------------------------------------------------------------
log(){
  msg "${YELLOW}${__file_name} | $(now) - LOG: ${1-} ${NOFORMAT}"
}

#-------------------------------------------------------------
# ERROR MESSAGE
# This function prints an error message with timestamp and 
# optional formatting, then exits the script.
# 
# Usage:
#   error "Error message"
# 
# Arguments:
#   $1: The error message to be printed.
#-------------------------------------------------------------
error(){
  msg "${RED}${__file_name} | $(now) - ERROR: ${1-} ${NOFORMAT}"
}

#-------------------------------------------------------------
# FINISH EXECUTION
# This function prints an error message and exits the script 
# with a specified exit status.
# 
# Usage:
#   die "Error message" [exit_status]
# 
# Arguments:
#   $1: The error message to be printed.
#   $2: (Optional) The exit status. Default is 1.
#-------------------------------------------------------------
die() {
  local msg=$1
  local code=${2-1} # default exit status 1
  error "$msg"
  exit "$code"
}

#-------------------------------------------------------------
# ENSURE EXECUTION
# This function is used to run a command that is expected to
# always succeed. If the command fails, the script will
# immediately terminate with an error message indicating the
# failing command.
# 
# Usage example:
#   ensure ls -l /some/nonexistent/directory
# 
# Arguments:
#   Any command and its arguments that are expected to succeed.
#-------------------------------------------------------------
ensure() {
    if ! "$@"; then die "command failed: $*"; fi
}


#-------------------------------------------------------------
# ENSURE NOT EMPTY
# This function checks whether a given value is not empty.
# If the value is empty, it terminates the script with an error
# message indicating the description provided.
# 
# Usage example:
#   local _arch="${RETVAL}"
#   ensure_not_empty "${_arch}" "architecture"
# 
# Arguments:
#   $1: The value to be validated.
#   $2: Description used in the error message.
#-------------------------------------------------------------
ensure_not_empty() {
    if [ -z "$1" ]; then die "found empty string: $2"; fi
}

#-------------------------------------------------------------
# NEED COMMAND
# This function checks if a specific command is available in
# the system. If the command is not found, it prints an error
# message and terminates the script.
#
# Usage example:
#   need_cmd "gcc"
#
# Arguments:
#   $1: The command to be checked for availability.
#-------------------------------------------------------------
need_cmd() {
    if ! check_cmd "$1"; then
        die "Error: '$1' command not found"
    fi
}

#-------------------------------------------------------------
# CHECK COMMAND
# This function checks if a specific command is available in
# the system. It returns success if the command is found,
# otherwise it returns failure.
#
# Usage example:
#   check_cmd "gcc"
#
# Arguments:
#   $1: The command to be checked for availability.
#-------------------------------------------------------------
check_cmd() {
    command -v "$1" >/dev/null 2>&1
}

setup_colors
parse_params "$@"
main "$@"
