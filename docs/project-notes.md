# agent-system 状态与待办

本仓库是规则与工具的分发源，不按 code profile 管理，只用本文件和
[decisions.md](decisions.md)（D-18）。仓库说明见 [README.md](../README.md)。

## 进行中

更新：2026-10-03 22:46
- 任务：为 CodaPace 补结构做准备：修 new-project 在 `.` 下默认名为 `.` 的问题（D-20）
- 停在：修复已提交；审查修复 9 条（8784c32）与本修复都未推送
- 本次决策：D-11 至 D-20
- 待用户确认：是否推送到远端
- 下一步：1. 到 CodaPace 目录开会话，运行 `new-project .`，再提出迁移方案给用户确认
  2. 用户明确同意后推送
- 不要重复：D-11 的误报扫描已用 /usr/bin/grep 重跑过；不要改写 git 历史（D-12）；
  测试用 `tests/run.sh`，不要在真实项目里试提交

## 待办

- [ ] CodaPace 用 `bin/new-project` 补成标准结构，整理 `docs/project-notes.zh-CN.md`（D-15）
- [ ] meshlink 的 `docs/project-notes.md` 有 612 行，超过约 600 行的上限，需拆分（D-19 发现）
- [ ] 非代码项目的 profile（`profiles/<名称>.md` + `templates/<名称>/`，new-project 加
  `--profile`）；动手前先问用户项目类型、是否用 git
- 搁置：模板 AGENTS.md 用 `@` 导入 profile（D-19，发现 profile 被漏读时再考虑）
