<!-- profile: code -->
# AGENTS.md

Working rules for AI agents and maintainers of this repository. `CLAUDE.md` is
a symlink to this file; edit `AGENTS.md` only.

This file says *how to work*. Project content lives in `docs/`:
[project-notes.md](docs/project-notes.md) (work in progress, status, todo,
plan; § numbers below refer to it), [decisions.md](docs/decisions.md) (D-n),
[pitfalls.md](docs/pitfalls.md) (坑 n) and [log.md](docs/log.md) (history and
verification records). Do not copy project content into this file.

## What exists

<Commands, scripts and entry points that exist today.>

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

- The session workflow (`/pickup`, recording decisions, `/wrap`) follows
  `~/agent-system/RULE.md`; this file adds only project-specific rules.
- Docs language: <language>.

## Privacy and publishing

- `private-notes.md` is git-ignored and holds real hosts, usernames and
  personal config. Never copy its content into tracked files, commit messages
  or PRs; use placeholders such as `<host>` and `<user>`.
- Reference material, unsorted notes and scratch output live outside the
  repository in the maintainer's `../materials/` (`refs/`, `inbox/`,
  `scratch/`), which may not exist on other machines. Never write scratch
  files or generated output into the repository; use `../materials/scratch/`.
- <Branch, remote and identity rules.>
