---
name: pickup
description: Show the project's current state by re-reading the 进行中 block and todo list in docs/project-notes.md, git status and the related decisions. Read-only; starts no work. Works at the start of a session or midway through. Runs only when the user types /pickup.
disable-model-invocation: true
---

# /pickup：查看项目状态

只读：不修改文件，不开始任何任务。输出后停下，等用户指示（D-33）。

1. 重新读 `docs/project-notes.md` 的「进行中」与待办，以磁盘上的为准，不用开场注入的那份。
   没有这个文件时如实说明，只报告 git 状态。
2. 运行 `git status --short` 和 `git log --oneline -5`。
3. 「进行中」引用的决策编号，到 `docs/decisions.md` 读对应条目的标题和选择。
4. 对话进行到一半时，对照本会话做过的事，列出还没写进「进行中」的进展。
5. 「进行中」过时（更新时间早于最近的提交、或与 git 状态矛盾）时如实指出。

输出不超过 10 行：

```text
进行中（更新于 ……）：任务……；停在……
相关决策：D-n 标题（一句话），……
未提交的修改：无 | N 个文件，属于 / 不属于进行中的任务
本会话新进展：……（开场调用时省略；有未记录的进展时建议 /wrap）
等你确认：……（没有写“无”）
下一步：……
```
