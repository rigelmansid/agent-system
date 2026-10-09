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

0. 项目没有接入（没有 `docs/project-notes.md`，D-62）时，只做只读报告，不建任何文件（D-43）：
   是 git 仓库就报告 git 状态和最近 5 个提交；项目的 AGENTS.md 指向了自己的笔记文件、里面有
   Handoff（或「进行中」）区块时只读这个区块；对话进行到一半时列出本会话的进展。按下面的写法
   输出 **Git**（状态、最近 5 个提交各一行）、**Handoff**、**New this session** 三项，最后一句
   说明本项目没有接入：想接着以前的对话用 `/resume`，要持久记录状态用 `/adopt`（D-62）。然后停下。
1. 读 `docs/project-notes.md` 的 Handoff 区块与待办这两节（旧项目里这个区块叫「进行中」，字段
   是中文，照样读，D-42）。
2. 项目用 git 时，运行 `git status --short` 和 `git log --oneline -5`。最近的提交只用来判断
   过时和矛盾，不单独列出。
3. Handoff 引用的决策编号，到 `docs/decisions.md` 只读这几条的标题和选择。
4. 对话进行到一半时，对照本会话做过的事，列出还没写进 Handoff 的进展。
5. 项目用 git 时，检查 Handoff 是否过时（D-19）：取它的 Updated 时间 T（旧格式是「更新：」），
   `git rev-list --count --since="T" HEAD` 减去
   `git rev-list --count --since="T" HEAD -- docs/project-notes.md`，大于 0 说明之后有没更新它
   的提交。它与 git 状态矛盾时也指出。
6. `AGENTS.md` 超过 200 行、`docs/project-notes.md` 超过 600 行时提醒（D-19）。

## 输出

直接写成 Markdown，不放进代码块，否则加粗和列表不显示（D-50）：

```markdown
**Handoff** · Updated ……
- Task：……
- Stopped at：……

**Decisions**
- D-n ……

**Uncommitted**：N 个文件，属于 Handoff 里的任务
- 路径

**New this session**
- ……

**Waiting on user**
- ……

**Next**
1. ……

**Todo**：未完成 N 条
- ……

**Warnings**
- ……
```

- 每项一个加粗标题，多条内容分行列出，不用分号串在一行。每项最多 5 条，Todo 最多 3 条，
  多出的写“另有 N 条”。
- 每条一行放得下，约 30 个汉字：删解释和背景，不删命令、路径、参数和编号。
- Decisions 每条写编号和选了什么，标题可以缩短，不改原意。
- Handoff 过时（第 5 步）时，在 Updated 后面写“可能过时：之后有 N 个提交没更新它”。Warnings
  只放超长提醒和与 git 状态的矛盾。
- Uncommitted：工作区干净时写 `**Uncommitted**：无`；既有属于、也有不属于 Handoff 任务的文件时，
  分成“属于 Handoff 里的任务”“不属于”两组列出；不用 git 的项目省略这一项。
- Waiting on user 没有内容时写 `**Waiting on user**：无`。其他没有内容的项整项省略；
  New this session 只在对话中途调用时出现，有未记录的进展时最后建议 `/wrap`。
