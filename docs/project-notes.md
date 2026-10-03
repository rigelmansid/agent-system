# agent-system 状态与待办

本仓库是规则与工具的分发源，不按 code profile 管理，只用本文件和
[decisions.md](decisions.md)（D-18）。仓库说明见 [README.md](../README.md)。

## 进行中

更新：2026-10-04 02:05
- 任务：无，上一个工作单元：提高决策记录门槛、写明 auto memory 只记个人偏好（D-29）；
  去掉 /pickup（D-30）
- 停在：D-29、D-30 与 wrap 精简已合成一个提交；共 6 个提交未推送
- 本次决策：D-29、D-30
- 待用户确认：是否推送
- 下一步：1. 用户明确同意后推送 2. 按 D-27 原则从待办挑下一项
- 不要重复：不要再给 Codex 装 hook 或技能（D-27）；不要改写 git 历史（D-12）；测试用
  `tests/run.sh`，不要在真实项目里试提交

## 待办

- [ ] RULE.md 瘦身，profile 改为 `@` 导入（对比第 5 条，符合“简洁”）
- [ ] meshlink 的 `docs/project-notes.md` 有 612 行，超过约 600 行的上限，需拆分（D-19 发现）
- [ ] 非代码项目的 profile：用户将来可能增加，用到时再做（`materials/` 约定同样适用，留在
  RULE.md）- 搁置（D-27，用到再说）：plugin 分发（对比第 4 条）；Stop hook 提醒更新「进行中」（对比
  第 7 条）
