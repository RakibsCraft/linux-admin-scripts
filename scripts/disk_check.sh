#!/usr/bin/env bash
#
# MILESTONE 1: disk_check.sh - warn when filesystems are filling up.
#
# Usage: disk_check.sh [-w WARN_PERCENT] [-c CRIT_PERCENT] [-f DF_FILE]
#
#   -w   warning level, default 80
#   -c   critical level, default 90
#   -f   read `df -P` style output from this file instead of running `df -P`
#        (the tests use this, so results don't depend on the machine)
#
# `df -P` output looks like this. Skip the header line. Use column 5 (Capacity)
# and the mount point, which is column 6 to the end of the line, because mount
# points can contain spaces.
#
#   Filesystem     1024-blocks      Used Available Capacity Mounted on
#   /dev/sda1         51290592  43597004   5055900      90% /
#   tmpfs              8120180         0   8120180       0% /dev/shm
#
# Skip lines whose Capacity is "-" (some special filesystems show this).
#
# Output, one line per filesystem at or above the warning level, in input order:
#   CRITICAL / 90%            (at or above the critical level)
#   WARNING /var 85%          (at or above warning, below critical)
# If none are at or above the warning level, print exactly one line:
#   OK all filesystems below 80%       (using the actual warning level)
#
# Exit codes (the Nagios convention, see lib/common.sh):
#   0 OK, 1 at least one WARNING and no CRITICAL, 2 at least one CRITICAL,
#   3 UNKNOWN: bad options, or the -f file doesn't exist. Print the problem to stderr.
#
# Options are valid when both levels are whole numbers from 1 to 100 and the
# warning level is lower than the critical level.
#
# Hints: getopts for options, `while read -r` to loop over lines,
# [[ ]] and (( )) for comparisons.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=SCRIPTDIR/../lib/common.sh
source "$SCRIPT_DIR/../lib/common.sh"

# TODO: write the script here.
die "Not implemented yet" 99
