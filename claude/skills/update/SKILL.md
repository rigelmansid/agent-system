---
name: update
description: Update the installed agent-system from GitHub: pull main into ~/agent-system, relink commands with bin/install, and list the new decisions, marking those that affect existing projects. Stops on local changes or for the developer, whose live copy is updated by bin/release. Runs only when the user types /update.
disable-model-invocation: true
---

# /update：更新 agent-system

把 `~/agent-system` 更新到 GitHub 上的 main，并补好新命令的链接（D-52）。只动 `~/agent-system`，
不改任何项目，不推送。下面的命令照写，`L=~/agent-system`。

1. **开发者不用本命令**：`git -C $L worktree list --porcelain | grep -c '^worktree '` 大于 1，
   说明本机有 dev 工作副本，正式版由 `bin/release` 更新（D-45）。告诉用户：其他电脑推送过的
   改动，在 `~/agent-system-dev` 里 `git pull origin main` 后运行 `bin/release`。然后停下。
2. **检查能不能更新**，有一项不满足就说明原因并停下，不丢弃、不暂存任何东西：
   - `git -C $L status --porcelain` 有输出：有本地修改，`git pull` 可能冲突。列出文件，
     建议把自己的规则写进项目的 `AGENTS.md`，而不是改 `~/agent-system`。
   - `git -C $L symbolic-ref -q --short HEAD` 不是 `main`：说明当前检出的是什么，请用户先
     `git -C ~/agent-system checkout main`。
3. **更新**：记下 `old=$(git -C $L rev-parse HEAD)`，运行 `git -C $L pull --ff-only origin main`。
   失败（网络、权限、历史分叉）就报告输出并停下。之后 `git -C $L rev-parse HEAD` 等于 old 时，
   回答“已是最新”并停下。
4. **补链接**：运行 `$L/bin/install`。有 `SKIP` 时说明哪个文件挡住了、怎么处理（移走后再运行
   `/update` 或 `bin/install`）。
5. **整理变化**，只读 diff，不读整个文件（D-49）：
   - `git -C $L log --oneline old..HEAD`；
   - `git -C $L diff old HEAD -- docs/decisions.md`：以 `+### D-` 开头、且不在 `-### D-` 里的是
     新决策（只改了标题的旧决策不算）；新增行里写着“影响现有项目：是”的标 `!`。

**输出**，写法同 `/pickup`（加粗标题、分行、每条一行放得下）：

```markdown
**Updated**：old 前 7 位 → 新的前 7 位，N 个提交

**New decisions**
- ! D-n 标题（影响现有项目：括号里的原因）
- D-m 标题

**Next**
- 新开的会话才用上新规则和命令
- 标 ! 的决策要检查的项目或要做的事
```

没有新决策时写 `**New decisions**：无`；有 `!` 时，Next 写出它的原因里说的要做的事。
