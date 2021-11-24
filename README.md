# Alas

Alas is a command line utility for managing a plan in a single Markdown file.

An example plan:

```markdown
# My Plan

## 2020-08-01, Saturday

- [ ] Develop photos for the grandmother
- [X] Pay bills

## 2020-07-31, Friday

- [X] Review open pull requests
- [X] Fix flaky test
```

## Commands

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
