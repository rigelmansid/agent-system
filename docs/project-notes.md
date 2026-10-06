# agent-system 状态与待办

本仓库是规则与工具的分发源，不按 code profile 管理，只用本文件和
[decisions.md](decisions.md)（D-18）。仓库说明见 [README.md](../README.md)。

## 进行中

更新：2026-10-06 11:56
- 任务：按 2026-10-05 全面审查的结果修改；D-37（审查修复）、D-38（A1）、D-39（开场不读
  状态、去掉 hook、去掉“继续”）已提交，未推送
- 停在：用户定下架构“全局部分 + 模块化 profile”和 Q1–Q5，下一步把它记成决策
- 本次决策：D-37、D-38、D-39
- 待用户确认：是否推送
- 下一步：1. 记录架构决策 2. 整理 profiles/code/ 模块 3. /adopt 选 profile、拆出 setup
  4. CodaPace、meshlink 的 AGENTS.md 去掉重复的会话流程，在各自项目里做（D-38、D-36）
- 不要重复：hook 已删除，本机 settings.json 里的登记已删（D-39），不要再加回；不要再给 Codex
  装 hook 或技能（D-27）；不要改写 git 历史（D-12）；测试用 `tests/run.sh`

## 待办

- [ ] 审查 B3、C3：等用户决定 agent-system 是全局生效还是按项目接入
- [ ] CodaPace（AGENTS.md 第 16、129 行）、meshlink（第 23、150 行）去掉重复的会话流程（D-38）
- 观察：官方建议每个 CLAUDE.md 文件 200 行以内。2026-10-05：RULE.md 160、meshlink AGENTS.md
  196（接近上限）、CodaPace 157；超长提醒改由 /pickup 给出（D-39）
- [ ] 非代码项目的 profile：用户将来可能增加，用到时再做
- [ ] 可评估：plugin 分发；Stop hook 提醒更新「进行中」。按简洁、高效逐项判断（D-31）
