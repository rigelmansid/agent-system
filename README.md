# agent-system

我和 AI agent（Claude Code 为主，Codex 用于审查和非代码任务）协作的规则与工具。
私有仓库，远端是 GitHub 私有仓库 `rigelmansid/agent-system`（D-3），不公开。

## 三层规则

| 层 | 文件 | 生效方式 |
|---|---|---|
| 通用 | [RULE.md](RULE.md)：会话协议、决策记录、「进行中」、执行安全、验证、隐私、写文档 | `~/.claude/CLAUDE.md`、`~/.codex/AGENTS.md` 链接到它，每个会话自动加载 |
| 项目类型 | [profiles/code.md](profiles/code.md)：文件结构、内容归属、git、发布 | 项目 `AGENTS.md` 开头写 `<!-- profile: code -->` |
| 项目 | 项目自己的 `AGENTS.md` 与 `docs/` | 项目目录 |

审查规则：[review.md](review.md)，给 Codex 用。

## 工具

| 文件 | 作用 |
|---|---|
| `bin/install` | 建立上面的全局链接和技能链接，检查 SessionStart hook；可重复运行 |
| `bin/new-project <dir> [名称]` | 按 `templates/code/` 建项目或补齐缺的文件，装 pre-commit hook；不覆盖已有文件 |
| `claude/hooks/session-start.sh` | 新会话、`/clear`、压缩后注入「进行中」、最近决策与 git 状态 |
| `claude/skills/pickup`、`claude/skills/wrap` | `/pickup` 开场复述，`/wrap` 收尾记录 |
| `git-hooks/pre-commit` | 拦截私有 IP、home 路径、U+FFFD 和 `.git/privacy-patterns` 中的词 |

## 日常用法

- 开新对话：hook 自动注入状态；说“继续”或 `/pickup`，agent 复述后再动手。
- 过程中：决策当场记进 `docs/decisions.md`（D-n）；看不懂某个操作时问“依据是哪条”。
- 结束：`/wrap`，agent 更新「进行中」与记录并汇报。
- 审查：在 Codex 里说“按 ~/agent-system/review.md 审查当前未提交的改动”。

## 修改本仓库

改规则就改这里，所有项目同时生效。改完后在一个项目里开新会话确认 hook 输出正常。
新增 profile（例如非代码项目）时放进 `profiles/`，并在 RULE.md 的 Profile 一段登记。
规则的取舍当场记进 [decisions.md](decisions.md)（D-n），提交正文写 `Why: D-n`。
