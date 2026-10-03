#!/bin/bash
# Regression tests for bin/, git-hooks/ and claude/hooks/ (D-17). Everything
# runs in a temp directory with a fake HOME and no global git config, so real
# projects and settings are never touched. Fake secrets, private IPs and home
# paths are assembled at run time: the literal values must not appear in this
# file, or the pre-commit hook would block committing it.
#   tests/run.sh        exits non-zero if any test fails
# Compatible with macOS bash 3.2.

set -u
root=$(cd "$(dirname "$0")/.." && pwd -P)
T=$(mktemp -d "${TMPDIR:-/tmp}/agent-system-tests.XXXXXX") || exit 1
trap 'rm -rf "$T"' EXIT

export HOME="$T/home" GIT_CONFIG_GLOBAL=/dev/null GIT_CONFIG_NOSYSTEM=1
export GIT_AUTHOR_NAME=test GIT_AUTHOR_EMAIL=test@example.invalid
export GIT_COMMITTER_NAME=test GIT_COMMITTER_EMAIL=test@example.invalid
mkdir -p "$HOME"

pass=0 fail=0
check() {  # check <name> <expected> <actual>
    if [ "$2" = "$3" ]; then
        pass=$((pass + 1))
    else
        fail=$((fail + 1))
        printf 'FAIL  %s: expected [%s], got [%s]\n' "$1" "$2" "$3"
    fi
}
section() { printf '== %s\n' "$1"; }

# ---------------------------------------------------------------- pre-commit
section "git-hooks/pre-commit"
repo="$T/pc"
git init -q "$repo" && ln -s "$root/git-hooks/pre-commit" "$repo/.git/hooks/pre-commit"
patterns="$repo/.git/privacy-patterns"

# Not called in $( ): it sets globals. result is pass|block; commit_out is
# what the hook printed.
result= commit_out=
try_commit() {  # try_commit <content>
    printf '%s\n' "$1" > "$repo/f.txt"
    git -C "$repo" add f.txt
    if commit_out=$(git -C "$repo" commit -qm t 2>&1); then
        result=pass
    else
        git -C "$repo" reset -q f.txt
        result=block
    fi
}

r() { printf "$1%.0s" $(seq "$2"); }  # r <text> <n>: repeat text n times
sk=sk-ant-api03-$(r Ab1 10)
gh=ghp_$(r Zx9 12)
aws=AKIA$(r QW3E 4)
slack=xoxb-1234-$(r abcde 2)
cr=cr_$(r 0a1b 10)
pw=Pw0rd$(r xyz 5)
key_header="-----BEGIN OPENSSH PRIVATE"" KEY-----"

for c in "key = $sk" "$gh" "id: $aws" "SLACK=$slack" "$key_header" \
         "ANTHROPIC_AUTH_TOKEN=$cr" "  \"ANTHROPIC_AUTH_TOKEN\": \"$cr\"," \
         "db_password: '$pw'" "API_KEY=$cr  # prod"; do
    try_commit "$c"
    check "secret blocked: ${c:0:16}..." block "$result"
    check "secret reported" 1 "$(printf '%s\n' "$commit_out" | grep -c 'content hidden')"
    case $commit_out in *"$sk"*|*"$gh"*|*"$aws"*|*"$slack"*|*"$cr"*|*"$pw"*)
        check "secret not echoed: ${c:0:16}..." hidden shown ;;
    esac
done
for c in 'TOKEN=<token>' 'export GITHUB_TOKEN=$GITHUB_TOKEN' \
         'token: ${{ secrets.GITHUB_TOKEN }}' 'password = os.environ["DB_PASSWORD"]' \
         'token_type = tokenizerConfigurationValue' 'password: hunter2' \
         'see risk-assessment-framework-documentation' \
         '    tokens: sqlite3_column_int64(stmt, 1),' \
         '    let cumulativeTokens    = ProviderCapabilities(rawValue: 1 << 1)'; do
    try_commit "$c"; check "passes: $c" pass "$result"
done

