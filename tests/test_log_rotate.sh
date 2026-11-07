#!/usr/bin/env bash
source "$(dirname "$0")/lib.sh"

# Change to true when you start Milestone 4.
STARTED=false

# Writes N kilobytes to a file.
fill_kb() {
    head -c "$(($2 * 1024))" /dev/zero | tr '\0' 'x' > "$1"
}

test_small_file_is_left_alone() {
    fill_kb app.log 1
    run "$SCRIPTS/log_rotate.sh" -f app.log -s 2
    assert_status 0
    assert_equals "No rotation needed: app.log is 1024 bytes" "$OUT"
    assert_file_missing app.log.1
}

test_rotates_when_at_the_limit() {
    fill_kb app.log 2
    run "$SCRIPTS/log_rotate.sh" -f app.log -s 2
    assert_status 0
    assert_equals "Rotated app.log" "$OUT"
    assert_equals 2048 "$(stat -c %s app.log.1)"
    assert_equals 0 "$(stat -c %s app.log)"
}

test_shifts_old_copies_and_deletes_the_oldest() {
    echo current > app.log
    echo one > app.log.1
    echo two > app.log.2
    echo three > app.log.3
    run "$SCRIPTS/log_rotate.sh" -f app.log -s 0 -n 3
    assert_status 0
    assert_equals current "$(cat app.log.1)"
    assert_equals one "$(cat app.log.2)"
    assert_equals two "$(cat app.log.3)"
    assert_file_missing app.log.4
    assert_equals "" "$(cat app.log)"
}

test_handles_gaps_in_numbered_copies() {
    echo current > app.log
    echo two > app.log.2
    run "$SCRIPTS/log_rotate.sh" -f app.log -s 0 -n 5
    assert_status 0
    assert_equals current "$(cat app.log.1)"
    assert_file_missing app.log.2
    assert_equals two "$(cat app.log.3)"
}

test_keeps_permissions() {
    echo data > app.log
    chmod 640 app.log
    run "$SCRIPTS/log_rotate.sh" -f app.log -s 0
    assert_status 0
    assert_file_exists app.log.1
    assert_equals 640 "$(stat -c %a app.log)"
}

test_default_size_is_one_megabyte() {
    fill_kb app.log 1023
    run "$SCRIPTS/log_rotate.sh" -f app.log
    assert_contains "$OUT" "No rotation needed"
    fill_kb app.log 1024
    run "$SCRIPTS/log_rotate.sh" -f app.log
    assert_equals "Rotated app.log" "$OUT"
}

test_default_keeps_five() {
    local i
    for i in 1 2 3 4 5; do echo "$i" > "app.log.$i"; done
    echo current > app.log
    run "$SCRIPTS/log_rotate.sh" -f app.log -s 0
    assert_equals 4 "$(cat app.log.5)"
    assert_file_missing app.log.6
}

test_works_with_paths_in_other_folders() {
    mkdir logs
    echo current > logs/app.log
    run "$SCRIPTS/log_rotate.sh" -f "$TMP/logs/app.log" -s 0
    assert_status 0
    assert_equals current "$(cat logs/app.log.1)"
}

test_invalid_input_exits_two() {
    run "$SCRIPTS/log_rotate.sh" -f missing.log
    assert_status 2
    [[ -n "$ERR" ]] || fail "expected an error message on stderr"
    echo x > app.log
    run "$SCRIPTS/log_rotate.sh" -f app.log -n 0
    assert_status 2
    run "$SCRIPTS/log_rotate.sh" -f app.log -s big
    assert_status 2
    run "$SCRIPTS/log_rotate.sh"
    assert_status 2
}

run_tests
