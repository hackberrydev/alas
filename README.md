# Alas

Alas is a command line utility for managing a plan in a single Markdown file.

An example plan:

```markdown
# My Plan

## Inbox

- [ ] #home - Fix the lamp
- [ ] Update Rust

## 2020-08-01, Saturday

- [ ] Develop photos
- [X] Pay bills

## 2020-07-31, Friday

- Met with Mike and Molly
- [X] #work - Review open pull requests
- [X] #work - Fix the flaky test
```

The plan file has days in present and future that serve as your plan, but also
past days that serve as a log.

## Warning

Alas updates your backup file. Using `alas` can destroy your data due to
unintended use or a bug in Alas. **Always keep a backup of your plan file.**

Alas has a built in backup, but it's best to use a separate backup solution as
well.

A version control system, such as [Git](https://git-scm.com/) is a convenient
option.

## Commands

### `--skip-backup`

Alas will create a backup of the plan file before running any other commands, by
default. To skip creating a backup, pass the `--skip-backup` option.

### `--stats`

`alas --stats` command will print the number of days in your plan, the number
of completed tasks and the number of pending tasks:

```bash
$ alas --stats ~/todo.md
2 days
3 completed tasks
1 pending task
```

### `--insert-days`

`alas --insert-days 3` will insert 3 new days (starting from today) in your plan
file.

### `--remove-empty-days`

`alas --remove-empty-days` will remove past days that don't have any events or
tasks from the plan.

### `--report`

`alas --report 7` will print all tasks for the last 7 days, excluding today.

### `--schedule-tasks`

Alas allows keeping a list of scheduled tasks in a separate file. For example:

```markdown
# My Scheduled Tasks

- Meeting with Jonh (on 2022-05-12)
- Tina's birthday (every year on 10-11)
- Run 20 minutes (every Monday)
- Run 20 minutes (every Thursday)
- #work - Weekly meeting (every Tuesday)
- #work - Deploy new version (every weekday)
- #work - Generate monthly report (every month)
- #work - Generate quarterly report (every 3 months)
```

You can then run the following command to insert matching scheduled tasks into
your plan:

```bash
alas --insert-days 3 --schedule-tasks scheduled.md plan.md
```

Alas supports the following schedule options:

- Specific day of the week - `every Monday`, `every Tuesday`, etc.
- On weekdays - `every weekday` - any day of the week except Saturday and Sunday.
- First of the month - `every month`.
- First of the quarter - `every 3 months` - January 1st, April 1st, July 1st, October 1st.
- A specific day every year - `every year on 05-15`.
- A specific date - `on 2025-05-15`.

**Note:** Alas will insert scheduled tasks only in days that are already
present in the plan. If a day doesn't exist, `--schedule-tasks` won't insert
a day.  This means that it's best to use `--schedule-tasks` in combination
with `--insert-days`. Alas will make sure that `--insert-days` is always
executed before `--schedule-tasks`.

If you don't use `--insert-days`, you need to insert empty days manually or in
some other way before running `--schedule-tasks`.

### `--version`

`alas --version` will output the version and exit. This command is available
only when no other commands are used.

### Running multiple commands

Alas supports running multiple commands:

```bash
alas --insert-days 3 --remove-empty-days plan.md
```
