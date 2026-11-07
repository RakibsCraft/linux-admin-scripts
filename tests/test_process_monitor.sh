#!/usr/bin/env bash
source "$(dirname "$0")/lib.sh"

# Change to true when you start Milestone 5.
STARTED=false

# Starts a long-running process with a unique name and prints its PID.
start_fake_service() {
    cp "$(command -v sleep)" "$TMP/$1"
    "$TMP/$1" 300 >/dev/null 2>&1 &
    echo $!
}

stop_all() {
    pkill -f "$TMP/" 2>/dev/null || true
}

test_running_process() {
    local pid
    pid="$(start_fake_service fakesvc_a)"
    run "$SCRIPTS/process_monitor.sh" fakesvc_a
    stop_all
    assert_status 0
    assert_equals "OK fakesvc_a running (pid $pid)" "$OUT"
}

test_several_pids_are_comma_separated() {
    local p1 p2
    p1="$(start_fake_service fakesvc_b)"
    "$TMP/fakesvc_b" 300 >/dev/null 2>&1 &
    p2=$!
    run "$SCRIPTS/process_monitor.sh" fakesvc_b
    stop_all
    local first=$p1 second=$p2
    if ((p2 < p1)); then first=$p2; second=$p1; fi
    assert_equals "OK fakesvc_b running (pid $first,$second)" "$OUT"
}

test_missing_process() {
    run "$SCRIPTS/process_monitor.sh" no_such_process_xyz
    assert_status 2
    assert_equals "CRITICAL no_such_process_xyz not running" "$OUT"
}

test_mixed_results_in_order() {
    local pid
    pid="$(start_fake_service fakesvc_c)"
    run "$SCRIPTS/process_monitor.sh" no_such_process_xyz fakesvc_c
    stop_all
    assert_status 2
    assert_equals "CRITICAL no_such_process_xyz not running
OK fakesvc_c running (pid $pid)" "$OUT"
}

test_exact_name_match() {
    start_fake_service fakesvc_dd > /dev/null
    run "$SCRIPTS/process_monitor.sh" fakesvc_d
    stop_all
    assert_status 2
}

test_names_from_file() {
    local pid
    pid="$(start_fake_service fakesvc_e)"
    printf '# services to watch\nfakesvc_e\n\nno_such_process_xyz\n' > services.txt
    run "$SCRIPTS/process_monitor.sh" -f services.txt
    stop_all
    assert_status 2
    assert_equals "OK fakesvc_e running (pid $pid)
CRITICAL no_such_process_xyz not running" "$OUT"
}

test_no_names_exits_unknown() {
    run "$SCRIPTS/process_monitor.sh"
    assert_status 3
    run "$SCRIPTS/process_monitor.sh" -f missing.txt
    assert_status 3
    [[ -n "$ERR" ]] || fail "expected an error message on stderr"
}

run_tests
