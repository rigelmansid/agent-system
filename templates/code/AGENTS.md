<!-- profile: code -->
# AGENTS.md

Working rules for AI agents and maintainers of this repository. `CLAUDE.md` is
a symlink to this file; edit `AGENTS.md` only.

This file says *how to work*. Project content lives in `docs/`:
[project-notes.md](docs/project-notes.md) (work in progress, status, todo,
plan; § numbers below refer to it), [decisions.md](docs/decisions.md) (D-n),
[pitfalls.md](docs/pitfalls.md) (坑 n) and [log.md](docs/log.md) (history and
verification records). Do not copy project content into this file.

## Getting started

1. Read project-notes 进行中 and the todo list, then restate the state to the
   user before changing anything.
2. What exists: <commands, scripts, entry points>. Anything listed as planned
   does not exist yet; never describe it as existing or invent its interface.

## Commands

```sh
<syntax checks, tests with expected results and duration>
```

<Test prerequisites, known flaky tests.>

## Changing <key module>

<Invariants that must not break, each citing D-n or 坑 n.>

## Working with <external system>

<Rules for real hosts, services or data.>

## Verification

<What counts as an end-to-end check in this project, and what does not.>

## Keeping docs current

- Record decisions in `docs/decisions.md` when they are made, not at the end.
- At the end of a unit of work, overwrite 进行中, append to `docs/log.md`, and
  update the todo list and current status.
- Docs language: <language>.

## Privacy and publishing

- `private-notes.md` is git-ignored and holds real hosts, usernames and
  personal config. Never copy its content into tracked files, commit messages
  or PRs; use placeholders such as `<host>` and `<user>`.
- <Branch, remote and identity rules.>
