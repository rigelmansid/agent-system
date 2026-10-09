---
name: release
description: Developer only, in the agent-system dev worktree. Release the committed working branch to the live copy with bin/release, report the new decisions, then offer to push main. /release rollback switches the live copy back one release. Runs only when the user types /release.
disable-model-invocation: true
---

# /release：把工作分支发布到正式版（只给开发者）

本命令只在 agent-system 仓库里出现（项目命令，不由 `bin/install` 安装，D-53）。它只运行
`bin/release`，不自己用 git 合并 main、打标签（D-45）。

1. **确认是开发者的 dev 工作副本**：`git worktree list --porcelain | grep -c '^worktree '` 大于 1，
   并且当前目录不是正式版（`git rev-parse --show-toplevel` 不是 `~/agent-system`）。否则说明
   本命令只给开发者在 `~/agent-system-dev` 里用，纯用户更新用 `/update`，然后停下。
2. **参数是 `rollback` 时**：运行 `bin/release --rollback`，汇报正式版退回到哪个发布，提醒在
   dev 里修好后再 `/release`。然后停下。
3. **未提交的改动**：`git status --short` 有输出时列出来，问用户要不要先提交，停下等回答；不自己
   提交（RULE.md 1.2）。用户同意后，按决策分开提交：英文祈使句主题，空一行，正文分条，最后
   `Why: D-n`。
4. **发布**：运行 `bin/release`。失败就贴出输出（测试失败时什么都没发布），然后停下。
5. **推送**：问用户要不要推送 main。只有用户在这次对话里明确同意，才运行
   `git -C ~/agent-system push origin main`；工作分支和标签不推（D-48）。

**输出**，写法同 `/pickup`：

```markdown
**Released**：release-N，自 release-(N−1) 起 M 个提交

**New decisions**
- ! D-n 标题
- D-m 标题

**Next**
- 标 ! 的决策要检查的项目
- 推送 main 吗？（main 比 origin 多 K 个提交）
```

没有新决策时写 `**New decisions**：无`。K 用 `git -C ~/agent-system rev-list --count origin/main..main`。
