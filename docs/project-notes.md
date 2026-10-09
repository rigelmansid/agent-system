# agent-system 状态与待办

本仓库是规则与命令的分发源，自己也按 `/adopt` 的四个文件记录：本文件、[decisions.md](decisions.md)、
[pitfalls.md](pitfalls.md) 和不入库的 private-notes.md（D-62）。仓库说明见 [README.md](../README.md)。

## Handoff

Updated: 2026-10-09 13:50
- Task: 无，上一个工作单元：收敛为四个命令（D-62），发布为 release-9 并已推送 main（7739718）；CodaPace、
  meshlink 去掉 profile 声明（各自的 D-6、D-35）；dev 分支留作存档（D-63）
- Stopped at: 正式版 = core = origin/main；本区块、D-63 和分支名的说明在工作副本里未提交；两个项目已提交
  （CodaPace d3adb82、e9e52a8，meshlink 3a42b44、9f1d11e：去掉声明和重复的会话流程），没有推送
- Decisions: D-62、D-63
- Waiting on user: 无
- Next: 1. 新会话里试 /adopt（空文件夹、已有笔记的文件夹各一次）、/private、/pickup、/wrap 2. 下次 /release 时
  一起提交本区块和 D-63 3. meshlink 精简 AGENTS.md（D-38） 4. 新电脑步骤、Codex 审查的讨论（留到最后）
- Don't repeat: 不在 ~/agent-system 里直接改（D-45）；不推工作分支和标签（D-48）；不动 dev 分支（存档，D-63）；
  不加回 hook（D-39）；不给 Codex 装 hook 或技能（D-27）；不改写已推送的历史（D-12）；@ 导入和精简旧决策
  暂不做（D-49）；不再提 profile、容器编号和按需建文件（D-62），不再提其他命令改点选（D-60）

## 待办

- 观察：官方建议每个 CLAUDE.md 文件 200 行以内。2026-10-05：RULE.md 160、meshlink AGENTS.md
  196（接近上限）、CodaPace 157；超长提醒由 /pickup 给出（D-39）
- [ ] 可评估：plugin 分发；Stop hook 提醒更新 Handoff 区块。按简洁、高效逐项判断（D-31）
- 已关闭：审查 B3（D-40：blog 未接入，hook 已删除，不再适用）；审查 C3（D-41：bin/setup，已随 D-62 删除）
