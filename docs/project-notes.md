# agent-system 状态与待办

本仓库是规则与命令的分发源，自己也按 `/adopt` 的四个文件记录：本文件、[decisions.md](decisions.md)、
[pitfalls.md](pitfalls.md) 和不入库的 private-notes.md（D-62）。仓库说明见 [README.md](../README.md)。

## Handoff

Updated: 2026-10-21 11:04
- Task: 无，上一个工作单元：D-72（提交信息和 GitHub 文字用英文）发布为 release-17 并推送 main（f3628a7）；
  之后按用户要求删除 dev 分支（D-73），把被切到 dev 的正式版切回 main（坑 7）
- Stopped at: 正式版在 main、origin/main 已同步；D-73、坑 7、本区块已提交到 core（未发布）；CodaPace 已推送 ccb1d79
- Decisions: D-72、D-73
- Waiting on user: 无
- Next: 1. 观察期：在 meshlink、CodaPace 里正常用，只在待办里记摩擦，不改规则 2. 新会话里试 /private（疑似值编号）
  和 /wrap 在编号列表式 pitfalls 里的检索 3. 观察期后一次评估：决策记录方式、plugin 分发、开源定位
- Don't repeat: 不在 ~/agent-system 里直接改或切分支（D-45、坑 7）；不推工作分支和标签（D-48）；不加回 hook（D-39）；
  不给 Codex 装 hook 或技能（D-27）；不改写已推送的历史（D-12）；用户本机的工作文件不进成品（不写 .gitignore、
  不记决策）；推送 GitHub 已改用 gh 的登录（坑 6）

## 待办

- 观察：官方建议每个 CLAUDE.md 文件 200 行以内。2026-10-05：RULE.md 160、meshlink AGENTS.md
  196（接近上限）、CodaPace 157；超长提醒由 /pickup 给出（D-39）
- [ ] 可评估：plugin 分发；Stop hook 提醒更新 Handoff 区块。按简洁、高效逐项判断（D-31）
- 观察（2026-10-12 起 2 到 4 周）：真实项目里用到 agent-system 时卡住或多花的地方记在这里，攒够了一次处理
- [ ] 观察期后评估：决策记录方式（只留现行决策？）、开源定位（中文、固定路径、整份占用 CLAUDE.md）
- 已关闭：审查 B3（D-40：blog 未接入，hook 已删除，不再适用）；审查 C3（D-41：bin/setup，已随 D-62 删除）
