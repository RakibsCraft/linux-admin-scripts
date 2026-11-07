#!/usr/bin/env bash
source "$(dirname "$0")/lib.sh"

# Change to true when you start Milestone 6. It uses disk_check.sh, so finish Milestone 1 first.
STARTED=false

test_full_report() {
    run "$SCRIPTS/system_report.sh" -m "$FIXTURES/meminfo.txt" -u "$FIXTURES/uptime.txt" -d "$FIXTURES/df_mixed.txt"
    assert_status 2
    assert_equals "Host: $(hostname)
Uptime: 3d 5h 5m
Memory: 6080/15857 MB used (38%)
Disk:
  CRITICAL / 90%
  WARNING /var 85%
  WARNING /mnt/my disk 82%
  CRITICAL /data 99%" "$OUT"
}

test_exit_code_follows_disk_check() {
    run "$SCRIPTS/system_report.sh" -m "$FIXTURES/meminfo.txt" -u "$FIXTURES/uptime.txt" -d "$FIXTURES/df_ok.txt"
    assert_status 0
    assert_contains "$OUT" "Disk:
  OK all filesystems below 80%"
}

test_short_uptime() {
    echo "59.99 10.00" > uptime
    run "$SCRIPTS/system_report.sh" -m "$FIXTURES/meminfo.txt" -u uptime -d "$FIXTURES/df_ok.txt"
    assert_contains "$OUT" "Uptime: 0d 0h 0m"
    echo "86460.5 10.00" > uptime
    run "$SCRIPTS/system_report.sh" -m "$FIXTURES/meminfo.txt" -u uptime -d "$FIXTURES/df_ok.txt"
    assert_contains "$OUT" "Uptime: 1d 0h 1m"
}

test_reads_real_proc_files_by_default() {
    run "$SCRIPTS/system_report.sh" -d "$FIXTURES/df_ok.txt"
    assert_status 0
    [[ "$OUT" =~ Uptime:\ [0-9]+d\ [0-9]+h\ [0-9]+m ]] || fail "bad uptime line in: $OUT"
    [[ "$OUT" =~ Memory:\ [0-9]+/[0-9]+\ MB\ used\ \([0-9]+%\) ]] || fail "bad memory line in: $OUT"
}

test_missing_input_exits_unknown() {
    run "$SCRIPTS/system_report.sh" -m "$TMP/nope" -u "$FIXTURES/uptime.txt" -d "$FIXTURES/df_ok.txt"
    assert_status 3
    run "$SCRIPTS/system_report.sh" -m "$FIXTURES/meminfo.txt" -u "$TMP/nope" -d "$FIXTURES/df_ok.txt"
    assert_status 3
}

run_tests
