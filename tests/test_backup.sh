#!/usr/bin/env bash
source "$(dirname "$0")/lib.sh"

# Change to true when you start Milestone 3.
STARTED=false

make_source() {
    mkdir -p "$TMP/projects/notes"
    echo "hello" > "$TMP/projects/readme.txt"
    echo "todo" > "$TMP/projects/notes/todo.txt"
}

test_creates_archive_containing_the_folder() {
    make_source
    BACKUP_TIMESTAMP=20261107-093000 run "$SCRIPTS/backup.sh" -s "$TMP/projects" -d "$TMP/backups"
    assert_status 0
    local archive="$TMP/backups/projects-20261107-093000.tar.gz"
    assert_file_exists "$archive"
    assert_contains "$OUT" "Created $archive"
    mkdir "$TMP/restore"
    tar -xzf "$archive" -C "$TMP/restore"
    assert_equals "todo" "$(cat "$TMP/restore/projects/notes/todo.txt")"
}

test_works_with_relative_paths() {
    make_source
    BACKUP_TIMESTAMP=20261107-093000 run "$SCRIPTS/backup.sh" -s projects -d backups
    assert_status 0
    assert_file_exists "$TMP/backups/projects-20261107-093000.tar.gz"
}

test_keeps_only_the_newest_backups() {
    make_source
    local t
    for t in 01 02 03 04; do
        BACKUP_TIMESTAMP="20261107-0900$t" run "$SCRIPTS/backup.sh" -s "$TMP/projects" -d "$TMP/backups" -k 2
        assert_status 0
    done
    assert_contains "$OUT" "Removed $TMP/backups/projects-20261107-090002.tar.gz"
    assert_equals "projects-20261107-090003.tar.gz
projects-20261107-090004.tar.gz" "$(ls "$TMP/backups")"
}

test_rotation_ignores_other_files() {
    make_source
    mkdir "$TMP/backups"
    touch "$TMP/backups/other-20200101-000000.tar.gz" "$TMP/backups/notes.txt"
    BACKUP_TIMESTAMP=20261107-090001 run "$SCRIPTS/backup.sh" -s "$TMP/projects" -d "$TMP/backups" -k 1
    BACKUP_TIMESTAMP=20261107-090002 run "$SCRIPTS/backup.sh" -s "$TMP/projects" -d "$TMP/backups" -k 1
    assert_status 0
    assert_file_exists "$TMP/backups/projects-20261107-090002.tar.gz"
    assert_file_exists "$TMP/backups/other-20200101-000000.tar.gz"
    assert_file_exists "$TMP/backups/notes.txt"
    assert_file_missing "$TMP/backups/projects-20261107-090001.tar.gz"
}

test_does_not_overwrite_an_existing_archive() {
    make_source
    mkdir "$TMP/backups"
    echo "keep me" > "$TMP/backups/projects-20261107-093000.tar.gz"
    BACKUP_TIMESTAMP=20261107-093000 run "$SCRIPTS/backup.sh" -s "$TMP/projects" -d "$TMP/backups"
    assert_status 1
    assert_equals "keep me" "$(cat "$TMP/backups/projects-20261107-093000.tar.gz")"
}

test_uses_date_when_no_timestamp_given() {
    make_source
    run "$SCRIPTS/backup.sh" -s "$TMP/projects" -d "$TMP/backups"
    assert_status 0
    local name
    name="$(ls "$TMP/backups")"
    [[ "$name" =~ ^projects-[0-9]{8}-[0-9]{6}\.tar\.gz$ ]] || fail "unexpected archive name: $name"
}

test_invalid_options_exit_two() {
    make_source
    run "$SCRIPTS/backup.sh" -s "$TMP/missing" -d "$TMP/backups"
    assert_status 2
    run "$SCRIPTS/backup.sh" -d "$TMP/backups"
    assert_status 2
    run "$SCRIPTS/backup.sh" -s "$TMP/projects"
    assert_status 2
    run "$SCRIPTS/backup.sh" -s "$TMP/projects" -d "$TMP/backups" -k 0
    assert_status 2
    run "$SCRIPTS/backup.sh" -s "$TMP/projects/readme.txt" -d "$TMP/backups"
    assert_status 2
}

run_tests
