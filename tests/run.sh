#!/bin/bash
# Regression tests for bin/ and git-hooks/ (D-17).
# Everything runs in a temp directory with a fake HOME and no global git config, so real
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

# More token formats and passwords in URLs (D-37).
google=AIza$(r Sy9 11)Ab
gitlab=glpat-$(r aB3 7)
npm=npm_$(r Xy7z 9)
stripe=sk_live_$(r 4eC3 6)
jwt=eyJ$(r hbGc 3).eyJ$(r zdWI 3).$(r Qw4 10)
urlpw="https://admin:""Pa55w0rd$(r x 6)@db.example.com/x"
for c in "key: $google" "$gitlab" "$npm" "$stripe" "auth: $jwt" "$urlpw"; do
    try_commit "$c"
    check "secret blocked: ${c:0:16}..." block "$result"
    case $commit_out in *"$google"*|*"$gitlab"*|*"$npm"*|*"$stripe"*|*"$jwt"*|*"$urlpw"*)
        check "secret not echoed: ${c:0:16}..." hidden shown ;;
    esac
done
for c in 'postgres://user:<password>@<host>:5432/db' 'postgres://app:${DB_PASS}@db:5432/x' \
         'git clone ssh://git@github.com:22/o/r.git' 'see http://localhost:8080/a@b' \
         'Aizawa is a name'; do
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
try_commit "$(seq 1 300000)"
check "large file: passes without Broken pipe" "pass:0" \
    "$result:$(printf '%s\n' "$commit_out" | grep -c 'Broken pipe')"
# A linked worktree must use the repository's privacy-patterns too (D-37).
printf 'wthost\n' > "$patterns"
git -C "$repo" worktree add -q "$T/pc-wt" -b wt >/dev/null 2>&1
printf 'ssh wthost\n' > "$T/pc-wt/w.txt" && git -C "$T/pc-wt" add w.txt
if git -C "$T/pc-wt" commit -qm t >/dev/null 2>&1; then wt=pass; else wt=block; fi
check "worktree uses privacy-patterns" block "$wt"
rm -f "$patterns"

