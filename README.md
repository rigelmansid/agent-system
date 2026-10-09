<div align="center">

# agent-system

**Start a new session without re-explaining; end one so the next can pick up.**

Rules and commands for Claude Code: `/adopt` brings a project in, `/pickup` resumes where you left
off, `/wrap` records the session, `/private` checks for private details written by mistake. Codex
reads the same rules.

[![License: MIT](https://img.shields.io/badge/License-MIT-blue)](LICENSE)
[![Claude Code](https://img.shields.io/badge/Claude%20Code-skills-D97757)](#commands)
[![Shell](https://img.shields.io/badge/shell-bash%203.2%2B-4EAA25?logo=gnubash&logoColor=white)](#install)

**English** · [简体中文](README.zh-CN.md)

</div>

---

The rules, the command instructions and the notes they write are in Chinese; the agent replies in
whatever language you use.

## Install

**Requirements**: [Claude Code](https://code.claude.com/docs) and git. Codex is optional. The scripts
are tested on macOS (bash 3.2).

1. Clone into `~/agent-system`. The rules and commands refer to that path, so keep it there. The address
   is under the Code button on this repository's page:

   ```sh
   git clone <repository address> ~/agent-system
   ```

2. Create the links:

   ```sh
   ~/agent-system/bin/install
   ```

   It links `~/.claude/CLAUDE.md` and `~/.codex/AGENTS.md` to [RULE.md](RULE.md) and links the commands
   into `~/.claude/skills/`. It is safe to rerun. An existing file with the same name is never
   overwritten: it shows `SKIP`; move that file away and run it again.

3. Start a new Claude Code session and the commands are available.

**Update**: type `/update` in Claude Code. It pulls the latest main, rebuilds the links and lists the
new decisions.

**Uninstall**: everything installed is a link, so delete the links:

```sh
rm ~/.claude/CLAUDE.md ~/.codex/AGENTS.md ~/.claude/skills/{adopt,pickup,private,update,wrap}
```

## Quick start

1. Open Claude Code in a project folder and type `/adopt`. In a project without notes it creates four
   blank files; in one that already has notes it first proposes how to move them, and moves them once
   you agree.
2. Work as usual. The agent records decisions and pitfalls as they come up.
3. At the end, type `/wrap`. It adds any missing decisions and pitfalls, rewrites the handoff block and
   reports what was done.
4. Next time, type `/pickup` if you want to continue. It shows where the last session stopped and what
   comes next.

## Commands

| Command | What it does |
|---|---|
| `/adopt` | Brings a project in: creates the four files, or moves existing notes into them. In git projects it also installs the pre-commit hook and asks which words to block. After moving to a new machine, run it again in each project to restore what clone does not bring |
| `/pickup` | Reads the handoff block, the to-do list and the related decisions and shows them; read-only |
| `/wrap` | Wraps up: records missing decisions and pitfalls, rewrites the handoff block, updates the to-do list, gives a four-part report |
| `/private` | Checks changed files for private details written by mistake; reports locations without repeating the values, and replaces them with placeholders once you agree |
| `/update` | Updates agent-system from GitHub |

The commands run only when you type them. In a project that has not been adopted, `/pickup` and
`/wrap` still work, but only report in the conversation and create no files.

## How it works

- **Rules**: [RULE.md](RULE.md) loads in every session. It covers how sessions start and end, how
  decisions and pitfalls are recorded, which actions need your go-ahead, how results are verified and
  how private details are kept out of committed files. The aim is simple, minimal and efficient.
- **Four files in each project**, created by `/adopt`:

  | File | Contents |
  |---|---|
  | `docs/project-notes.md` | The handoff block at the top, where the next session picks up; the project overview and to-do list |
  | `docs/decisions.md` | Decisions D-n: background, options, choice, reason, impact |
  | `docs/pitfalls.md` | Pitfalls 坑 n: what happened, why, the fix, the lesson |
  | `private-notes.md` | Real hosts, usernames and accounts, kept out of git; committed files use placeholders |

- **Adopted** means the project has `docs/project-notes.md`.
- Project-specific rules go in the project's optional `AGENTS.md`; `CLAUDE.md` is a symlink to it.

## Day to day

- Start by saying what you want done. The agent does not read the project state on its own; type
  `/pickup` first if you want to continue the last session.
- If the conversation is already long and you will be away for more than 5 minutes, run `/wrap` before
  you leave. The prompt cache expires after 5 minutes, and wrapping up later means writing the whole
  conversation into the cache again.
- Run `/private` before committing. In git projects the pre-commit hook also blocks tokens, private IPs
  and home directory paths at commit time.
- Leave code review to Codex: in Codex, say "review the uncommitted changes following
  ~/agent-system/docs/review.md".
- Do not use the built-in `/init` in these projects: it creates or rewrites CLAUDE.md, which here is
  usually a symlink to AGENTS.md.

## Moving to a new machine

1. Install as above.
2. Restore what exists only on the machine and does not come with clone:
   - in each adopted git project, after cloning it, type `/adopt` to restore the pre-commit hook and
     the privacy patterns file;
   - copy each project's `private-notes.md` over from the old machine.
3. Open a new session in a project and type `/pickup` to check that the handoff block shows.

## What is in the repository

| File | Purpose |
|---|---|
| [RULE.md](RULE.md) | The shared rules |
| `claude/skills/` | The five commands |
| `bin/install` | Creates the links; when a command is renamed or removed, its old link is deleted. Installs no hooks; Codex gets only RULE.md |
| `git-hooks/pre-commit` | Blocks tokens and keys (reporting line numbers only), private IPs, home directory paths, U+FFFD and the words in `.git/privacy-patterns` before a commit. `/adopt` installs it in git projects |
| [docs/review.md](docs/review.md) | Code review rules for Codex |
| `bin/release`, `.claude/skills/release`, `tests/run.sh` | The maintainer's release script and command, and the regression tests; see the next section |
| [docs/decisions.md](docs/decisions.md), [docs/pitfalls.md](docs/pitfalls.md) | This repository's own decisions and pitfalls |

## Maintainers: changing this repository

This section applies only to the maintainer's own machine. GitHub has only main; users just run
`/update`.

- `~/agent-system` is the live copy: every link and every path in the rules points there, so a change
  made there reaches every new session. Work in a separate worktree instead:
  `git -C ~/agent-system worktree add -b core ~/agent-system-dev`, and open Claude in
  `~/agent-system-dev` (D-45, D-63).
- After changing `bin/` or `git-hooks/`, run `tests/run.sh` and commit only when it passes. Then type
  `/release`, which runs `bin/release`: once the tests pass it fast-forwards main to the working branch,
  tags `release-N`, lists the new decisions (those affecting existing projects marked `!`) and runs
  `bin/install`. If something breaks, `bin/release --rollback` goes back one release each time.
- Push only main; the working branch and release tags stay local (D-48). Every push needs explicit
  approval.
- This repository's `.git/privacy-patterns` does not come with clone; recreate it on a new machine
  (D-12).
- Keep the two READMEs (`README.md` in English, `README.zh-CN.md` in Chinese) in sync.
- Record rule decisions in [docs/decisions.md](docs/decisions.md) when they are made and pitfalls in
  [docs/pitfalls.md](docs/pitfalls.md); commit bodies cite `Why: D-n`. End the impact item of a new
  decision with "影响现有项目：是/否（原因）" on one line; `bin/release` uses it to mark those decisions.

## License

[MIT](LICENSE)
