---
name: private
description: Check the files changed in this project for private content written by mistake - values kept in private-notes.md, tokens and keys, private IPs, home paths, words in .git/privacy-patterns. Reports file and line without repeating the values, then asks whether to replace them with placeholders. Runs only when the user types /private.
disable-model-invocation: true
---

# /private：检查改过的文件里有没有误写进隐私内容

先只读检查、汇报，停下；用户同意后才脱敏（RULE.md 第 6 节，D-62）。不提交。

## 一、查哪些文件

- git 仓库：没提交的改动，即 `git status --short` 列出的修改、暂存和新文件；改过的文件看
  `git diff HEAD` 里新增的行，新文件看全文。
- 不是 git 仓库：本次会话改过的文件。
- 都没有就说明并停下。`private-notes.md` 本身不查。

## 二、查什么

1. `private-notes.md` 里记着的真实值（主机、用户名、账号、路径等），逐个在要查的内容里找。
2. 令牌和密钥：常见格式（`sk-`、`ghp_`、`github_pat_`、`xox[abp]-`、`AKIA`、
   `-----BEGIN … PRIVATE KEY-----` 等）、URL 里的 `用户:密码@`、`TOKEN=`、`SECRET=`、`PASSWORD=`、
   `API_KEY=` 这类赋值。
3. 私有 IP：`10.`、`172.16.`–`172.31.`、`192.168.`、`100.64.`–`100.127.` 开头的地址。
4. 家目录路径：`/Users/<名字>/`、`/home/<名字>/`、`C:\Users\<名字>\`。
5. `$(git rev-parse --git-common-dir)/privacy-patterns` 里的词（有这个文件时）。

已经是占位符的（`<host>`、`<user>`、`<token>`）不算。

## 三、汇报

每条写 `文件:行号` 和类型（如“私有 IP”“private-notes 里的主机名”），不复述原值（RULE.md 第 6 节）；
没有发现就写“无”。然后问要不要脱敏，停下等回答。

## 四、脱敏（用户同意后）

1. 原值换成占位符：主机 `<host>`、用户名 `<user>`、家目录 `<home>`、IP `<ip>`、令牌和密钥 `<token>`；
   同一个值各处用同一个占位符。
2. 不在 `private-notes.md` 里的真实值（令牌和密钥除外）记进去，写明对应哪个占位符；没有这个文件就建，
   git 仓库同时确认 `.gitignore` 忽略它。令牌和密钥不写进任何文件，提醒用户更换写进过文件的那个。
3. 按第二节再查一遍，汇报改了哪些文件、还剩几处。
