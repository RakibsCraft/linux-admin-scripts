#!/usr/bin/env bash
# Runs every test file. Exits 1 if any test failed.
#   ./tests/run_all.sh                  run everything
#   ./tests/run_all.sh disk_check       run only tests/test_disk_check.sh

cd "$(dirname "$0")" || exit 1

status=0
for file in test_*.sh; do
    if [[ -n "${1:-}" && "$file" != "test_$1.sh" ]]; then
        continue
    fi
    echo "== $file"
    bash "$file" || status=1
done

if [[ "$status" -eq 0 ]]; then
    echo "All test files passed."
else
    echo "Some tests failed."
fi
exit "$status"
