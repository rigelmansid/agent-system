---
name: adopt
description: Choose a profile and bring a project folder into the agent-system structure. Checks first and proposes a migration plan, then carries it out only after the user confirms. In a project that has already adopted a profile, as after cloning it on a new machine, it restores the machine-local parts with bin/setup instead. Runs only when the user types /adopt (or /adopt <profile>).
disable-model-invocation: true
---

# /adopt：选定 profile，把项目接入 agent-system

先选 profile，再检查、出方案，停下等用户确认；确认后再执行（D-34、D-40、D-41）。全程遵守
RULE.md 第 4 节：不碰未提交的修改，不覆盖已有文件，删除或替换用户文件前先问。

## 零、已经接入时：只补本机部分

项目 `AGENTS.md` 开头已有 profile 声明时（例如换电脑后 clone 下来的项目），不重复接入，也不
出方案，直接运行 `~/agent-system/bin/setup .`（D-51）：它只补 `../materials/` 和该 profile 的
本机设置（code：git、pre-commit），不碰项目内容，可以反复运行。汇报它的输出，处理其中的
WARNING，再按下面的「敏感词文件」补 `.git/privacy-patterns`，并提醒用户自己补回 setup 补不了
的：`private-notes.md` 的内容和 `../materials/` 里的资料。然后停下。

**敏感词文件**（profile 装了 pre-commit 时，code 是；D-54）：
`$(git rev-parse --git-common-dir)/privacy-patterns` 不存在时，问用户这个项目要拦哪些真实的
用户名、主机名、公司名等。用户给了，每个写成一行扩展正则（`.` 写成 `\.`），第一行写注释
`# 每行一个扩展正则，pre-commit 命中即拦截`；写完运行 `grep -E -f <该文件> /dev/null`，退出码
是 2 说明有无效正则，改好再继续。用户说不需要就跳过。这些词只写进这个文件，不写进任何入库
文件、提交信息或汇报。文件已存在时不改，只说明已有几条。

## 一、选 profile

列出 `~/agent-system/profiles/*/PROFILE.md` 的第一行（名称和一句话说明），请用户选一个；用户
输入了 `/adopt <名称>` 就直接用它。一个项目只选一个。

## 二、检查（只读）

1. **位置**：项目目录的上一层应是 `P0NN_名称/` 容器（D-10）。不是时停下：移动要先退出本
   会话，并按 D-10 迁移按路径保存的数据，不在本会话里移动。
2. **工作区**：是 git 仓库并且 `git status --short` 有未提交的修改时停下，请用户先决定提交
   还是暂存。
3. **盘点**：已有的 AGENTS.md（开头有没有 profile 声明）、CLAUDE.md（是文件还是软链接）、
   README、`.gitignore`、笔记和文档；找出相当于 project-notes 的旧笔记。读所选 profile 的
   `PROFILE.md` 和 `template/`，看它要求什么结构。

## 三、方案（输出后停下）

- 旧笔记改名为 `docs/project-notes.md`（git 仓库里用 `git mv`，D-21）。
- 已有 AGENTS.md 但开头没有声明：在第一行加上 `<!-- profile: <名称> -->`（要用户同意）。
- 运行 `~/agent-system/bin/new-project . <名称>`：只补缺的骨架文件，然后运行 setup（建
  `../materials/`，以及该 profile 自己的本机设置，code 是 git 和 pre-commit）。
- 内容怎么拆，按所选 profile 的 `PROFILE.md`（code：命令、不变量、验证方式进 AGENTS.md；
  做过的决定进 decisions；踩过的坑进 pitfalls；历史进 log；大文档留在 `docs/` 下独立成文）。
- 已有 CLAUDE.md 是普通文件时：内容并入 AGENTS.md 后，换成指向它的软链接（要用户同意）。
- 已有 AGENTS.md 里和 RULE.md 重复的内容（开场读状态、收尾、记录决策这类流程）列出来，
  建议删掉：AGENTS.md 只写本项目特有的规则（D-38）。
- 预计的 WARNING 和处理方法（常见：旧 `.gitignore` 缺 `private-notes.md`）。

## 四、执行（用户确认后）

1. 按方案加声明、改名、运行 new-project，处理输出里的 WARNING。
2. 迁移内容，写好 Handoff 区块。
3. 隐私扫描：profile 装了 pre-commit 时，先按第零节的「敏感词文件」补好 `.git/privacy-patterns`，
   再用 pre-commit 的规则扫全部入库文件；公开仓库按该 profile 的
   发布规则（code：`profiles/code/publish.md`）。
4. 验证：项目原有的测试仍通过；`docs/project-notes.md` 最上方有 Handoff 区块，新会话里
   输入 `/pickup` 能显示它。
5. 在本项目 `docs/decisions.md` 记一条接入决策。不提交，等用户说。