fffd=$'\xef\xbf\xbd'
try_commit "host 192.168"".1.20"; check "private IP blocked" block "$result"
try_commit "/Users""/someone/x"; check "home path blocked" block "$result"
try_commit "bad $fffd char"; check "U+FFFD blocked" block "$result"
try_commit "/Users/<user>/x"; check "placeholder path passes" pass "$result"

printf 'myhost\n' > "$patterns"
try_commit "ssh myhost"; check "privacy pattern blocks" block "$result"
try_commit "ssh other"; check "privacy pattern, no match" pass "$result"
printf -- '-dash-host\n' > "$patterns"
try_commit "to -dash-host"; check "pattern starting with -" block "$result"
printf 'myhost\n\n   \n# note\nother\n' > "$patterns"
try_commit "hello"; check "blank lines do not match all" pass "$result"
for bad in 'foo(' 'foo[' 'abc\'; do
    printf '# c\n\n%s\n' "$bad" > "$patterns"
    try_commit "unrelated"
    check "invalid regex blocks: $bad" block "$result"
    check "invalid regex line number: $bad" 1 "$(printf '%s\n' "$commit_out" | grep -c 'line 3$')"
done
printf 'ok\nbad((' > "$patterns"
try_commit "unrelated"; check "invalid last line without newline" block "$result"
rm -f "$patterns"

# --------------------------------------------------------------- new-project
section "bin/new-project"
mkdir -p "$T/P001_np"
n=0
for name in 'a/b' 'R&D' 'back\slash' 'Plain'; do
    n=$((n + 1)); d="$T/P001_np/p$n"
    "$root/bin/new-project" "$d" "$name" >/dev/null 2>&1
    check "exit 0: $name" 0 $?
    check "title: $name" "# $name 开发与维护记录" "$(head -1 "$d/docs/project-notes.md")"
    check "README: $name" "# $name" "$(cat "$d/README.md")"
    check "no empty files: $name" 0 \
        "$(find "$d" -type f -empty ! -name private-notes.md ! -path '*/.git/*' | wc -l | tr -d ' ')"
done
d="$T/P001_np/p4"
check "进行中 timestamp filled" 1 \
    "$(grep -cE '^更新：[0-9]{4}-[0-9]{2}-[0-9]{2} [0-9]{2}:[0-9]{2}$' "$d/docs/project-notes.md")"
check "no placeholders left" 0 "$(grep -cE 'HH:MM|<项目名>' "$d/docs/project-notes.md")"
check "example dates kept" 2 "$(cat "$d/docs/decisions.md" "$d/docs/pitfalls.md" | grep -c 'YYYY-MM-DD')"
check "no temp files" 0 "$(find "$T/P001_np" -name '*.tmp.*' | wc -l | tr -d ' ')"
check "CLAUDE.md links AGENTS.md" AGENTS.md "$(readlink "$d/CLAUDE.md")"
check "pre-commit installed" "$root/git-hooks/pre-commit" "$(readlink "$d/.git/hooks/pre-commit")"
check "materials created" yes "$([ -d "$T/P001_np/materials/scratch" ] && echo yes)"
"$root/bin/new-project" "$d" Plain >/dev/null 2>&1
check "rerun exits 0" 0 $?
: > "$d/docs/log.md"
"$root/bin/new-project" "$d" Plain >/dev/null 2>&1
check "existing empty file: exit 1" 1 $?
check "existing empty file not overwritten" 0 "$(wc -c < "$d/docs/log.md" | tr -d ' ')"
"$root/bin/new-project" "$T/P001_np/px" "$(printf 'a\nb')" >/dev/null 2>&1
check "control character rejected" 2 $?
check "rejected name creates nothing" no "$([ -e "$T/P001_np/px" ] && echo yes || echo no)"
mkdir -p "$T/P001_np/Dotted"
(cd "$T/P001_np/Dotted" && "$root/bin/new-project" . >/dev/null 2>&1)
check "dir '.': name from directory (D-20)" "# Dotted 开发与维护记录" \
    "$(head -1 "$T/P001_np/Dotted/docs/project-notes.md")"
