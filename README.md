# Linux admin scripts

![Tests](https://github.com/RakibsCraft/linux-admin-scripts/actions/workflows/tests.yml/badge.svg)

Bash scripts I'm building for routine Linux server administration: disk space checks, user account audits, backups, log rotation, service monitoring and a health summary. Each one is built to run unattended from cron and reports results with the exit codes monitoring tools such as Nagios and Zabbix expect.

**Stack:** Bash, standard Linux tools (df, tar, stat, pgrep, awk), ShellCheck, GitHub Actions

## The scripts

| Script | What it does |
|---|---|
| `disk_check.sh` | Flags filesystems above warning and critical usage levels |
| `user_audit.sh` | Finds hidden root accounts, system accounts with login shells, and malformed entries in `/etc/passwd` |
| `backup.sh` | Makes compressed, verified backups of a directory and deletes the oldest ones |
| `log_rotate.sh` | Rotates a log file once it reaches a size limit, keeping a set number of old copies |
| `process_monitor.sh` | Checks that named services are running and reports their PIDs |
| `system_report.sh` | One-screen summary of uptime, memory and disk usage |

## Examples

```
$ ./scripts/disk_check.sh -w 80 -c 90
CRITICAL / 90%
WARNING /var 85%
$ echo $?
2

$ ./scripts/user_audit.sh
WARNING system-shell mysql /bin/bash
CRITICAL uid0 toor
INFO human alice uid=1000 shell=/bin/bash
Summary: 1 human, 1 critical, 1 warning

$ ./scripts/backup.sh -s /var/www -d /srv/backups -k 14
Created /srv/backups/www-20261107-013000.tar.gz
Removed /srv/backups/www-20261024-013000.tar.gz

$ ./scripts/process_monitor.sh sshd cron nginx
OK sshd running (pid 642)
OK cron running (pid 611)
CRITICAL nginx not running

$ ./scripts/system_report.sh
Host: web01
Uptime: 3d 5h 5m
Memory: 6080/15857 MB used (38%)
Disk:
  OK all filesystems below 80%
```

## Exit codes

The monitoring scripts follow the Nagios plugin convention, so they can plug straight into a monitoring system:

| Code | Meaning |
|---|---|
| 0 | OK |
| 1 | Warning |
| 2 | Critical |
| 3 | Unknown: bad options or unreadable input |

`backup.sh` and `log_rotate.sh` use 0 for success, 1 for a failed operation and 2 for bad options.

## Scheduling

`examples/crontab.example` shows how to run each script on a schedule with cron, logging output to files.

## Running the tests

```bash
./tests/run_all.sh                # all scripts
./tests/run_all.sh disk_check     # one script
```

The tests use a small framework in `tests/lib.sh`, so they need nothing beyond Bash. They read sample files in `tests/fixtures/` (sample `df` output, `/etc/passwd`, `/proc/meminfo`) so results don't depend on the machine running them. Each test runs in its own temporary directory.

Each test file has a `STARTED` switch at the top; tests for scripts not yet built are skipped. GitHub Actions runs the tests and ShellCheck on every push.

## Project structure

```
scripts/          the admin scripts
lib/common.sh     shared logging, error and validation helpers
tests/            test files, test framework and fixtures
examples/         crontab example
```
