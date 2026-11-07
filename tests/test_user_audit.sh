#!/usr/bin/env bash
source "$(dirname "$0")/lib.sh"

# Change to true when you start Milestone 2.
STARTED=false

test_sample_passwd_findings() {
    run "$SCRIPTS/user_audit.sh" -f "$FIXTURES/passwd_sample.txt"
    assert_status 2
    assert_equals "WARNING system-shell mysql /bin/bash
CRITICAL uid0 toor
INFO human alice uid=1000 shell=/bin/bash
INFO human bob uid=1001 shell=/usr/bin/zsh
WARNING malformed-line 12
Summary: 2 human, 1 critical, 2 warning" "$OUT"
}

test_clean_file_exits_zero() {
    run "$SCRIPTS/user_audit.sh" -f "$FIXTURES/passwd_clean.txt"
    assert_status 0
    assert_equals "INFO human alice uid=1000 shell=/bin/bash
Summary: 1 human, 0 critical, 0 warning" "$OUT"
}

test_warnings_without_criticals_exit_one() {
    printf 'root:x:0:0:root:/root:/bin/bash\npostgres:x:120:120::/var/lib/postgresql:/bin/bash\n' > passwd
    run "$SCRIPTS/user_audit.sh" -f passwd
    assert_status 1
    assert_contains "$OUT" "WARNING system-shell postgres /bin/bash"
}

test_non_numeric_uid_is_malformed() {
    printf 'root:x:0:0:root:/root:/bin/bash\nweird:x:abc:1::/home/weird:/bin/bash\n' > passwd
    run "$SCRIPTS/user_audit.sh" -f passwd
    assert_contains "$OUT" "WARNING malformed-line 2"
}

test_too_many_fields_is_malformed() {
    printf 'extra:x:1005:1005::/home/extra:/bin/bash:oops\n' > passwd
    run "$SCRIPTS/user_audit.sh" -f passwd
    assert_contains "$OUT" "WARNING malformed-line 1"
    assert_not_contains "$OUT" "INFO human extra"
}

test_every_non_login_shell_is_ignored() {
    : > passwd
    local i=1 shell
    for shell in /usr/sbin/nologin /sbin/nologin /bin/false /usr/bin/false /bin/sync ""; do
        printf 'svc%d:x:%d:%d::/:%s\n' "$i" "$((100 + i))" "$((100 + i))" "$shell" >> passwd
        i=$((i + 1))
    done
    run "$SCRIPTS/user_audit.sh" -f passwd
    assert_status 0
    assert_equals "Summary: 0 human, 0 critical, 0 warning" "$OUT"
}

test_reads_real_passwd_by_default() {
    run "$SCRIPTS/user_audit.sh"
    [[ "$STATUS" =~ ^[012]$ ]] || fail "expected exit code 0, 1 or 2, got $STATUS: $ERR"
    assert_contains "$OUT" "Summary:"
}

test_missing_file_exits_unknown() {
    run "$SCRIPTS/user_audit.sh" -f "$TMP/nope"
    assert_status 3
    [[ -n "$ERR" ]] || fail "expected an error message on stderr"
}

run_tests
