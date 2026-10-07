---
name: pickup
description: Show the project's current state by reading the 进行中 block and todo list in docs/project-notes.md, git status and the related decisions. Read-only; starts no work. Works at the start of a session or midway through. Runs only when the user types /pickup.
disable-model-invocation: true
---

# /pickup：查看项目状态

开场不自动读项目状态，用户输入本命令时才读（D-39）。只读：不修改文件，不开始任何任务。
输出后停下，等用户指示（D-33）。

0. 项目 `AGENTS.md` 开头没有 profile 声明时：说明本项目还没接入，可以用 `/adopt`，然后停下
   （D-40）。
1. 读 `docs/project-notes.md` 的「进行中」与待办。
2. 项目用 git 时，运行 `git status --short` 和 `git log --oneline -5`。
3. 「进行中」引用的决策编号，到 `docs/decisions.md` 读对应条目的标题和选择。
4. 对话进行到一半时，对照本会话做过的事，列出还没写进「进行中」的进展。
5. 项目用 git 时，检查「进行中」是否过时（D-19）：取它的更新时间 T，
   `git rev-list --count --since="T" HEAD` 减去
   `git rev-list --count --since="T" HEAD -- docs/project-notes.md`，大于 0 说明之后有没更新它
   的提交。它与 git 状态矛盾时也指出。
6. `AGENTS.md` 超过 200 行、`docs/project-notes.md` 超过 600 行时提醒（D-19）。

输出不超过 10 行：

```text
进行中（更新于 ……）：任务……；停在……
相关决策：D-n 标题（一句话），……
未提交的修改：无 | N 个文件，属于 / 不属于进行中的任务
本会话新进展：……（开场调用时省略；有未记录的进展时建议 /wrap）
等你确认：……（没有写“无”）
下一步：……
提醒：……（过时、超长；没有就省略）
```
