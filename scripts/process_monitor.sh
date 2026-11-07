#!/usr/bin/env bash
#
# MILESTONE 5: process_monitor.sh - check that important services are running.
#
# Usage: process_monitor.sh NAME [NAME...]
#        process_monitor.sh -f FILE
#
#   NAME  a process name, e.g. sshd, nginx, cron
#   -f    read names from FILE, one per line. Skip blank lines and lines
#         starting with #.
#
# For each name, in order, print:
#   OK <name> running (pid <pid>)            e.g. OK cron running (pid 812)
#   OK <name> running (pid <pid>,<pid>)      when there are several, comma separated
#   CRITICAL <name> not running
#
# Match the exact process name, so checking "ssh" doesn't match "sshd".
# Hint: pgrep -x NAME prints one PID per line, and exits 1 when there are none.
#
# Exit codes: 0 if all are running, 2 if any isn't.
#   3 if no names were given, or the -f file doesn't exist (print the problem to stderr).

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=SCRIPTDIR/../lib/common.sh
source "$SCRIPT_DIR/../lib/common.sh"

# TODO: write the script here.
die "Not implemented yet" 99
