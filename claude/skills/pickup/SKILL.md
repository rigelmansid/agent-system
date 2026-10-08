---
name: pickup
description: Show the project's current state by reading the Handoff block and todo list in docs/project-notes.md, git status and the related decisions. Read-only; starts no work. Works at the start of a session or midway through. Runs only when the user types /pickup.
disable-model-invocation: true
---

# /pickup：查看项目状态

开场不自动读项目状态，用户输入本命令时才读（D-39）。只读：不修改文件，不开始任何任务。
输出后停下，等用户指示（D-33）。

只读用得上的部分，不把整个文件读进来（D-49）：先 `grep -n '^## ' <文件>` 得到各节的行号，
再只读需要的那几节（Read 的 offset/limit 或 `sed -n 'a,bp'`）；决策用
`grep -nE '^### (D-n|D-m) ' docs/decisions.md` 定位，只读这几条。行数用 `wc -l` 得到。

0. 项目没有接入（`AGENTS.md` 开头没有 profile 声明）时，只做只读报告，不建任何文件（D-43）：
   是 git 仓库就报告 git 状态和最近 5 个提交；项目的 AGENTS.md 指向了自己的笔记文件、里面有
   Handoff（或「进行中」）区块时只读这个区块；对话进行到一半时列出本会话的进展。最后一句说明
   本项目没有接入：想接着以前的对话用 `/resume`，要持久记录状态用 `/adopt`（D-47）。然后停下。
1. 读 `docs/project-notes.md` 的 Handoff 区块与待办这两节（旧项目里这个区块叫「进行中」，字段
   是中文，照样读，D-42）。
2. 项目用 git 时，运行 `git status --short` 和 `git log --oneline -5`。
3. Handoff 引用的决策编号，到 `docs/decisions.md` 只读这几条的标题和选择。
4. 对话进行到一半时，对照本会话做过的事，列出还没写进 Handoff 的进展。
5. 项目用 git 时，检查 Handoff 是否过时（D-19）：取它的 Updated 时间 T（旧格式是「更新：」），
   `git rev-list --count --since="T" HEAD` 减去
   `git rev-list --count --since="T" HEAD -- docs/project-notes.md`，大于 0 说明之后有没更新它
   的提交。它与 git 状态矛盾时也指出。
6. `AGENTS.md` 超过 200 行、`docs/project-notes.md` 超过 600 行时提醒（D-19）。

输出不超过 10 行：

```text
Handoff（Updated ……）：Task ……；Stopped at ……
Decisions：D-n 标题（一句话），……
Uncommitted：无 | N 个文件，属于 / 不属于 Handoff 里的任务
New this session：……（开场调用时省略；有未记录的进展时建议 /wrap）
Waiting on user：……（没有写“无”）
Next：……
Warnings：……（过时、超长；没有就省略）
```
