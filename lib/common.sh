#!/usr/bin/env bash
# Shared helpers. Load them at the top of a script with:
#
#   SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
#   source "$SCRIPT_DIR/../lib/common.sh"

# Monitoring exit codes, following the Nagios convention used by most
# monitoring tools (Nagios, Icinga, Zabbix, Checkmk).
# shellcheck disable=SC2034  # these are used by the scripts that source this file
readonly EXIT_OK=0
# shellcheck disable=SC2034
readonly EXIT_WARNING=1
# shellcheck disable=SC2034
readonly EXIT_CRITICAL=2
# shellcheck disable=SC2034
readonly EXIT_UNKNOWN=3

log_info() {
    printf '[INFO] %s\n' "$*"
}

log_error() {
    printf '[ERROR] %s\n' "$*" >&2
}

# Print an error to stderr and exit.
# Usage: die "message" [exit_code]     (exit code defaults to 2)
die() {
    local message="$1"
    local code="${2:-2}"
    log_error "$message"
    exit "$code"
}

# True if the argument is a whole number with no sign, e.g. 0, 7, 120.
is_whole_number() {
    [[ "$1" =~ ^[0-9]+$ ]]
}
