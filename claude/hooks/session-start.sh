#!/bin/bash
# Claude Code SessionStart hook: print the project's work state so a new,
# cleared or compacted session starts with it in context. stdout becomes
# context. Read-only, always exits 0, and prints nothing outside a project.
# Compatible with macOS bash 3.2.

dir=${CLAUDE_PROJECT_DIR:-$PWD}
cd "$dir" 2>/dev/null || exit 0

notes=docs/project-notes.md
decisions=docs/decisions.md
in_git=0
git rev-parse --is-inside-work-tree >/dev/null 2>&1 && in_git=1

[ -f "$notes" ] || [ -f AGENTS.md ] || [ "$in_git" = 1 ] || exit 0

echo "[session-start] 项目状态快照（由 ~/agent-system/claude/hooks/session-start.sh 注入）"

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

echo
echo "按 ~/agent-system/RULE.md 第 1.1 节：动手前先向用户复述状态。"
exit 0
