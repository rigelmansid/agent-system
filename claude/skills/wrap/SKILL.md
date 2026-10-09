---
name: wrap
description: Wrap up a unit of work by recording missing decisions and pitfalls, rewriting the Handoff block in docs/project-notes.md and updating the todo list, then giving a four-part report. Runs only when the user types /wrap.
disable-model-invocation: true
---

# /wrap：收尾

只在用户输入本命令时收尾（RULE.md 1.4）。不提交、不推送，除非用户在这次调用里明确要求。

只读要改的部分，不把整个文件读进来（D-49）：project-notes 等文档先 `grep -n '^## ' <文件>`
得到各节的行号，只读要改的那一节；只追加的文件（如 `log.md`）只读末尾几行；已有决策只看
`grep -n '^### D-' docs/decisions.md` 的标题列表。

0. 项目没有接入（没有 `docs/project-notes.md`，D-62）时（D-43）：只在对话里给出四段汇报和
   本次的决定，不建 `docs/decisions.md`、project-notes 等文件；项目的 AGENTS.md 指向了自己的
   笔记文件、里面有 Handoff（或「进行中」）区块时，问用户要不要更新它，同意后按第 3 步的格式
   写进去。然后停下。
1. **整理本次**：列出改动的文件（用 git 的项目对照 `git status`）、运行过的验证及结果、
   用户的决定、你做的不显而易见的选择。
2. **补齐决策和坑**：达到 RULE.md 第 2 节门槛的决策、这次踩到的坑，对照标题列表确认
   `docs/decisions.md`、`docs/pitfalls.md` 里已有条目，漏记的按第 2 节的格式追加；解决了的坑改
   标题里的状态。不确定是不是用户决定的，写“agent 选择”并在汇报里请用户确认。
3. **重写 Handoff 区块**：整体覆盖，不追加，15 行以内，用当前时间：

   ```markdown
   ## Handoff

   Updated: YYYY-MM-DD HH:MM
   - Task: 当前在做什么（没有就写“无，上一个工作单元：……”）
   - Stopped at: 做到哪一步
   - Decisions: D-n、D-m
   - Waiting on user: ……
   - Next: 1. …… 2. ……
   - Don't repeat: 已做过、不该再做的操作
   ```

   Next 具体到新会话能直接执行；Don't repeat 写再做会出问题或浪费时间的事。旧的「进行中」
   区块（中文字段）改成这个格式（D-42）。
4. **其余记录**：project-notes 的待办（完成的删掉，新发现的加上，没解决的坑写一行“解决 坑 n”）
   和其他要更新的节（如当前状态）；项目 `AGENTS.md` 另有要求的照做。
5. **检查**：按 RULE.md 第 6、7 节检查改过的文件（U+FFFD、相对链接、没有写入
   `private-notes.md` 的内容）。

**轮次**（D-61）：收尾时上下文最大，每多一轮工具调用都要把整段对话重发一遍，所以第 1–5 步
合并成最多 5 轮，读和改不按文件拆开：

1. 一次读齐（同一轮并行）：`git status --short`；要改的文档的 `grep -n '^## '`；
   `grep -n '^### D-' docs/decisions.md | tail -5`、`grep -n '^### 坑' docs/pitfalls.md | tail -5`；
   要追加的文件 `tail -n 3`；Handoff 在
   project-notes 最上方，直接读前 40 行，不用先 grep。
2. 按行号读其他要改的节（同一轮并行；没有就跳过）。
3. 一次改完（同一轮并行）：加在文件末尾的内容（新决策、新的坑）用 `cat >> <文件> <<'EOF'`
   追加，不用先 Read；改文件中间的（Handoff、待办、坑的状态）用 Edit。
4. 用一条命令做完第 5 步的检查；不为确认而重读刚改过的文件，编辑失败时工具会报错。
5. 汇报。

**输出**：四段汇报 **做了什么 / 怎么验证的 / 没做什么 / 下次从哪开始**，每段一到三行；加一行
“本次决策：D-n 标题……”（需要用户确认的标出），最后一行列出本次修改的文档文件。
