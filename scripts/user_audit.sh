#!/usr/bin/env bash
#
# MILESTONE 2: user_audit.sh - audit user accounts for security problems.
#
# Usage: user_audit.sh [-f PASSWD_FILE]
#
#   -f   file in /etc/passwd format, default /etc/passwd
#
# Each line of /etc/passwd has 7 fields separated by colons:
#   name:password:uid:gid:comment:home:shell
#   alice:x:1000:1000:Alice Byrne:/home/alice:/bin/bash
#
# Skip blank lines and lines starting with #.
#
# For each line, in file order, print a finding if one applies:
#   CRITICAL uid0 <name>
#       UID is 0 and the name isn't root. A second root account is a classic backdoor.
#   WARNING system-shell <name> <shell>
#       UID is 1 to 999 (a system account) and the shell is a login shell.
#       Shells that are NOT login shells: /usr/sbin/nologin, /sbin/nologin,
#       /bin/false, /usr/bin/false, /bin/sync, and an empty shell field.
#   INFO human <name> uid=<uid> shell=<shell>
#       UID is 1000 to 60000 (a person's account).
#   WARNING malformed-line <line number>
#       The line doesn't have exactly 7 fields, or the UID isn't a whole number.
#       Line numbers count every line in the file, starting at 1.
#
# Then print one summary line:
#   Summary: <h> human, <c> critical, <w> warning
#
# Exit codes: 2 if any CRITICAL, otherwise 1 if any WARNING, otherwise 0.
#   3 if the file can't be read (print the problem to stderr).
#
# Hint: IFS=: read -r name pass uid gid comment home shell
# (count the fields separately to catch malformed lines)

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=SCRIPTDIR/../lib/common.sh
source "$SCRIPT_DIR/../lib/common.sh"

# TODO: write the script here.
die "Not implemented yet" 99
