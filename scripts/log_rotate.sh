#!/usr/bin/env bash
#
# MILESTONE 4: log_rotate.sh - rotate a log file before it fills the disk.
#
# Usage: log_rotate.sh -f LOGFILE [-s MAX_KB] [-n KEEP]
#
#   -f   the log file (required)
#   -s   rotate when the file is at least this many kilobytes (1 KB = 1024 bytes), default 1024
#   -n   how many old copies to keep, default 5
#
# If LOGFILE doesn't exist, or the options are invalid (MAX_KB a whole number,
# KEEP a whole number of 1 or more), print the problem to stderr and exit 2.
#
# If the file is smaller than MAX_KB, print:
#   No rotation needed: <file> is <size> bytes
# and exit 0. (-s 0 means always rotate.)
#
# Otherwise rotate, with KEEP=3 as an example:
#   app.log.3  is deleted
#   app.log.2  -> app.log.3
#   app.log.1  -> app.log.2
#   app.log    -> app.log.1
#   a new, empty app.log is created with the same permissions as the old one
# Missing numbered files are fine: skip them. Then print:
#   Rotated <file>
# and exit 0.
#
# Hints: stat -c %s gives the size in bytes and stat -c %a the permissions.
# Count down when shifting files, or you'll overwrite the ones you need.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=SCRIPTDIR/../lib/common.sh
source "$SCRIPT_DIR/../lib/common.sh"

# TODO: write the script here.
die "Not implemented yet" 99
