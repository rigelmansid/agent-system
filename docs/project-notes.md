# agent-system 状态与待办

本仓库是规则与工具的分发源，不按 code profile 管理，只用本文件和
[decisions.md](decisions.md)（D-18）。仓库说明见 [README.md](../README.md)。

## Handoff

Updated: 2026-10-07 23:26
- Task: 无，上一个工作单元：撤回方案 A、保留 /resume 提示（D-47），已发布为 release-3 并推送
- Stopped at: main 已推送（main = origin/main = 9d202d8），dev 和标签按用户要求不推（D-48）；
  D-48、README 一句、本区块在 dev 里未提交
- Decisions: D-47、D-48
- Waiting on user: 无
- Next: 1. 用户实测 /new-project（在 VBCD 根目录输入 /new-project <名称>） 2. CodaPace、meshlink
  的 AGENTS.md 去掉重复的会话流程（D-38、D-36） 3. 新电脑步骤、Codex 审查的讨论（用户说留到最后）
- Don't repeat: 不要在 ~/agent-system 里直接改，改 ~/agent-system-dev（D-45）；本仓库的
  /pickup、/wrap 走简化模式是用户的决定，不要再提方案 A（D-47）；不要推 dev 和标签（D-48）；
  hook 已删除（D-39），不要再加回；不要再给 Codex 装 hook 或技能（D-27）；不要改写 git 历史
  （D-12）；共用骨架等第二个 profile 出现再抽（D-41）

## 待办

- [ ] 第二个 profile 出现时：把所有 profile 共用的骨架（AGENTS.md、project-notes、decisions）
  从 code 的 template/ 抽成一份公共骨架（D-41）
- [ ] 待优化（D-40 Q4）：profile 专用命令和 hook 目前定为链接进项目 `.claude/skills/`、写进
  `.claude/settings.local.json`，链接逻辑等第一个需要的 profile 出现时再写；以后按需求升级（如
  改用 plugin）
- [ ] 新 profile（网页设计、建筑设计、演示等）：用到时和用户一起逐个定义
- [ ] CodaPace（AGENTS.md 第 16、129 行）、meshlink（第 23、150 行）去掉重复的会话流程（D-38）
- 观察：官方建议每个 CLAUDE.md 文件 200 行以内。2026-10-05：RULE.md 160、meshlink AGENTS.md
  196（接近上限）、CodaPace 157；超长提醒由 /pickup 给出（D-39）
- [ ] 可评估：plugin 分发；Stop hook 提醒更新 Handoff 区块。按简洁、高效逐项判断（D-31）
- 已关闭：审查 B3（D-40：blog 未接入，hook 已删除，不再适用）；审查 C3（D-41：bin/setup）；本仓库里 /pickup、/wrap
  走简化模式：用户决定维持原逻辑（D-47）
