#!/bin/bash
# run_swagger.sh - Launch a Swagger UI Docker container serving an OpenAPI specification.

set -euo pipefail

#######################################
# Prints usage information and exits.
# Globals:
#   None
# Arguments:
#   None
# Returns:
#   Exits with status 1.
#######################################
usage() {
    echo "Usage: $0 /path/to/openapi.yaml <port>"
    exit 1
}

#######################################
# Prints an error message to stderr and exits.
# Globals:
#   None
# Arguments:
#   A string describing the error.
# Returns:
#   Exits with status 1.
#######################################
error_exit() {
    echo "Error: $1" >&2
    exit 1
}

#######################################
# Validates input parameters and sets necessary global variables.
#
# Globals set:
#   OPENAPI_FILE, PORT, OPENAPI_ABS_PATH, OPENAPI_DIR, OPENAPI_BASE
#
# Arguments:
#   The script arguments.
# Returns:
#   Exits if validation fails.
#######################################
validate_inputs() {
    if [ "$#" -ne 2 ]; then
        usage
    fi

    OPENAPI_FILE="$1"
    PORT="$2"

    if [[ ! -f "$OPENAPI_FILE" ]]; then
        error_exit "File '$OPENAPI_FILE' does not exist."
    fi

    if ! [[ "$PORT" =~ ^[0-9]+$ ]]; then
        error_exit "Port '$PORT' is not a valid number."
    fi

    if ! command -v docker &>/dev/null; then
        error_exit "Docker is not installed."
    fi

    if [ "$PORT" -lt 1024 ]; then
        echo "Warning: Ports below 1024 are privileged. You might need to run this script with sudo." >&2
    fi

    # Get the absolute path to the file, its directory, and its filename.
    OPENAPI_ABS_PATH=$(realpath "$OPENAPI_FILE")
    OPENAPI_DIR=$(dirname "$OPENAPI_ABS_PATH")
    OPENAPI_BASE=$(basename "$OPENAPI_ABS_PATH")
}

#######################################
# Runs the Swagger UI Docker container.
#
# Globals:
#   PORT, OPENAPI_DIR, OPENAPI_BASE
#
# Arguments:
#   None
# Returns:
#   The container ID.
#######################################
run_docker() {
    docker run \
        -p "${PORT}:8080" \
        -e "SWAGGER_JSON=/tmp/${OPENAPI_BASE}" \
        -v "${OPENAPI_DIR}:/tmp" \
        swaggerapi/swagger-ui
}

#######################################
# Main script execution.
#
# Globals:
#   All globals set in validate_inputs.
#
# Arguments:
#   Script arguments.
# Returns:
#   Exits with status 0 on success.
#######################################
main() {
    validate_inputs "$@"

    echo "Starting Docker container with Swagger UI..."
    echo "Serving ${OPENAPI_ABS_PATH} on http://localhost:${PORT}"
    container_id=$(run_docker)
}

main "$@"