(cd "$T/P001_np" && "$root/bin/new-project" Slashed/ >/dev/null 2>&1)
check "trailing slash: name from directory" "# Slashed" "$(cat "$T/P001_np/Slashed/README.md")"
(cd "$T/P001_np" && "$root/bin/new-project" . >/dev/null 2>&1)
check "container '.': refused (D-23)" 2 $?
check "container '.': nothing created" no \
    "$([ -e "$T/P001_np/AGENTS.md" ] || [ -e "$T/P001_np/.git" ] && echo yes || echo no)"
"$root/bin/new-project" "$T/P002_new" >/dev/null 2>&1
check "new container path: refused" 2 $?
check "new container path: not created" no "$([ -e "$T/P002_new" ] && echo yes || echo no)"

# ------------------------------------------------------------- session-start
section "claude/hooks/session-start.sh"
hook="$root/claude/hooks/session-start.sh"
mkdir -p "$T/ss/empty" "$T/ss/plain"
git init -q "$T/ss/plain"
out=$(CLAUDE_PROJECT_DIR="$T/ss/empty" "$hook"); rc=$?
check "empty dir: exit 0" 0 $rc
check "empty dir: no output" "" "$out"
out=$(CLAUDE_PROJECT_DIR="$T/ss/plain" "$hook")
check "plain repo: git state" 1 "$(printf '%s\n' "$out" | grep -c '^git 分支')"
check "plain repo: no restate" 0 "$(printf '%s\n' "$out" | grep -c '复述')"
out=$(CLAUDE_PROJECT_DIR="$T/P001_np/p4" "$hook")
check "project: 进行中 injected" 1 "$(printf '%s\n' "$out" | grep -c '^## 进行中')"
check "project: restate asked" 1 "$(printf '%s\n' "$out" | grep -c '复述')"
out=$(CLAUDE_PROJECT_DIR="$T/ss/missing" "$hook"); rc=$?
check "missing dir: exit 0, no output" "0:" "$rc:$out"
check "fresh project: no warnings" 0 "$(CLAUDE_PROJECT_DIR="$T/P001_np/p4" "$hook" | grep -c '^提醒')"

# Stale 进行中 (D-19): only commits after the stamp that skip the notes count.
s="$T/ss/stale"
mkdir -p "$s/docs" && git init -q "$s"
printf '## 进行中\n\n更新：2026-01-01 10:00\n- 任务：x\n' > "$s/docs/project-notes.md"
at() {  # at <time> <message> <file>...: commit the files at a fixed date
    local when=$1 msg=$2; shift 2
    git -C "$s" add "$@"
    GIT_AUTHOR_DATE="$when" GIT_COMMITTER_DATE="$when" git -C "$s" commit -qm "$msg"
}
echo a > "$s/code.txt"; at "2026-01-01T09:00:00" before docs/project-notes.md code.txt
out=$(CLAUDE_PROJECT_DIR="$s" "$hook")
check "commit before stamp: not stale" 0 "$(printf '%s\n' "$out" | grep -c '可能已过时')"
echo b > "$s/code.txt"; echo '- 停在：y' >> "$s/docs/project-notes.md"
at "2026-01-01T11:00:00" with-notes docs/project-notes.md code.txt
out=$(CLAUDE_PROJECT_DIR="$s" "$hook")
check "later commit that updates notes: not stale" 0 "$(printf '%s\n' "$out" | grep -c '可能已过时')"
echo c > "$s/code.txt"; at "2026-01-01T12:00:00" code-only code.txt
out=$(CLAUDE_PROJECT_DIR="$s" "$hook")
check "later commit without notes: stale" 1 "$(printf '%s\n' "$out" | grep -c '之后有 1 个提交没有更新它')"

seq 200 > "$s/AGENTS.md"
check "AGENTS.md at 200 lines: ok" 0 "$(CLAUDE_PROJECT_DIR="$s" "$hook" | grep -c 'AGENTS.md 有')"
seq 201 > "$s/AGENTS.md"
check "AGENTS.md over 200 lines: warned" 1 "$(CLAUDE_PROJECT_DIR="$s" "$hook" | grep -c 'AGENTS.md 有 201 行')"
seq 601 > "$s/docs/project-notes.md"
check "project-notes over 600 lines: warned" 1 \
    "$(CLAUDE_PROJECT_DIR="$s" "$hook" | grep -c 'project-notes.md 有 601 行')"

