# agent-system 状态与待办

本仓库是规则与命令的分发源，自己也按 `/adopt` 的四个文件记录：本文件、[decisions.md](decisions.md)、
[pitfalls.md](pitfalls.md) 和不入库的 private-notes.md（D-62）。仓库说明见 [README.md](../README.md)。

## Handoff

Updated: 2026-10-08 13:55
- Task: 无，上一个工作单元：精简读取与规则（D-49）、/pickup 格式（D-50）、/adopt 补本机部分与
  敏感词（D-51、D-54）、/update（D-52）、/release（D-53），已发布 release-5 并推送 main（225dc76）
- Stopped at: main = origin/main；本区块与 D-50 的确认在 dev 里未提交；两份手册已删除，博客续篇
  已在博客项目里发布（原稿在 P013 materials/posted/agent-system-progress/）
- Decisions: D-49 至 D-54
- Waiting on user: 无
- Next: 1. 新会话里试 /release（在 dev）、/pickup 和 /adopt（在 CodaPace 或 meshlink） 2. 实测
  /new-project 3. 在 meshlink 精简 AGENTS.md（223 行，D-38） 4. 新电脑步骤、Codex 审查的讨论
  （用户说留到最后）
- Don't repeat: 不在 ~/agent-system 里直接改（D-45）；不推 dev 和标签（D-48）；不提方案 A（D-47）；
  不加回 hook（D-39）；不给 Codex 装 hook 或技能（D-27）；不改写已推送的历史（D-12）；RULE.md 1–3 节改 @ 导入、精简旧决策用户暂不做（D-49）

## 待办

- [ ] CodaPace、meshlink：去掉 AGENTS.md 第一行的 profile 声明，把要保留的 code 规则写进各自的
  AGENTS.md，各记一条决策（D-62）。两边都有用户没提交的修改，等用户先提交或同意直接改
- [ ] CodaPace（AGENTS.md 第 16、129 行）、meshlink（第 23、150 行）去掉重复的会话流程（D-38）
- 观察：官方建议每个 CLAUDE.md 文件 200 行以内。2026-10-05：RULE.md 160、meshlink AGENTS.md
  196（接近上限）、CodaPace 157；超长提醒由 /pickup 给出（D-39）
- [ ] 可评估：plugin 分发；Stop hook 提醒更新 Handoff 区块。按简洁、高效逐项判断（D-31）
- 已关闭：审查 B3（D-40：blog 未接入，hook 已删除，不再适用）；审查 C3（D-41：bin/setup，已随 D-62 删除）
