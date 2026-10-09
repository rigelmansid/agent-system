---
name: adopt
description: Bring a project folder into agent-system by creating the four files that /pickup, /wrap and /private use. With no notes yet it creates them blank; when the folder already has notes it analyzes them, proposes how to move their content into the four files, and migrates only after the user agrees. In git projects it also links the pre-commit hook and the privacy patterns file. Runs only when the user types /adopt.
disable-model-invocation: true
---

# /adopt：接入 agent-system

接入就是建好下面四个文件；有了 `docs/project-notes.md` 就算接入（RULE.md 开头，D-62）。全程遵守
RULE.md 第 4 节：不碰未提交的修改，不覆盖已有文件，删除或替换用户文件前先问。不提交。

| 文件 | 用途 | 空白时 |
|---|---|---|
| `docs/project-notes.md` | Handoff、项目概况、待办；`/pickup` 读，`/wrap` 写 | 照 `templates/project-notes.md` |
| `docs/decisions.md` | 决策 D-n，只追加（RULE.md 第 2 节） | 照 `templates/decisions.md` |
| `docs/pitfalls.md` | 踩过的坑 坑 n，只追加（RULE.md 第 2 节） | 照 `templates/pitfalls.md` |
| `private-notes.md` | 真实地址、用户名、账号等；`/private` 用它比对和脱敏 | 一行：`# 私密信息：不入库、不外传，入库文件里用占位符（<host>、<user>）` |

模板在 `~/agent-system/claude/skills/adopt/templates/`：`<项目名>` 换成项目文件夹名，
`YYYY-MM-DD HH:MM` 换成当前时间。

## 一、检查（只读）

1. **已经接入**（有 `docs/project-notes.md`，例如换电脑后 clone 下来的项目）：不重复接入，只建
   缺的另外三个文件，再做第四节，然后汇报并停下。
2. **工作区**：是 git 仓库并且 `git status --short` 有未提交的修改时停下，请用户先决定提交还是暂存。
3. **盘点笔记**：NOTES、TODO、CHANGELOG、`docs/` 下的 md、CLAUDE.md 和 AGENTS.md 里写的状态与
   决策、旧的「进行中」区块。先看标题和开头几行，判断每份讲的是什么。README 是给使用者看的，不动。
   没有笔记走第二节，有就走第三节。

## 二、没有笔记：建空白文件

按上表建四个文件，再做第四节。汇报建了什么，然后请用户说这个项目要做什么，填进项目概况。

## 三、有笔记：出迁移方案，用户同意后再迁

方案按“哪一段 → 哪个文件”列出，输出后停下：

- 现状、待办、下一步 → project-notes（Handoff 按 RULE.md 第 3 节写）
- 做过的决定和原因 → decisions，按 RULE.md 第 2 节的格式，从 D-1 起编号
- 踩过的坑、没解决的问题 → pitfalls（没解决的同时在待办里写一行“解决 坑 n”）
- 真实地址、用户名、账号 → private-notes，原处换成 `<host>`、`<user>` 这类占位符；令牌和密钥
  不抄过去，提醒用户更换
- 其他内容（架构说明、使用指南等）留在原处，project-notes 里写一句指向它
- 原文件默认保留；整份并入时，git 仓库里先用 `git mv` 改名再改内容（D-21）；要删原文件先问

用户同意后：按方案建文件、迁移内容，再做第四节；检查改过的文件没有 U+FFFD、相对链接有效；在
`docs/decisions.md` 记一条接入决策。汇报迁了哪些、哪些留在原处。

## 四、git 项目的本机部分

不是 git 仓库就跳过。这几样不随 clone 走，换电脑后在项目里输入 `/adopt` 补上（D-51、D-54）：

1. `.gitignore` 没有 `private-notes.md` 时加上一行（没有 `.gitignore` 就建）。
2. `$(git rev-parse --git-path hooks)/pre-commit` 不存在时，链接到 `~/agent-system/git-hooks/pre-commit`；
   已有别的钩子不动，告诉用户。
3. **敏感词文件**：`$(git rev-parse --git-common-dir)/privacy-patterns` 不存在时，问用户这个项目要拦
   哪些真实的用户名、主机名、公司名等。用户给了，每个写成一行扩展正则（`.` 写成 `\.`），第一行写
   注释 `# 每行一个扩展正则，pre-commit 命中即拦截`；写完运行 `grep -E -f <该文件> /dev/null`，退出码
   是 2 说明有无效正则，改好再继续。用户说不需要就跳过。这些词只写进这个文件，不写进任何入库文件、
   提交信息或汇报。文件已存在时不改，只说明已有几条。
