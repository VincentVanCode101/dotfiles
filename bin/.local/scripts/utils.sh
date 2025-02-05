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
        err "Error: '$1' command not found"
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

#######################################
# Print an error message to STDERR and exit.
# Globals:
#   None
# Arguments:
#   Error message
#######################################
err() {
    echo "[$(date +'%Y-%m-%dT%H:%M:%S%z')]: $*" >&2
    exit 1
}
