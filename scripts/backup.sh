#!/usr/bin/env bash
#
# MILESTONE 3: backup.sh - compressed, verified, rotated backups of a directory.
#
# Usage: backup.sh -s SOURCE_DIR -d DEST_DIR [-k KEEP]
#
#   -s   directory to back up (required)
#   -d   directory to store backups in (required, created if missing)
#   -k   how many backups of this source to keep, default 7
#
# Steps:
#   1. Check the options. -s and -d are required, SOURCE_DIR must be an
#      existing directory, and KEEP must be a whole number of 1 or more.
#      Otherwise print the problem to stderr and exit 2.
#   2. Name the archive <source folder name>-<timestamp>.tar.gz, for example
#      projects-20261107-093000.tar.gz. The timestamp is `date +%Y%m%d-%H%M%S`,
#      or the BACKUP_TIMESTAMP environment variable if it's set (the tests use
#      this). If that file already exists, exit 1 without overwriting it.
#   3. Create it with tar so the archive contains the folder itself:
#      extracting it gives projects/..., not loose files.
#      Hint: tar -czf ARCHIVE -C <parent dir> <folder name>
#   4. Verify it by listing its contents (tar -tzf). If that fails, delete the
#      archive, print an error to stderr and exit 1.
#   5. Print: Created <archive path>
#   6. Delete the oldest backups of THIS source so only KEEP remain. Only
#      touch files named <source folder name>-*.tar.gz. Timestamps sort
#      correctly as text, so sorting the names sorts them by age.
#      Print: Removed <archive path>   for each one deleted.
#   7. Exit 0.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=SCRIPTDIR/../lib/common.sh
source "$SCRIPT_DIR/../lib/common.sh"

# TODO: write the script here.
die "Not implemented yet" 99
