#!/usr/bin/env bash
#
# MILESTONE 6: system_report.sh - a one-screen health summary of the server.
#
# Usage: system_report.sh [-m MEMINFO_FILE] [-u UPTIME_FILE] [-d DF_FILE]
#
#   -m   default /proc/meminfo
#   -u   default /proc/uptime
#   -d   passed to disk_check.sh as -f (default: let disk_check run df itself)
#
# Print exactly this layout:
#
#   Host: <output of hostname>
#   Uptime: 3d 4h 5m
#   Memory: 6123/15857 MB used (38%)
#   Disk:
#     WARNING /var 85%
#
# Uptime: /proc/uptime's first number is seconds since boot, e.g. "277512.43 1093820.12".
#   Drop the decimal part and show whole days, hours and minutes (always all three).
# Memory: from MemTotal and MemAvailable in /proc/meminfo (values are in kB).
#   used = MemTotal - MemAvailable. Convert kB to MB by dividing by 1024 and
#   rounding down. Percentage = used * 100 / MemTotal, rounded down, using the kB values.
# Disk: run disk_check.sh (in the same folder as this script) and print each
#   line of its output indented by two spaces.
#
# Exit with disk_check.sh's exit code. If the meminfo or uptime file can't be
# read, print the problem to stderr and exit 3.
#
# Hint: Bash only does whole-number maths, so $(( )) rounds down for you.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=SCRIPTDIR/../lib/common.sh
source "$SCRIPT_DIR/../lib/common.sh"

# TODO: write the script here.
die "Not implemented yet" 99
