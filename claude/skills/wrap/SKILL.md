---
name: wrap
description: Wrap up a unit of work by recording missing decisions, rewriting the Handoff block in docs/project-notes.md, updating the log and todo list per the project's rules, then giving a four-part report. Runs only when the user types /wrap.
disable-model-invocation: true
---

# /wrap：收尾

按 `~/agent-system/RULE.md` 第 1.4 节执行；项目声明了 profile 时，同时按该 profile 的
「收尾时的文档更新」一节。不提交、不推送，除非用户在这次调用里明确要求。

0. 项目没有接入（`AGENTS.md` 开头没有 profile 声明）、也没有 `docs/project-notes.md` 时
   （D-43、D-46）：只在对话里给出四段汇报和本次的决定，不建 `docs/decisions.md`、project-notes
   等文件；项目的 AGENTS.md 指向了自己的笔记文件、里面有 Handoff（或「进行中」）区块时，问用户
   要不要更新它，同意后按 RULE.md 第 3 节的格式写进去。然后停下。有 `docs/project-notes.md`
   的项目即使没有声明，也照下面的步骤做，第 4 步按项目自己的约定。
1. **整理本次**：列出改动的文件（用 git 的项目对照 `git status`）、运行过的验证及结果、
   用户的决定、你做的不显而易见的选择。
2. **补齐决策**：达到 RULE.md 第 2 节门槛的，确认 `docs/decisions.md` 里已有条目，漏记的
   补上；不确定是不是用户决定的，写“agent 选择”并在汇报里请用户确认。
3. **重写 Handoff 区块**：按 RULE.md 第 3 节重写，用当前时间。Next 具体到新会话能直接执行；
   Don't repeat 写再做会出问题或浪费时间的事。旧的「进行中」区块（中文字段）改成这个格式
   （D-42）。
4. **其余记录**：按项目 `AGENTS.md` 和 profile 更新（code profile：`log.md`、待办、当前
   状态、新的坑）。
5. **检查**：按 RULE.md 第 6、7 节检查改过的文件（U+FFFD、相对链接、没有写入
   `private-notes.md` 的内容）。

**输出**：RULE.md 1.4 的四段汇报，加一行“本次决策：D-n 标题……”（需要用户确认的标出），
最后列出本次修改的文档文件。
