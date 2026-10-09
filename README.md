# agent-system

我和 AI agent（Claude Code 为主，Codex 用于代码审查和一次性的非代码任务）协作的规则与命令。
私有仓库，远端是 GitHub 私有仓库（D-3，地址用 `git remote -v` 查看），不公开。

原则：简洁、简约、高效（D-31）。

## 组成

| 部分 | 文件 | 作用 |
|---|---|---|
| 通用规则 | [RULE.md](RULE.md) | 会话协议、决策与踩坑记录、Handoff 区块、执行安全、验证、隐私、写文档。`~/.claude/CLAUDE.md`、`~/.codex/AGENTS.md` 链接到它，每个会话自动加载；第 1–3 节只在接入的项目执行 |
| 命令 | `claude/skills/` | `/adopt`、`/pickup`、`/wrap`、`/private`、`/update`，见下表 |
| 项目自己的 | 项目里的四个文件，加可选的 `AGENTS.md` | `docs/project-notes.md`、`docs/decisions.md`、`docs/pitfalls.md`、`private-notes.md` 由 `/adopt` 建；有 `docs/project-notes.md` 就算接入（D-62） |

## 命令

| 命令 | 作用 |
|---|---|
| `/adopt` | 接入：没有笔记时建空白的四个文件；已有笔记时先分析、给出迁移方案，同意后再迁。用 git 的项目还会装 pre-commit、问要拦哪些敏感词。换电脑后在项目里再输入一次，补上不随 clone 走的部分 |
| `/pickup` | 读 Handoff、待办和相关决策并显示，只读不动手（D-33、D-39） |
| `/wrap` | 收尾：补记决策和坑，重写 Handoff，更新待办，给出四段汇报（D-61） |
| `/private` | 查改过的文件里有没有误写进隐私内容，只报位置、不复述原值，问过再换成占位符 |
| `/update` | 纯用户从 GitHub 更新 agent-system，列出新决策（D-52） |

都只在你输入时运行（D-35）。没接入的项目里 `/pickup`、`/wrap` 也能用：只在对话里汇报，不建文件（D-43）。

## 日常用法

- 接入：在项目文件夹里开 Claude，输入 `/adopt`。
- 开场：直接说要做什么；想接着上次做，先输入 `/pickup`。
- 过程中：决策当场记进 `docs/decisions.md`（D-n），踩到的坑记进 `docs/pitfalls.md`（坑 n）。
- 结束：`/wrap`。对话已经很长、又要离开超过 5 分钟时，离开前先 `/wrap`：缓存 5 分钟后过期，回来再做
  要先把整段对话重新写进缓存（D-61）。
- 提交前：`/private` 查一遍改过的文件。用 git 的项目，pre-commit 也会在提交时拦截。
- 审查：在 Codex 里说“按 ~/agent-system/docs/review.md 审查当前未提交的改动”。
- 更新：纯用户输入 `/update`；开发者见「修改本仓库」。
- 不要在这些项目里用内置的 `/init`：它会生成或改写 CLAUDE.md，而这里的 CLAUDE.md 通常是指向
  AGENTS.md 的软链接。

## 工具

| 文件 | 作用 |
|---|---|
| `bin/install` | 建立全局链接和命令链接；可重复运行，已有的非链接文件不覆盖；命令改名或删掉后，指向它的旧链接会被删掉。不装 hook（D-39）。Codex 只链接 RULE.md（D-27） |
| `bin/release [--rollback]` | 在工作副本 `~/agent-system-dev` 里运行，把它当前所在的分支发布到正式版 `~/agent-system`：测试通过后快进 main，打标签 `release-N`，列出新决策（影响现有项目的标 `!`），再运行 `bin/install`；`--rollback` 退回上一个发布。不推送（D-45） |
| `.claude/skills/release` | 本仓库自己的 `/release`，只在本仓库里出现：检查未提交的改动、运行 `bin/release`、汇报新决策，再问要不要推送 main（D-53） |
| `git-hooks/pre-commit` | 拦截令牌与密钥（只报行号，D-11、D-37）、私有 IP、home 路径、U+FFFD 和 `.git/privacy-patterns` 中的词（worktree 共用这份文件）；该文件有无效正则时也拦截（D-14）。由 `/adopt` 装进 git 项目 |
| `tests/run.sh` | 上面这些脚本的回归测试，在临时目录和假 HOME 中运行（D-17） |
| [docs/review.md](docs/review.md) | 给 Codex 的代码审查规则 |

## 在新电脑上安装

1. 装好 Claude Code 和 Codex，配置好各自的登录或 API（不在本仓库）。
2. 登录 GitHub 后 clone 到 `~/agent-system`（D-4）。
3. 运行 `~/agent-system/bin/install`。出现 `SKIP` 时把那个文件移走再运行。开发者再建工作副本：
   `git -C ~/agent-system worktree add -b core ~/agent-system-dev`（D-45、D-63）。
4. 重建本机才有的东西（都不随 clone 过来）：
   - 本仓库的 `.git/privacy-patterns`（D-12）；
   - 每个接入过的 git 项目：clone 后在项目里输入 `/adopt`，补上 pre-commit 和敏感词文件；
   - 各项目的 `private-notes.md`，从旧电脑自行同步。
5. 运行 `tests/run.sh`，再在一个项目里开新会话，输入 `/pickup`，确认能显示 Handoff 区块。

## 修改本仓库

`~/agent-system` 是正式版：链接和规则里的路径都指向它，在这里改了，之后新开的会话就会用上。
所以改本仓库要在工作副本 `~/agent-system-dev`（同一仓库的 git worktree）里开 Claude（D-45）。
改了 `bin/` 或 `git-hooks/` 后运行 `tests/run.sh`，全部通过再提交；提交后输入 `/release` 发布。
发布后出了问题，运行 `bin/release --rollback` 退回上一个发布（每运行一次退一个），修好再发布。
推送只推 main，工作分支和发布标签留在本地（D-48）；每次推送都要用户明确同意。
新决策在「影响」一项末尾写“影响现有项目：是/否（原因）”，“影响现有项目：是”不要跨行，
`bin/release` 靠它把这类决策标出来。
规则的取舍当场记进 [docs/decisions.md](docs/decisions.md)（D-n），踩到的坑记进
[docs/pitfalls.md](docs/pitfalls.md)（坑 n），提交正文写 `Why: D-n`。本仓库自己也按 `/adopt` 的
四个文件记录（D-62）。