# ------------------------------------------------------------------- install
section "bin/install"
"$root/bin/install" >/dev/null 2>&1
check "first run: exit 0" 0 $?
check "CLAUDE.md linked" "$root/RULE.md" "$(readlink "$HOME/.claude/CLAUDE.md")"
check "codex AGENTS.md linked" "$root/RULE.md" "$(readlink "$HOME/.codex/AGENTS.md")"
for s in "$root"/claude/skills/*/; do
    s=$(basename "$s")
    check "skill $s linked" "$root/claude/skills/$s" "$(readlink "$HOME/.claude/skills/$s")"
done
check "nothing installed for Codex but AGENTS.md (D-27)" "no:no" \
    "$([ -e "$HOME/.agents" ] && echo yes || echo no):$([ -e "$HOME/.codex/hooks.json" ] && echo yes || echo no)"
check "settings.json untouched, no hooks (D-39)" no "$([ -e "$HOME/.claude/settings.json" ] && echo yes || echo no)"
"$root/bin/install" >/dev/null 2>&1
check "rerun: exit 0" 0 $?
rm "$HOME/.codex/AGENTS.md" && echo mine > "$HOME/.codex/AGENTS.md"
"$root/bin/install" >/dev/null 2>&1
check "existing file: exit 1" 1 $?
check "existing file not overwritten" mine "$(cat "$HOME/.codex/AGENTS.md")"
# A link to a skill that no longer exists here is removed; other links are kept (D-58).
ln -s "$root/claude/skills/renamed" "$HOME/.claude/skills/renamed"
ln -s "$T/elsewhere/x" "$HOME/.claude/skills/foreign"
"$root/bin/install" >/dev/null 2>&1
check "stale skill link removed" no "$([ -L "$HOME/.claude/skills/renamed" ] && echo yes || echo no)"
check "foreign dangling link kept" yes "$([ -L "$HOME/.claude/skills/foreign" ] && echo yes || echo no)"
check "live skill links kept" "$root/claude/skills/pickup" "$(readlink "$HOME/.claude/skills/pickup")"

# ------------------------------------------------------------------- release
section "bin/release"
# A small repository stands in for ~/agent-system; its tests and install are stubs.
lv="$T/live" dv="$T/live-dev"
git init -q -b main "$lv" && mkdir -p "$lv/bin" "$lv/tests" "$lv/docs"
cp "$root/bin/release" "$lv/bin/release"
printf '#!/bin/bash\necho ran >> "$HOME/installs"\n' > "$lv/bin/install"
printf '#!/bin/bash\n[ ! -e "$HOME/fail-tests" ]\n' > "$lv/tests/run.sh"
chmod +x "$lv/bin/install" "$lv/tests/run.sh"
printf '### D-1 old\n' > "$lv/docs/decisions.md"
git -C "$lv" add -A && git -C "$lv" commit -qm base && git -C "$lv" worktree add -q -b dev "$dv"
base=$(git -C "$lv" rev-parse HEAD)
decide() {  # decide <id> <是|否>: commit a new decision in the dev worktree
    printf '\n### %s new\n\n- 影响：x。影响现有项目：%s（y）\n' "$1" "$2" >> "$dv/docs/decisions.md"
    git -C "$dv" commit -qam "$1"
}
at() { git -C "$lv" rev-parse "$1^{commit}"; }  # at <rev>: the commit it names in the live copy
listed() { printf '%s\n' "$out" | grep '^  [ !] D-'; }  # decisions in the release output

"$lv/bin/release" >/dev/null 2>&1
check "release from the live copy: refused" 1 $?
"$dv/bin/release" >/dev/null 2>&1
check "nothing new: exit 0, no tag" "0:" "$?:$(git -C "$lv" tag)"
decide D-2 是
touch "$HOME/fail-tests"
"$dv/bin/release" >/dev/null 2>&1
check "failing tests: refused, live copy untouched" "1:$base:" "$?:$(at HEAD):$(git -C "$lv" tag)"
rm "$HOME/fail-tests"
touch "$dv/stray" && "$dv/bin/release" >/dev/null 2>&1
check "uncommitted change in dev: refused" 1 $?
rm "$dv/stray"
touch "$lv/stray" && "$dv/bin/release" >/dev/null 2>&1
check "local change in the live copy: refused" 1 $?
rm "$lv/stray"
out=$("$dv/bin/release" 2>&1)
check "release: exit 0" 0 $?
check "release: live copy is at dev" "$(git -C "$dv" rev-parse HEAD)" "$(at HEAD)"
check "release: release-0 marks the state before" "$base" "$(at release-0)"
check "release: tagged release-1" "$(at HEAD)" "$(at release-1)"
check "release: decision marked as affecting projects" "  ! D-2 new" "$(listed)"
check "release: install ran" 1 "$(grep -c ran "$HOME/installs")"
# An old header that was only edited, here a superseded mark, is not a new decision.
sed 's/^### D-2 new$/### D-2 new (superseded by D-3)/' "$dv/docs/decisions.md" > "$T/dec" &&
    cat "$T/dec" > "$dv/docs/decisions.md"
decide D-3 否
out=$("$dv/bin/release" 2>&1)
check "second release: only the new decision, unmarked" "    D-3 new" "$(listed)"
"$dv/bin/release" --rollback >/dev/null 2>&1
check "rollback: live copy at release-1, main kept" "0:$(at release-1):$(at release-2)" \
    "$?:$(at HEAD):$(at main)"
"$lv/bin/release" --rollback >/dev/null 2>&1
check "rollback run from the live copy: release-0" "$base" "$(at HEAD)"
"$dv/bin/release" --rollback >/dev/null 2>&1
check "nothing before release-0: refused" 1 $?
"$dv/bin/release" >/dev/null 2>&1
check "nothing new: rolled-back copy stays" "$base" "$(at HEAD)"
decide D-4 否
"$dv/bin/release" >/dev/null 2>&1
check "release after a rollback: back on main" "main:$(git -C "$dv" rev-parse HEAD)" \
    "$(git -C "$lv" symbolic-ref -q --short HEAD):$(at HEAD)"
git -C "$lv" commit -q --allow-empty -m direct && decide D-5 否
"$dv/bin/release" >/dev/null 2>&1
check "main ahead of dev: refused" 1 $?
"$dv/bin/release" --bogus >/dev/null 2>&1
check "unknown option: usage error" 2 $?

echo
echo "passed $pass, failed $fail"
[ "$fail" = 0 ]
