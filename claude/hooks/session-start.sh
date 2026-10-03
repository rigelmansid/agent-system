#!/bin/bash
# Claude Code SessionStart hook: print the project's work state so a new,
# cleared or compacted session starts with it in context. stdout becomes
# context. Read-only and always exits 0. An agent project (AGENTS.md or
# docs/project-notes.md) gets the full snapshot and the restate instruction;
# a plain git repository gets only the git state (D-15); anything else gets
# nothing. Compatible with macOS bash 3.2.

dir=${CLAUDE_PROJECT_DIR:-$PWD}
block=
cd "$dir" 2>/dev/null || exit 0

notes=docs/project-notes.md
decisions=docs/decisions.md
in_git=0
git rev-parse --is-inside-work-tree >/dev/null 2>&1 && in_git=1

is_project=0
{ [ -f "$notes" ] || [ -f AGENTS.md ]; } && is_project=1
[ "$is_project" = 1 ] || [ "$in_git" = 1 ] || exit 0

if [ "$is_project" = 1 ]; then
    echo "[session-start] 项目状态快照（由 ~/agent-system/claude/hooks/session-start.sh 注入）"
else
    echo "[session-start] git 状态（由 ~/agent-system/claude/hooks/session-start.sh 注入；"
    echo "这里没有 AGENTS.md 或 docs/project-notes.md，不按 agent 项目处理）"
fi

if [ -f "$notes" ]; then
    block=$(awk '
        /^## 进行中/ { on = 1; print; next }
        on && /^## / { exit }
        on { print }
    ' "$notes" | head -n 25)
    if [ -n "$block" ]; then
        echo
        echo "$block"
    else
        echo
        echo "（${notes} 没有「进行中」区块）"
    fi
fi

# Warnings (D-19). 进行中 is stale when commits made after its timestamp did
# not touch the notes file (a commit that also updates the notes is fine).
# Size limits follow profiles/code.md section 1.
warn=
stamp=$(printf '%s\n' "${block:-}" | sed -nE 's/^更新：([0-9]{4}-[0-9]{2}-[0-9]{2} [0-9]{2}:[0-9]{2}).*/\1/p' | head -n 1)
if [ "$in_git" = 1 ] && [ -n "$stamp" ]; then
    all=$(git rev-list --count --since="$stamp" HEAD 2>/dev/null || echo 0)
    touched=$(git rev-list --count --since="$stamp" HEAD -- "$notes" 2>/dev/null || echo 0)
    if [ "$all" -gt "$touched" ]; then
        warn="${warn}- 「进行中」（${stamp}）之后有 $((all - touched)) 个提交没有更新它，可能已过时
"
    fi
fi
check_size() {  # check_size <file> <max lines>
    [ -f "$1" ] || return 0
    local n
    n=$(wc -l < "$1" | tr -d ' ')
    [ "$n" -gt "$2" ] && warn="${warn}- $1 有 $n 行，超过约 $2 行的上限，考虑拆分
"
    return 0
}
check_size AGENTS.md 200
check_size "$notes" 600
if [ -n "$warn" ]; then
    echo
    echo "提醒："
    printf '%s' "$warn"
fi

if [ -f "$decisions" ]; then
    recent=$(grep -E '^### D-[0-9]+' "$decisions" | tail -n 3)
    if [ -n "$recent" ]; then
        echo
        echo "最近的决策（${decisions}）："
        echo "$recent"
    fi
fi

if [ "$in_git" = 1 ]; then
    echo
    echo "git 分支：$(git branch --show-current 2>/dev/null)"
    changes=$(git status --short 2>/dev/null)
    if [ -n "$changes" ]; then
        count=$(printf '%s\n' "$changes" | wc -l | tr -d ' ')
        echo "未提交的修改（${count} 个文件，最多显示 15 个）："
        printf '%s\n' "$changes" | head -n 15
    else
        echo "工作区干净"
    fi
    echo "最近的提交："
    git log --oneline -5 2>/dev/null
fi

if [ "$is_project" = 1 ]; then
    echo
    echo "按 ~/agent-system/RULE.md 第 1.1 节：动手前先向用户复述状态。"
fi
exit 0
