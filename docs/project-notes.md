# agent-system 状态与待办

本仓库是规则与工具的分发源，不按 code profile 管理，只用本文件和
[decisions.md](decisions.md)（D-18）。仓库说明见 [README.md](../README.md)。

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

- [ ] 待优化（D-40 Q4）：profile 专用命令和 hook 目前定为链接进项目 `.claude/skills/`、写进
  `.claude/settings.local.json`，链接逻辑等第一个需要的 profile 出现时再写；以后按需求升级（如
  改用 plugin）
- [ ] 第二个 profile 先做通用最小 profile（D-55），之后写“profile 必须有什么”的说明，再做
  `/new-profile` 引导用户建 `my-` 开头的自建 profile；领域 profile（网页设计、建筑设计等）用到时再定义
- [ ] CodaPace（AGENTS.md 第 16、129 行）、meshlink（第 23、150 行）去掉重复的会话流程（D-38）
- 观察：官方建议每个 CLAUDE.md 文件 200 行以内。2026-10-05：RULE.md 160、meshlink AGENTS.md
  196（接近上限）、CodaPace 157；超长提醒由 /pickup 给出（D-39）
- [ ] 可评估：plugin 分发；Stop hook 提醒更新 Handoff 区块。按简洁、高效逐项判断（D-31）
- 已关闭：审查 B3（D-40：blog 未接入，hook 已删除，不再适用）；审查 C3（D-41：bin/setup）；本仓库里 /pickup、/wrap
  走简化模式：用户决定维持原逻辑（D-47）
