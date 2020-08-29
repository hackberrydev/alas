# alas

Alas is a command line utility for managing TODO list in a single Markdown file.

Example TODO list:

```markdown
# Main TODO

## 2020-08-01, Saturday

- [ ] Develop photos for the grandmother
- [X] Pay bills

## 2020-07-31, Friday

- [X] Review open pull requests
- [X] Fix flaky test
```

## Commands

### `alas stats`

`alas stats` command will print the number of days in your TODO list, the number
of completed tasks and the number of pending tasks:

```bash
$ alas stats ~/todo.md
2 days
3 completed tasks
1 pending task
```