# Codex style (D-25): no CLAUDE_PROJECT_DIR, cwd is the session cwd (maybe a
# subdirectory), and a JSON object arrives on stdin.
codex_in='{"session_id":"t","cwd":"x","hook_event_name":"SessionStart","source":"startup"}'
p="$T/P001_np/p4"
mkdir -p "$p/sub/deeper"
out=$(cd "$p" && printf '%s' "$codex_in" | env -u CLAUDE_PROJECT_DIR "$hook"); rc=$?
check "codex at project root: exit 0" 0 $rc
check "codex at project root: 进行中 injected" 1 "$(printf '%s\n' "$out" | grep -c '^## 进行中')"
out=$(cd "$p/sub/deeper" && printf '%s' "$codex_in" | env -u CLAUDE_PROJECT_DIR "$hook")
check "codex in subdirectory: uses git root" 1 "$(printf '%s\n' "$out" | grep -c '^## 进行中')"
check "codex in subdirectory: restate asked" 1 "$(printf '%s\n' "$out" | grep -c '复述')"
out=$(cd "$T/ss/plain" && printf '%s' "$codex_in" | env -u CLAUDE_PROJECT_DIR "$hook")
check "codex in plain repo: git state only" "1:0" \
    "$(printf '%s\n' "$out" | grep -c '^git 分支'):$(printf '%s\n' "$out" | grep -c '复述')"
out=$(cd "$T/ss/empty" && printf '%s' "$codex_in" | env -u CLAUDE_PROJECT_DIR "$hook")
check "codex outside git: no output" "" "$out"

# ------------------------------------------------------------------- install
section "bin/install"
"$root/bin/install" >/dev/null 2>&1
check "first run without hook config: exit 1" 1 $?
check "CLAUDE.md linked" "$root/RULE.md" "$(readlink "$HOME/.claude/CLAUDE.md")"
check "codex AGENTS.md linked" "$root/RULE.md" "$(readlink "$HOME/.codex/AGENTS.md")"
for s in "$root"/claude/skills/*/; do
    s=$(basename "$s")
    check "skill $s linked" "$root/claude/skills/$s" "$(readlink "$HOME/.claude/skills/$s")"
    check "codex skill $s linked (D-25)" "$root/claude/skills/$s" "$(readlink "$HOME/.agents/skills/$s")"
done
codex_hooks="$HOME/.codex/hooks.json"
check "codex hooks.json created" 1 "$(grep -cF "\"command\": \"$hook\"" "$codex_hooks")"
if command -v python3 >/dev/null 2>&1; then
    python3 -m json.tool "$codex_hooks" >/dev/null 2>&1
    check "codex hooks.json is valid JSON" 0 $?
fi
printf '{"hooks":{"SessionStart":[{"hooks":[{"type":"command","command":"%s"}]}]}}\n' \
    "$hook" > "$HOME/.claude/settings.json"
"$root/bin/install" >/dev/null 2>&1
check "rerun with hook config: exit 0" 0 $?
printf '{"hooks":{}}\n' > "$codex_hooks"
"$root/bin/install" >/dev/null 2>&1
check "existing codex hooks.json without ours: exit 1" 1 $?
check "existing codex hooks.json not edited" '{"hooks":{}}' "$(cat "$codex_hooks")"
rm "$codex_hooks"
"$root/bin/install" >/dev/null 2>&1
check "codex hooks.json recreated when absent: exit 0" 0 $?
rm "$HOME/.codex/AGENTS.md" && echo mine > "$HOME/.codex/AGENTS.md"
"$root/bin/install" >/dev/null 2>&1
check "existing file: exit 1" 1 $?
check "existing file not overwritten" mine "$(cat "$HOME/.codex/AGENTS.md")"

echo
echo "passed $pass, failed $fail"
[ "$fail" = 0 ]
