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

Alas can insert new empty days into your plan, remove empty days from past,
schedule tasks and help you stay in touch with your contacts.

For more information, visit the the main [Alas
website](https://www.hackberry.dev/alas/).

## Development

Install dependencies with:

```sh
jpm deps
```

Run tests with:

```sh
judge
```
