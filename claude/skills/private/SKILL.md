---
name: private
description: Check the files changed in this project for private content written by mistake - values kept in private-notes.md, tokens and keys, private IPs, home paths, words in .git/privacy-patterns - plus suspected private details outside those lists. Reports listed hits by file and line without repeating the values, lists suspected values with numbers for the user to pick, then replaces the agreed ones with placeholders. Runs only when the user types /private.
disable-model-invocation: true
---

# /private：检查改过的文件里有没有误写进隐私内容

先只读检查、汇报，停下；用户同意后才脱敏（RULE.md 第 6 节，agent-system D-62）。不提交。

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
4. 家目录路径：`/Users/<名字>/`、`/home/<名字>/`。
5. `$(git rev-parse --git-common-dir)/privacy-patterns` 里的词（有这个文件时）。
6. 疑似隐私：不在上面 1–5 里、但可能是真实信息的值，由你判断：人名、邮箱、手机号、非公开的
   域名和主机名、公司和客户名、内部项目代号、账号 ID、Windows 用户目录 `C:\Users\<名字>\` 里的名字。
   公开的不算（`github.com`、`example.com`、常见库名、本项目自己的名字、`Public` 这类系统目录）。
   令牌和密钥归第 2 项，不放进这一类。

已经是占位符的（`<host>`、`<user>`、`<token>`）不算。

## 三、汇报

分两部分，没有发现的部分写“无”：

1. **名单上的**（第二节 1–5）：每条写 `文件:行号` 和类型（如“私有 IP”“private-notes 里的主机名”），
   不复述原值（RULE.md 第 6 节）。
2. **疑似的**（第二节 6）：按值编号，同一个值出现多处也只编一个号，写原值、类型和所有位置，如
   `3. <原值>（疑似人名）a.md:12、b.md:40`。这类要用户判断，所以写原值。

然后问：名单上的要不要脱敏；疑似的哪些要脱敏，回编号即可。停下等回答。

## 四、脱敏（用户同意后）

1. 原值换成占位符：主机 `<host>`、用户名 `<user>`、家目录 `<home>`、IP `<ip>`、令牌和密钥 `<token>`，
   疑似值按类型用 `<name>`、`<email>`、`<org>` 等；同一个值各处用同一个占位符。
2. 不在 `private-notes.md` 里的真实值（令牌和密钥除外）记进去，写明对应哪个占位符；没有这个文件就建，
   git 仓库同时确认 `.gitignore` 忽略它。令牌和密钥不写进任何文件，提醒用户更换写进过文件的那个。
3. 选中的疑似值加进 `$(git rev-parse --git-common-dir)/privacy-patterns`，以后 pre-commit 和 /private
   都按名单拦。每个值一行扩展正则，特殊字符加 `\`（如 `.` 写成 `\.`）；值的开头和结尾都是字母或数字时加上
   边界，写成 `(^|[^A-Za-z0-9_])值([^A-Za-z0-9_]|$)`，免得 `Li` 拦下 `Linux`。已有同样的行就不加；文件不存在
   就建，第一行写注释 `# 每行一个扩展正则，pre-commit 命中即拦截`。写完运行 `grep -E -f <该文件> /dev/null`，
   退出码是 2 说明有无效正则，改好再继续。不是 git 仓库就跳过这一步。
4. 按第二节再查一遍，汇报改了哪些文件、加了几条敏感词、还剩几处。
