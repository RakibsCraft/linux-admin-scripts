#!/usr/bin/env bash
source "$(dirname "$0")/lib.sh"

# Change to true when you start Milestone 1.
STARTED=false

test_all_ok() {
    run "$SCRIPTS/disk_check.sh" -f "$FIXTURES/df_ok.txt"
    assert_status 0
    assert_equals "OK all filesystems below 80%" "$OUT"
}

test_reports_warnings_and_criticals_in_order() {
    run "$SCRIPTS/disk_check.sh" -f "$FIXTURES/df_mixed.txt"
    assert_status 2
    assert_equals "CRITICAL / 90%
WARNING /var 85%
WARNING /mnt/my disk 82%
CRITICAL /data 99%" "$OUT"
}

test_warning_only_exits_one() {
    run "$SCRIPTS/disk_check.sh" -f "$FIXTURES/df_warning.txt"
    assert_status 1
    assert_equals "WARNING /var 85%" "$OUT"
}

test_custom_levels() {
    run "$SCRIPTS/disk_check.sh" -w 40 -c 50 -f "$FIXTURES/df_ok.txt"
    assert_status 2
    assert_equals "WARNING / 43%
CRITICAL /var 79%" "$OUT"
}

test_ok_message_uses_the_warning_level() {
    run "$SCRIPTS/disk_check.sh" -w 95 -c 100 -f "$FIXTURES/df_ok.txt"
    assert_status 0
    assert_equals "OK all filesystems below 95%" "$OUT"
}

test_level_boundaries_are_inclusive() {
    run "$SCRIPTS/disk_check.sh" -w 79 -c 85 -f "$FIXTURES/df_mixed.txt"
    assert_contains "$OUT" "WARNING /boot 79%"
    assert_contains "$OUT" "CRITICAL /var 85%"
}

test_bad_options_exit_unknown() {
    run "$SCRIPTS/disk_check.sh" -w 90 -c 80 -f "$FIXTURES/df_ok.txt"
    assert_status 3
    [[ -n "$ERR" ]] || fail "expected an error message on stderr"
    run "$SCRIPTS/disk_check.sh" -w abc -f "$FIXTURES/df_ok.txt"
    assert_status 3
    run "$SCRIPTS/disk_check.sh" -c 101 -f "$FIXTURES/df_ok.txt"
    assert_status 3
    run "$SCRIPTS/disk_check.sh" -w 0 -f "$FIXTURES/df_ok.txt"
    assert_status 3
}

test_missing_file_exits_unknown() {
    run "$SCRIPTS/disk_check.sh" -f "$TMP/nope.txt"
    assert_status 3
    [[ -n "$ERR" ]] || fail "expected an error message on stderr"
}

test_runs_df_when_no_file_given() {
    run "$SCRIPTS/disk_check.sh" -w 99 -c 100
    [[ "$STATUS" =~ ^[012]$ ]] || fail "expected exit code 0, 1 or 2 from real df, got $STATUS: $ERR"
    [[ -n "$OUT" ]] || fail "expected some output"
}

run_tests
