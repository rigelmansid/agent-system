#!/bin/bash
# Regression tests for bin/, git-hooks/ and the profiles' setup scripts (D-17).
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

# --------------------------------------------------------------- new-project
section "bin/new-project"
mkdir -p "$T/P001_np"
n=0
for name in 'a/b' 'R&D' 'back\slash' 'Plain'; do
    n=$((n + 1)); d="$T/P001_np/p$n"
    "$root/bin/new-project" "$d" code "$name" >/dev/null 2>&1
    check "exit 0: $name" 0 $?
    check "title: $name" "# $name 开发与维护记录" "$(head -1 "$d/docs/project-notes.md")"
    check "README: $name" "# $name" "$(cat "$d/README.md")"
    check "no empty files: $name" 0 \
        "$(find "$d" -type f -empty ! -name private-notes.md ! -path '*/.git/*' | wc -l | tr -d ' ')"
done
d="$T/P001_np/p4"
check "Handoff timestamp filled" 1 \
    "$(grep -cE '^Updated: [0-9]{4}-[0-9]{2}-[0-9]{2} [0-9]{2}:[0-9]{2}$' "$d/docs/project-notes.md")"
check "document date filled" 1 "$(grep -cE '^最后更新：[0-9]{4}-[0-9]{2}-[0-9]{2}。$' "$d/docs/project-notes.md")"
check "no placeholders left" 0 "$(grep -cE 'HH:MM|<项目名>' "$d/docs/project-notes.md")"
check "example dates kept" 2 "$(cat "$d/docs/decisions.md" "$d/docs/pitfalls.md" | grep -c 'YYYY-MM-DD')"
check "no temp files" 0 "$(find "$T/P001_np" -name '*.tmp.*' | wc -l | tr -d ' ')"
check "CLAUDE.md links AGENTS.md" AGENTS.md "$(readlink "$d/CLAUDE.md")"
check "pre-commit installed" "$root/git-hooks/pre-commit" "$(readlink "$d/.git/hooks/pre-commit")"
check "materials created" yes "$([ -d "$T/P001_np/materials/scratch" ] && echo yes)"
"$root/bin/new-project" "$d" code Plain >/dev/null 2>&1
check "rerun exits 0" 0 $?
: > "$d/docs/log.md"
"$root/bin/new-project" "$d" code Plain >/dev/null 2>&1
check "existing empty file: exit 1" 1 $?
check "existing empty file not overwritten" 0 "$(wc -c < "$d/docs/log.md" | tr -d ' ')"
"$root/bin/new-project" "$T/P001_np/px" code "$(printf 'a\nb')" >/dev/null 2>&1
check "control character rejected" 2 $?
check "rejected name creates nothing" no "$([ -e "$T/P001_np/px" ] && echo yes || echo no)"
mkdir -p "$T/P001_np/Dotted"
(cd "$T/P001_np/Dotted" && "$root/bin/new-project" . code >/dev/null 2>&1)
check "dir '.': name from directory (D-20)" "# Dotted 开发与维护记录" \
    "$(head -1 "$T/P001_np/Dotted/docs/project-notes.md")"
(cd "$T/P001_np" && "$root/bin/new-project" Slashed/ code >/dev/null 2>&1)
check "trailing slash: name from directory" "# Slashed" "$(cat "$T/P001_np/Slashed/README.md")"
(cd "$T/P001_np" && "$root/bin/new-project" . code >/dev/null 2>&1)
check "container '.': refused (D-23)" 2 $?
check "container '.': nothing created" no \
    "$([ -e "$T/P001_np/AGENTS.md" ] || [ -e "$T/P001_np/.git" ] && echo yes || echo no)"
"$root/bin/new-project" "$T/P002_new" code >/dev/null 2>&1
check "new container path: refused" 2 $?
check "new container path: not created" no "$([ -e "$T/P002_new" ] && echo yes || echo no)"

# The shared skeleton (D-56): code projects still get it.
check "code: .gitignore from skeleton" "$(cat "$root/skeleton/gitignore")" "$(cat "$d/.gitignore")"
# The general profile: skeleton plus its own template, no git, no setup script.
mkdir -p "$T/P003_gen"
g="$T/P003_gen/g"
"$root/bin/new-project" "$g" general Gen >/dev/null 2>&1
check "general: exit 0" 0 $?
check "general: declaration" "<!-- profile: general -->" "$(head -1 "$g/AGENTS.md")"
check "general: files" ".gitignore AGENTS.md CLAUDE.md README.md docs/decisions.md docs/project-notes.md private-notes.md " \
    "$(cd "$g" && find . \( -type f -o -type l \) | sed 's#^\./##' | LC_ALL=C sort | tr '\n' ' ')"
