# agent-system 状态与待办

本仓库是规则与工具的分发源，不按 code profile 管理，只用本文件和
[decisions.md](decisions.md)（D-18）。仓库说明见 [README.md](../README.md)。

## 进行中

更新：2026-10-04 02:34
- 任务：无，上一个工作单元：原则改为“简洁、简约、高效”（D-31）；开场不重复读、一次性
  任务不复述不收尾（D-32）
- 停在：已提交并推送
- 本次决策：D-31、D-32
- 待用户确认：无
- 下一步：从待办挑下一项；meshlink「进行中」里还提到已删除的 `/pickup`，下次在 meshlink
  工作时顺手改掉
- 不要重复：不要再给 Codex 装 hook 或技能（D-27，依据是用户的 Codex 用法）；不要改写 git
  历史（D-12）；测试用 `tests/run.sh`，不要在真实项目里试提交

## 待办

- [ ] RULE.md 瘦身，profile 改为 `@` 导入（对比第 5 条，符合“简洁”）
- [ ] meshlink 的 `docs/project-notes.md` 有 612 行，超过约 600 行的上限，需拆分（D-19 发现）
- [ ] 非代码项目的 profile：用户将来可能增加，用到时再做（`materials/` 约定同样适用，留在
  RULE.md）
- [ ] 可评估：plugin 分发（对比第 4 条）；Stop hook 提醒更新「进行中」（对比第 7 条）。原因
  D-27 搁置，D-31 撤掉该原则后按简洁、高效逐项判断
