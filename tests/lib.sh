#!/usr/bin/env bash
# A small test framework, so the tests need nothing beyond Bash.
#
# In a test file:
#   source "$(dirname "$0")/lib.sh"
#   test_something() {
#       run "$SCRIPTS/disk_check.sh" -f "$FIXTURES/df_ok.txt"
#       assert_status 0
#       assert_contains "$OUT" "OK"
#   }
#   run_tests
#
# Each test runs in its own subshell with a fresh empty directory in $TMP,
# so tests can't affect each other.

TESTS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPTS="$(cd "$TESTS_DIR/../scripts" && pwd)"
FIXTURES="$TESTS_DIR/fixtures"

# run COMMAND [ARGS...]
# Runs a command and stores its stdout in $OUT, stderr in $ERR and exit code in $STATUS.
run() {
    local errfile
    errfile="$(mktemp)"
    set +e
    OUT="$("$@" 2>"$errfile")"
    STATUS=$?
    set -e
    ERR="$(cat "$errfile")"
    rm -f "$errfile"
}

fail() {
    printf '      %s\n' "$@" >&2
    exit 1
}

assert_status() {
    [[ "$STATUS" == "$1" ]] || fail "expected exit code $1, got $STATUS" "stdout: $OUT" "stderr: $ERR"
}

assert_equals() {
    [[ "$2" == "$1" ]] || fail "expected: $1" "actual:   $2"
}

assert_contains() {
    [[ "$1" == *"$2"* ]] || fail "expected output to contain: $2" "actual output:" "$1"
}

assert_not_contains() {
    [[ "$1" != *"$2"* ]] || fail "expected output NOT to contain: $2" "actual output:" "$1"
}

assert_file_exists() {
    [[ -e "$1" ]] || fail "expected file to exist: $1"
}

assert_file_missing() {
    [[ ! -e "$1" ]] || fail "expected file NOT to exist: $1"
}

# Runs every function whose name starts with test_ and prints a summary.
run_tests() {
    local file passed=0 failed=0 name
    file="$(basename "$0")"
    if [[ "${STARTED:-false}" != "true" ]]; then
        printf 'SKIP %s (not started)\n' "$file"
        exit 0
    fi
    for name in $(declare -F | awk '{print $3}' | grep '^test_'); do
        if (
            set -e
            TMP="$(mktemp -d)"
            trap 'rm -rf "$TMP"' EXIT
            cd "$TMP"
            "$name"
        ); then
            printf '  PASS %s\n' "$name"
            passed=$((passed + 1))
        else
            printf '  FAIL %s\n' "$name"
            failed=$((failed + 1))
        fi
    done
    printf '%s: %d passed, %d failed\n' "$file" "$passed" "$failed"
    [[ "$failed" -eq 0 ]]
}
