# agent-system 状态与待办

本仓库是规则与工具的分发源，不按 code profile 管理，只用本文件和
[decisions.md](decisions.md)（D-18）。仓库说明见 [README.md](../README.md)。

## 进行中

更新：2026-10-04 01:48
- 任务：无，上一个工作单元：定下原则“简洁、不过度自动化”，Codex 只链接 RULE.md（D-27）；
  hook 退回纯文本，保留 LC_ALL=C 修复（D-28）
- 停在：D-26 至 D-28 已合成一个提交；本机已删 `~/.agents/` 和 `~/.codex/hooks.json`；
  5 个提交未推送
- 本次决策：D-26、D-27、D-28
- 待用户确认：是否推送
- 下一步：1. 用户明确同意后推送 2. 按 D-27 原则从待办挑下一项
- 不要重复：不要再给 Codex 装 hook 或技能（D-27）；不要改写 git 历史（D-12）；测试用
  `tests/run.sh`，不要在真实项目里试提交

## 待办

- [ ] RULE.md 瘦身，profile 改为 `@` 导入（对比第 5 条，符合“简洁”）
- [ ] 规则写明 auto memory 与仓库文档的分工、多会话只由一个会话写 decisions.md（对比第 6 条）
- [ ] meshlink 的 `docs/project-notes.md` 有 612 行，超过约 600 行的上限，需拆分（D-19 发现）
- [ ] 非代码项目的 profile：先确认是否还需要（D-27：Codex 的非代码任务是一次性的）
- 搁置（D-27，用到再说）：plugin 分发（对比第 4 条）；Stop hook 提醒更新「进行中」（对比
  第 7 条）
