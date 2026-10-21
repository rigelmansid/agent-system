# 踩过的坑

踩到时当场追加，编号递增（坑 1、坑 2……），旧条目不改编号。格式见 [RULE.md](../RULE.md) 第 2 节。
还没解决的，在 [project-notes.md](project-notes.md) 的待办里写一行“解决 坑 n”；解决后只改标题里的状态。

### 坑 1 拆分提交时用 `--cacheinfo 100644` 丢了可执行位（2026-10-08，已解决 2026-10-08）

- 现象：拆开暂存的中间提交里，`tests/run.sh` 变成不可执行，直接运行报 permission denied。
- 原因：`git update-index --cacheinfo` 的权限写死成了 100644。
- 修法：暂存前先用 `git ls-files -s` 看原来的权限，按原权限写（脚本是 100755）。
- 启示：按中间版本拆提交时，每个文件的权限和内容都要照原样给。

### 坑 2 用 `update-index --chmod` 修权限，会把工作区的整份内容一起暂存（2026-10-08，已解决 2026-10-08）

- 现象：只想补回可执行位，结果中间提交里混进了后面才有的测试，单独检出时 11 个测试失败。
- 原因：`--chmod` 会按工作区里的文件更新暂存区，不只改权限。
- 修法：用 `--cacheinfo 100755,<中间版本的 blob>,<路径>` 一次给定权限和内容。
- 启示：拆提交后，在临时 worktree 里检出每个中间提交跑一遍测试。

### 坑 3 写中文时偶尔写进替换字符 U+FFFD（2026-10-08，已解决 2026-10-08）

- 现象：新写的 SKILL.md 里，“时”变成了三个 U+FFFD。
- 原因：生成中文时偶发的编码错误，写入工具不报错。
- 修法：按 RULE.md 第 7 节用码点替换，替换前先确认只有这一处。
- 启示：每次写完中文都跑一遍 `grep -nI $'\xef\xbf\xbd'`，不能省。

### 坑 4 bin/release 要求正式版工作区干净，未跟踪的文件也算（2026-10-09，已解决 2026-10-09）

- 现象：删掉 `profiles/` 后，正式版里用户测试留下的 `profiles/.trash/` 会变成未跟踪文件，之后
  发布和回滚都会被拒绝。
- 原因：`bin/release` 用 `git status --porcelain` 判断是否干净：被忽略的文件不算，未跟踪的算。
- 修法：`.gitignore` 继续忽略已停用的 `/profiles/`（D-62）。
- 启示：删除整个目录前，先看正式版里这个目录下有没有被忽略的本机文件。

### 坑 5 发布时会话中断，不知道发布做完没有（2026-10-09，已解决 2026-10-09）

- 现象：运行 `bin/release` 时会话结束，工具结果没有记录下来，看不出发布停在哪一步。
- 原因：`bin/release` 一次做完测试、快进 main、打标签和 `bin/install`，中断后从对话里看不到进度。
- 修法：先查正式版的 HEAD、最新的 release 标签和工作区是否干净；确认已发布后只补跑 `bin/install`（可反复运行），没有重跑发布。
- 启示：命令中断后先查状态再决定，不直接重跑会打标签的命令。

### 坑 6 推送报 Invalid username or token：钥匙串里的 GitHub 凭据失效（2026-10-12，已解决 2026-10-12）

- 现象：`git push origin main` 报 `Invalid username or token. Password authentication is not supported`；前一天同样的推送成功。
- 原因：git 用系统 gitconfig 里的 osxkeychain，钥匙串里保存的 GitHub 凭据失效了；gh 的登录仍然有效，有 `repo` 权限。
- 修法：这次用 `git -c credential.helper= -c 'credential.helper=!gh auth git-credential' push origin main` 单次改用 gh 的凭据，没改 git 配置。之后用户运行了 `gh auth setup-git`，git 推送 GitHub 改用 gh 的登录（写在 `~/.gitconfig`），`push --dry-run` 认证通过。
- 启示：推送认证失败先查 `gh auth status`，用单次 `-c` 推送；改全局 git 配置要先问用户。
