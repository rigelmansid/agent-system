# agent-system 状态与待办

本仓库是规则与工具的分发源，不按 code profile 管理，只用本文件和
[decisions.md](decisions.md)（D-18）。仓库说明见 [README.md](../README.md)。

## 进行中

更新：2026-10-06 12:21
- 任务：落实架构“全局部分 + 模块化 profile”（D-40）。D-37–D-39、D-40 记录和第 3 步都已
  提交，未推送
- 停在：第 3 步完成：profiles/code.md、templates/code/、review.md 移进 profiles/code/
  （PROFILE.md、template/、review.md），生成结果与移动前逐字相同
- 本次决策：D-40
- 待用户确认：第 4 步的具体方案；是否推送
- 下一步：第 4 步：/adopt 先选 profile；new-project 拆成“建结构”和可反复运行的 setup；RULE.md
  第 1–3 节只对已接入的项目执行；README 换电脑步骤改为对已接入的项目运行 setup
- 不要重复：hook 已删除，settings.json 里的登记已删（D-39），不要再加回；不要再给 Codex 装
  hook 或技能（D-27）；不要改写 git 历史（D-12）；README 在实施后再写新结构（RULE.md 第 4 节）

## 待办

- [ ] D-40 第 4 步：/adopt 先选 profile；new-project 拆成“建结构”和可反复运行的 setup；RULE.md
  第 1–3 节只对已接入的项目执行；依赖 git 的规则加前提；README 换电脑步骤改为对已接入的项目
  运行 setup（审查 C3）；/pickup、/wrap 在未接入的项目里提示 /adopt
- [ ] 待优化（D-40 Q4）：profile 专用命令和 hook 目前定为链接进项目 `.claude/skills/`、写进
  `.claude/settings.local.json`，链接逻辑等第一个需要的 profile 出现时再写；以后按需求升级（如
  改用 plugin）
- [ ] 新 profile（网页设计、建筑设计、演示等）：用到时和用户一起逐个定义
- [ ] CodaPace（AGENTS.md 第 16、129 行）、meshlink（第 23、150 行）去掉重复的会话流程（D-38）
- 观察：官方建议每个 CLAUDE.md 文件 200 行以内。2026-10-05：RULE.md 160、meshlink AGENTS.md
  196（接近上限）、CodaPace 157；超长提醒由 /pickup 给出（D-39）
- [ ] 可评估：plugin 分发；Stop hook 提醒更新「进行中」。按简洁、高效逐项判断（D-31）
- 已关闭：审查 B3（D-40：blog 未接入，hook 已删除，不再适用）
