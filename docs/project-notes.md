# agent-system 状态与待办

本仓库是规则与工具的分发源，不按 code profile 管理，只用本文件和
[decisions.md](decisions.md)（D-18）。仓库说明见 [README.md](../README.md)。

## 进行中

更新：2026-10-04 03:39
- 任务：无，上一个工作单元：恢复 /pickup（D-33）；新增 /adopt（D-34）；收尾只由 /wrap
  触发（D-35）；一个项目只由一个会话写文档（D-36）；命令描述改英文；README 提醒别用 `/init`
- 停在：三个命令已由用户在新会话实测通过（2026-10-04）；已提交并推送
- 本次决策：D-33、D-34、D-35、D-36
- 待用户确认：无
- 下一步：从待办挑下一项
- 不要重复：不要再给 Codex 装 hook 或技能（D-27，依据是用户的 Codex 用法）；不要改写 git
  历史（D-12）；测试用 `tests/run.sh`，不要在真实项目里试提交

## 待办

- 观察：官方建议是每个 CLAUDE.md 文件 200 行以内（不是合计）。现状 RULE.md 163、meshlink
  AGENTS.md 194、CodaPace 157，都在范围内；超过 200 行时 hook 会提醒（D-19），到时再精简。
- [ ] meshlink 的 `docs/project-notes.md` 有 612 行，超过约 600 行的上限，需拆分（D-19 发现）
- [ ] 非代码项目的 profile：用户将来可能增加，用到时再做（`materials/` 约定同样适用，留在
  RULE.md）
- [ ] 可评估：plugin 分发（对比第 4 条）；Stop hook 提醒更新「进行中」（对比第 7 条）。原因
  D-27 搁置，D-31 撤掉该原则后按简洁、高效逐项判断
