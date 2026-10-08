<!-- profile: general -->
# AGENTS.md

Working rules for AI agents and maintainers of this project. `CLAUDE.md` is a
symlink to this file; edit `AGENTS.md` only.

This file says *how to work*. Project content lives in `docs/`:
[project-notes.md](docs/project-notes.md) (handoff, status, todo) and
[decisions.md](docs/decisions.md) (D-n). Do not copy project content into this
file.

## Deliverables

<What this project produces, where each deliverable goes, and its format.>

## Checks

<What to check before calling a deliverable done: links, sources, format.>

## Keeping docs current

- The session workflow (`/pickup`, recording decisions, `/wrap`) follows
  `~/agent-system/RULE.md`; this file adds only project-specific rules.
- Docs language: <language>.

## Privacy

- `private-notes.md` holds real names, hosts, accounts and personal config,
  and is listed in `.gitignore`. Never copy its content into other project
  files; use placeholders such as `<host>` and `<user>`.
- Reference material, unsorted notes and scratch output live outside the
  project in the maintainer's `../materials/` (`refs/`, `inbox/`, `scratch/`).
  Never write scratch files or generated output into the project; use
  `../materials/scratch/`.