check "general: decisions from skeleton" "$(cat "$root/skeleton/docs/decisions.md")" "$(cat "$g/docs/decisions.md")"
check "general: title" "# Gen 项目记录" "$(head -1 "$g/docs/project-notes.md")"
check "general: no placeholders left" 0 "$(grep -cE 'HH:MM|<项目名>' "$g/docs/project-notes.md")"
check "general: no git" no "$([ -e "$g/.git" ] && echo yes || echo no)"
check "general: materials created" yes "$([ -d "$T/P003_gen/materials/scratch" ] && echo yes)"
"$root/bin/setup" "$g" >/dev/null 2>&1
check "general: setup exit 0" 0 $?
# A template file overrides the skeleton file at the same path.
fr="$T/fakeroot" && mkdir -p "$fr/bin" "$fr/profiles"
cp "$root/bin/new-project" "$root/bin/setup" "$fr/bin/"
cp -R "$root/skeleton" "$fr/" && cp -R "$root/profiles/general" "$fr/profiles/x"
sed 's/profile: general/profile: x/' "$root/profiles/general/template/AGENTS.md" > "$fr/profiles/x/template/AGENTS.md"
printf '# own decisions\n' > "$fr/profiles/x/template/docs/decisions.md"
"$fr/bin/new-project" "$T/P003_gen/ov" x >/dev/null 2>&1
check "template overrides skeleton: exit 0" 0 $?
check "template overrides skeleton" "# own decisions" "$(cat "$T/P003_gen/ov/docs/decisions.md")"
check "skeleton still adds the rest" yes "$([ -f "$T/P003_gen/ov/.gitignore" ] && echo yes)"

# Profiles and bin/setup (D-41).
"$root/bin/new-project" "$T/P001_np/nop" >/dev/null 2>&1
check "missing profile: usage error" 2 $?
check "missing profile: nothing created" no "$([ -e "$T/P001_np/nop" ] && echo yes || echo no)"
"$root/bin/new-project" "$T/P001_np/unk" nosuch >/dev/null 2>&1
check "unknown profile: exit 2" 2 $?
check "unknown profile: nothing created" no "$([ -e "$T/P001_np/unk" ] && echo yes || echo no)"
# An AGENTS.md that existed without a declaration is kept, and setup does not run.
mkdir -p "$T/P001_np/old" && printf '# Old rules\n' > "$T/P001_np/old/AGENTS.md"
"$root/bin/new-project" "$T/P001_np/old" code >/dev/null 2>&1
check "undeclared AGENTS.md: exit 1" 1 $?
check "undeclared AGENTS.md: kept" "# Old rules" "$(cat "$T/P001_np/old/AGENTS.md")"
check "undeclared AGENTS.md: setup not run" no "$([ -e "$T/P001_np/old/.git" ] && echo yes || echo no)"
mkdir -p "$T/P001_np/mis" && printf '<!-- profile: other -->\n' > "$T/P001_np/mis/AGENTS.md"
"$root/bin/new-project" "$T/P001_np/mis" code >/dev/null 2>&1
check "AGENTS.md declares another profile: exit 1" 1 $?
"$root/bin/setup" >/dev/null 2>&1
check "setup without a directory: usage error" 2 $?
"$root/bin/setup" "$T/P001_np/old" >/dev/null 2>&1
check "setup refuses a project without a profile" 2 $?
mkdir -p "$T/P001_np/bad" && printf '<!-- profile: nosuch -->\n' > "$T/P001_np/bad/AGENTS.md"
"$root/bin/setup" "$T/P001_np/bad" >/dev/null 2>&1
check "setup refuses an unknown declared profile" 2 $?
# As after cloning on a new machine: the hook link is gone, setup brings it back.
before=$(cd "$d" && find . -path ./.git -prune -o -print | LC_ALL=C sort)
rm "$d/.git/hooks/pre-commit"
"$root/bin/setup" "$d" >/dev/null 2>&1
check "setup on an adopted project: exit 0" 0 $?
check "setup restores pre-commit" "$root/git-hooks/pre-commit" "$(readlink "$d/.git/hooks/pre-commit")"
"$root/bin/setup" "$d" >/dev/null 2>&1
check "setup rerun: exit 0" 0 $?
check "setup creates no content files" "$before" \
    "$(cd "$d" && find . -path ./.git -prune -o -print | LC_ALL=C sort)"

# ------------------------------------------------------------ next-container
section "bin/next-container"
nc="$T/nc" && mkdir -p "$nc"
check "empty root: P001" P001 "$("$root/bin/next-container" "$nc")"
mkdir -p "$nc/P001_b" "$nc/P003_a/a" "$nc/notes" "$nc/Other/z"
check "after the highest container" P004 "$("$root/bin/next-container" "$nc")"
mkdir -p "$nc/00_Archieve/P007_old"
check "archived numbers are not reused (D-44)" P008 "$("$root/bin/next-container" "$nc")"
mkdir -p "$nc/00_Archieve/Proj.009_legacy name"
check "old Proj.0NN_ names count, 009 is not octal" P010 "$("$root/bin/next-container" "$nc")"
check "root defaults to the current directory" P010 "$(cd "$nc" && "$root/bin/next-container")"
"$root/bin/next-container" "$T/nosuch" >/dev/null 2>&1
check "missing root: exit 2" 2 $?

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
