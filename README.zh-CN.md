<div align="center">

# agent-system

**开新对话不用从头解释，结束时下一个会话能接上。**

一套给 Claude Code 用的规则和命令：`/adopt` 接入项目，`/pickup` 接着上次做，`/wrap` 收尾记录，
`/private` 检查有没有写进隐私内容。Codex 也读同一份规则。

[![License: MIT](https://img.shields.io/badge/License-MIT-blue)](LICENSE)
[![Claude Code](https://img.shields.io/badge/Claude%20Code-skills-D97757)](#命令)
[![Shell](https://img.shields.io/badge/shell-bash%203.2%2B-4EAA25?logo=gnubash&logoColor=white)](#安装)

[English](README.md) · **简体中文**

</div>

---

## 安装

**需要**：[Claude Code](https://code.claude.com/docs)、git。Codex 可选。脚本在 macOS
（bash 3.2）上测试过。

1. clone 到 `~/agent-system`。规则和命令里的路径都指向这里，不要换位置。地址在本仓库页面的 Code 按钮里：

   ```sh
   git clone <本仓库地址> ~/agent-system
   ```

2. 建立链接：

   ```sh
   ~/agent-system/bin/install
   ```

   它把 `~/.claude/CLAUDE.md` 和 `~/.codex/AGENTS.md` 链接到 [RULE.md](RULE.md)，把命令链接进
   `~/.claude/skills/`。可以反复运行。已有的同名文件不会被覆盖，会显示 `SKIP`，把那个文件移走再运行。

3. 新开一个 Claude Code 会话，命令就能用了。

**更新**：在 Claude Code 里输入 `/update`。它拉取最新的 main、重建链接，并列出新的决策。

**卸载**：装的全是链接，删掉即可：

```sh
rm ~/.claude/CLAUDE.md ~/.codex/AGENTS.md ~/.claude/skills/{adopt,pickup,private,update,wrap}
```

## 快速上手

1. 在项目文件夹里开 Claude Code，输入 `/adopt`。没有笔记的项目，它建好四个空白文件；已经有笔记的，
   它先给出迁移方案，你同意了再迁。
2. 照常工作。过程中的决策和踩到的坑，agent 会当场记下来。
3. 结束时输入 `/wrap`。它补记漏掉的决策和坑，重写交接区块，汇报这次做了什么。
4. 下次开会话，想接着做就先输入 `/pickup`。它显示上次停在哪、下一步做什么。

## 命令

| 命令 | 作用 |
|---|---|
| `/adopt` | 接入项目：建四个文件，或者把已有笔记迁过来。用 git 的项目还会装 pre-commit、问要拦哪些敏感词。换电脑后在项目里再输入一次，补上不随 clone 走的部分 |
| `/pickup` | 读交接区块、待办和相关决策并显示出来，只读不动手 |
| `/wrap` | 收尾：补记决策和坑，重写交接区块，更新待办，四段汇报 |
| `/private` | 查改过的文件里有没有误写进隐私内容，只报位置、不复述原值，你同意了再换成占位符 |
| `/update` | 从 GitHub 更新 agent-system |

这些命令都只在你输入时才运行。没接入的项目里也能用 `/pickup`、`/wrap`，只是只在对话里汇报，不建文件。

## 它是怎么工作的

- **规则**：[RULE.md](RULE.md) 每个会话都会自动加载，写的是会话怎么开始和结束、决策和坑怎么记、
  哪些操作要先问、怎么验证、隐私怎么保护。原则是简洁、简约、高效。
- **项目里的四个文件**，由 `/adopt` 建：

  | 文件 | 内容 |
  |---|---|
  | `docs/project-notes.md` | 最上面是交接区块（Handoff），下一个会话从这里接上；还有项目概况和待办 |
  | `docs/decisions.md` | 决策 D-n：背景、选项、选择、理由、影响 |
  | `docs/pitfalls.md` | 踩过的坑 坑 n：现象、原因、修法、启示 |
  | `private-notes.md` | 真实地址、用户名、账号，不进 git；入库文件里用占位符 |

- **接入**：项目里有 `docs/project-notes.md`，就算接入了。
- 项目自己的规则写在项目的 `AGENTS.md` 里，可选；`CLAUDE.md` 是指向它的软链接。

## 日常用法

- 开场直接说要做什么。agent 不会自动读项目状态，想接着上次做，先输入 `/pickup`。
- 对话已经很长、又要离开超过 5 分钟时，离开前先 `/wrap`。缓存 5 分钟后过期，回来再收尾，要先把整段
  对话重新写进缓存。
- 提交前用 `/private` 查一遍。用 git 的项目，pre-commit 也会在提交时拦截令牌、私有 IP 和家目录路径。
- 代码审查交给 Codex：在 Codex 里说“按 ~/agent-system/docs/review.md 审查当前未提交的改动”。
- 不要在这些项目里用内置的 `/init`：它会生成或改写 CLAUDE.md，而这里的 CLAUDE.md 通常是指向
  AGENTS.md 的软链接。

## 换电脑

1. 按上面的「安装」装好。
2. 重建本机才有、不随 clone 过来的东西：
   - 每个接入过的 git 项目：clone 后在项目里输入 `/adopt`，补上 pre-commit 和敏感词文件；
   - 各项目的 `private-notes.md`，从旧电脑自己复制过来。
3. 在一个项目里开新会话，输入 `/pickup`，确认能显示交接区块。

## 仓库里有什么

| 文件 | 作用 |
|---|---|
| [RULE.md](RULE.md) | 通用规则 |
| `claude/skills/` | 五个命令 |
| `bin/install` | 建立链接；命令改名或删掉后，指向它的旧链接会被删掉。不装 hook，Codex 只链接 RULE.md |
| `git-hooks/pre-commit` | 提交前拦截令牌与密钥（只报行号）、私有 IP、家目录路径、U+FFFD 和 `.git/privacy-patterns` 里的词。由 `/adopt` 装进 git 项目 |
| [docs/review.md](docs/review.md) | 给 Codex 的代码审查规则 |
| `bin/release`、`.claude/skills/release`、`tests/run.sh` | 维护者发布用的脚本、命令和回归测试，见下一节 |
| [docs/decisions.md](docs/decisions.md)、[docs/pitfalls.md](docs/pitfalls.md) | 本仓库自己的决策和踩过的坑 |

## 维护者：修改本仓库

本节只适用于维护者自己的电脑。GitHub 上只有 main，普通使用者用 `/update` 更新就够了。

- `~/agent-system` 是正式版：链接和规则里的路径都指向它，在这里改了，之后新开的会话就会用上。所以
  改本仓库要在工作副本里做：
  `git -C ~/agent-system worktree add -b core ~/agent-system-dev`，在 `~/agent-system-dev` 里开 Claude（D-45、D-63）。
- 改了 `bin/` 或 `git-hooks/` 后运行 `tests/run.sh`，全部通过再提交；提交后输入 `/release`，它运行
  `bin/release`：测试通过后把 main 快进到工作分支，打标签 `release-N`，列出新决策（影响现有项目的
  标 `!`），再运行 `bin/install`。出了问题运行 `bin/release --rollback`，每次退回一个发布。
- 推送只推 main，工作分支和发布标签留在本地（D-48）；每次推送都要明确同意。
- 本仓库的 `.git/privacy-patterns` 不随 clone 过来，换电脑后自己重建（D-12）。
- 两份 README（`README.md` 英文、`README.zh-CN.md` 中文）同步改。
- 规则的取舍当场记进 [docs/decisions.md](docs/decisions.md)，踩到的坑记进
  [docs/pitfalls.md](docs/pitfalls.md)，提交正文写 `Why: D-n`。新决策在「影响」一项末尾写
  “影响现有项目：是/否（原因）”，不要跨行，`bin/release` 靠它把这类决策标出来。

## 许可证

[MIT](LICENSE)
