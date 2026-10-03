---
name: adopt
description: Bring an existing project folder into the agent-system structure. Checks first and proposes a migration plan, then carries it out only after the user confirms. Runs only when the user types /adopt.
disable-model-invocation: true
---

# /adopt：把已有项目补成标准结构

分两段：先检查、出方案，停下等用户确认；确认后再执行（D-34）。全程遵守 RULE.md 第 4 节：
不碰未提交的修改，不覆盖已有文件，删除或替换用户文件前先问。

## 一、检查（只读）

1. **位置**：项目目录的上一层应是 `P0NN_名称/` 容器（D-10）。不是时停下：移动要先退出本
   会话，并按 D-10 迁移按路径保存的数据，不在本会话里移动。
2. **工作区**：`git status --short` 有未提交的修改时停下，请用户先决定提交还是暂存。不是
   git 仓库时说明 new-project 会 `git init`。
3. **盘点**：已有的 AGENTS.md、CLAUDE.md（是文件还是软链接）、README、`.gitignore`、
   `docs/` 下的笔记和文档；找出相当于 project-notes 的旧笔记。

## 二、方案（输出后停下）

- 旧笔记先 `git mv` 为 `docs/project-notes.md`，再运行 `~/agent-system/bin/new-project .`，
  它只补缺的文件（D-21）。
- 内容怎么拆：命令、不变量、验证方式进 AGENTS.md；做过的决定进 decisions；踩过的坑进
  pitfalls；历史进 log；大文档留在 `docs/` 下独立成文。
- 已有 CLAUDE.md 是普通文件时：内容并入 AGENTS.md 后，换成指向它的软链接（要用户同意）。
- 预计的 WARNING 和处理方法（常见：旧 `.gitignore` 缺 `private-notes.md`）。

## 三、执行（用户确认后）

1. 按方案改名、运行 new-project，处理输出里的 WARNING。
2. 迁移内容，写好「进行中」。
3. 隐私扫描：用 pre-commit 的规则扫全部入库文件；公开仓库按 profiles/code.md 第 6 节。
4. 验证：项目原有的测试仍通过；
   `CLAUDE_PROJECT_DIR=$PWD ~/agent-system/claude/hooks/session-start.sh` 的输出里有「进行中」。
5. 在本项目 `docs/decisions.md` 记一条迁移决策。不提交，等用户说。
