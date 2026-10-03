# agent-system 状态与待办

本仓库是规则与工具的分发源，不按 code profile 管理，只用本文件和
[decisions.md](decisions.md)（D-18）。仓库说明见 [README.md](../README.md)。

## 进行中

更新：2026-10-04 00:58
- 任务：按与最新做法的对比逐项改进；第 1 条（修正 Codex 说法，D-24）、第 2 条（接上
  Codex 的 hook 与技能，D-25）已合成一个提交
- 停在：本机已真实运行 install；Codex 里信任 hook、`$pickup` 可见性尚未实测；4 个提交未推送
- 本次决策：D-24、D-25
- 待用户确认：Codex 实测结果；是否推送
- 下一步：1. 用户在 Codex `/hooks` 信任 hook，说“继续”看是否复述，输入 `$` 看技能
  2. 从待办挑对比的第 3–7 条
- 不要重复：install 已在本机真实运行过；不要改写 git 历史（D-12）；测试用 `tests/run.sh`，
  不要在真实项目里试提交

## 待办

- [ ] 对比改进第 3 条：hook 改为 JSON 输出，用 `systemMessage` 给用户看一行摘要、`sessionTitle`
- [ ] 对比改进第 4 条：改为 plugin 分发（技能、hook、`bin/new-project`）；RULE.md 仍用软链接，
  plugin 不加载 CLAUDE.md
- [ ] 对比改进第 5 条：RULE.md 瘦身，Claude 一侧用 `@` 导入或 `~/.claude/rules/` 加载 profile
- [ ] 对比改进第 6 条：规则写明 auto memory 与仓库文档的分工、多会话只由一个会话写 decisions.md
- [ ] 对比改进第 7 条：评估 Stop hook 提醒更新「进行中」（防止反复阻止）
- [ ] meshlink 的 `docs/project-notes.md` 有 612 行，超过约 600 行的上限，需拆分（D-19 发现）
- [ ] 非代码项目的 profile（`profiles/<名称>.md` + `templates/<名称>/`，new-project 加
  `--profile`）；动手前先问用户项目类型、是否用 git
- 搁置：模板 AGENTS.md 用 `@` 导入 profile（D-19；对比第 5 条会重新评估）
