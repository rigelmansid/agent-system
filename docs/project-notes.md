# agent-system 状态与待办

本仓库是规则与工具的分发源，不按 code profile 管理，只用本文件和
[decisions.md](decisions.md)（D-18）。仓库说明见 [README.md](../README.md)。

## 进行中

更新：2026-10-03 23:07
- 任务：无，上一个工作单元：CodaPace 补成 code 项目（CodaPace D-1，本仓库 D-21）；
  本仓库 D-5 至 D-9 已精简（D-22）；new-project 加容器检查（D-23）
- 停在：本仓库 D-21 至 D-23 已合成一个提交；本仓库共 3 个提交未推送；CodaPace 仓库
  是否提交以该项目的「进行中」为准
- 本次决策：D-21、D-22、D-23
- 待用户确认：本仓库是否推送到远端
- 下一步：1. 用户明确同意后推送 2. 从待办挑下一项
- 不要重复：CodaPace 的拆分已完成，不要再跑一次；D-11 的误报扫描已用 /usr/bin/grep 重跑过；
  不要改写 git 历史（D-12）；测试用 `tests/run.sh`，不要在真实项目里试提交

## 待办

- [ ] meshlink 的 `docs/project-notes.md` 有 612 行，超过约 600 行的上限，需拆分（D-19 发现）
- [ ] 非代码项目的 profile（`profiles/<名称>.md` + `templates/<名称>/`，new-project 加
  `--profile`）；动手前先问用户项目类型、是否用 git
- 搁置：模板 AGENTS.md 用 `@` 导入 profile（D-19，发现 profile 被漏读时再考虑）
