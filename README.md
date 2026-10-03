# agent-system

我和 AI agent（Claude Code 为主，Codex 用于代码审查和一次性的非代码任务）协作的规则与工具。
私有仓库，远端是 GitHub 私有仓库（D-3，地址用 `git remote -v` 查看），不公开。

原则：简洁、简约、高效（D-31）。

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
| `bin/install` | 建立上面的全局链接和技能链接；可重复运行，已有的非链接文件不覆盖。只**检查** `settings.json` 里的 SessionStart hook，缺少时打印要粘贴的片段，不自动修改该文件（D-19）。Codex 只链接 RULE.md（D-27） |
| `bin/new-project <dir> [名称]` | 按 `templates/code/` 建项目或补齐缺的文件，建 `../materials/`，装 pre-commit hook；不覆盖已有文件。`<dir>` 写成 `P0NN_名称/<project>`（D-10），容器文件夹名不符时提示 |
| `claude/hooks/session-start.sh` | 新会话、`/clear`、压缩后注入「进行中」、最近决策与 git 状态；没有 `AGENTS.md` 或 `docs/project-notes.md` 的仓库只注入 git 状态（D-15）。「进行中」之后有提交没更新它、或 AGENTS.md 超过约 200 行、project-notes 超过约 600 行时加一行提醒（D-19）。纯文本输出，只进模型上下文（D-28）；只给 Claude Code 用（D-27） |
| `claude/skills/wrap` | `/wrap` 收尾记录。开场不需要技能：hook 注入状态，RULE.md 1.1 要求先复述（D-30） |
| `git-hooks/pre-commit` | 拦截令牌与密钥（只报行号，D-11）、私有 IP、home 路径、U+FFFD 和 `.git/privacy-patterns` 中的词；该文件有无效正则时也拦截（D-14） |
| `tests/run.sh` | 上面四个脚本的回归测试，在临时目录和假 HOME 中运行，约 6 秒（D-17） |

## 日常用法

- 开新对话：hook 自动注入状态；说“继续”，agent 复述后再动手。
- 过程中：决策当场记进 `docs/decisions.md`（D-n）；看不懂某个操作时问“依据是哪条”。
- 结束：`/wrap`，agent 更新「进行中」与记录并汇报。
- 项目资料：放在项目目录旁的 `materials/`（`refs/` 参考、`inbox/` 待整理、`scratch/`
  agent 临时产出），不进 git；想让 agent 用某份资料就在任务里点名。约定见 RULE.md 第 4 节。
- 项目容器文件夹：在用的项目命名为 `P0NN_名称`，归档不改（D-10）。改名时一并迁移
  `~/.claude/projects/` 下的目录、`~/.claude.json` 的项目键和 `~/.codex/config.toml` 的
  信任条目，做法见 D-10；改名前退出该文件夹里的所有会话。
- 审查：在 Codex 里说“按 ~/agent-system/review.md 审查当前未提交的改动”。

## 建新项目 / 迁移已有项目

`new-project` 是脚本，要写完整路径；在 Claude 里前面加 `!`。路径写到容器文件夹下面一层
的项目目录（D-10），写成容器文件夹本身会被拒绝（D-23）。

- **空的新项目**：运行 `~/agent-system/bin/new-project ~/<项目目录>/P0NN_名称/名称`，最后
  一行显示 `ok private-notes.md is ignored` 即成功。进入该目录开 Claude，说“继续”，按模板
  的下一步填写项目概况；AGENTS.md 的占位符在有了真实命令和规则后再填。
- **已有内容的项目**：先放进 `P0NN_名称/` 容器（要移动时按 D-10 迁移按路径保存的数据）。
  在项目目录开 Claude，说“按 agent-system 把这个项目补成标准结构，先给我迁移方案”。
  agent 会：确认工作区干净 → 旧笔记先 `git mv` 为 `docs/project-notes.md` 再运行
  `new-project .`（D-21，已有文件只保留不覆盖）→ 处理输出里的 `WARNING`（常见：旧
  `.gitignore` 缺 `private-notes.md`）→ 给出内容迁移方案，确认后拆进 AGENTS.md、decisions、
  pitfalls、log → 提交前做隐私扫描（公开仓库推送前全量检查，profiles/code.md 第 6 节）→
  跑原有测试、开新会话确认注入了「进行中」。CodaPace 是按这个流程迁移的（CodaPace D-1）。

## 在新电脑上安装

1. 装好 Claude Code 和 Codex，配置好各自的登录或 API（不在本仓库）。
2. 登录 GitHub 后 clone 到 `~/agent-system`（D-4）。
3. 运行 `~/agent-system/bin/install`。出现 `SKIP` 时把那个文件移走再运行。
4. 按 install 打印的片段，把 SessionStart hook 合并进 `~/.claude/settings.json`，再运行一次
   install，全部显示 `ok`。
5. 重建本机才有的东西（都不随 clone 过来）：
   - 本仓库的 `.git/privacy-patterns`（D-12）；
   - 各项目：clone 后运行 `bin/new-project <项目目录>` 装上 pre-commit hook（只补缺的，
     不覆盖），并重建该项目的 `.git/privacy-patterns`；
   - 各项目的 `private-notes.md` 和 `../materials/`，从旧电脑自行同步。
6. 运行 `tests/run.sh`，再在一个项目里开新会话，说“继续”，确认 agent 先复述「进行中」。

## 修改本仓库

改规则就改这里，所有项目同时生效。改了 `bin/`、`git-hooks/` 或 `claude/hooks/` 后运行
`tests/run.sh`，全部通过再提交；改完后在一个项目里开新会话确认 hook 输出正常。
新增 profile（例如非代码项目）时放进 `profiles/<名称>.md`，并在 RULE.md 的 Profile 一段
登记。每个 profile 都要有「收尾时的文档更新」一节，`/wrap` 按它执行（D-16）。
规则的取舍当场记进 [docs/decisions.md](docs/decisions.md)（D-n），提交正文写 `Why: D-n`。
本仓库不按 code profile 管理，只用 [docs/project-notes.md](docs/project-notes.md)（「进行中」
与待办）和 docs/decisions.md 两个文件（D-18）。
`templates/` 里的相对链接（如 `../README.md`）按生成后的项目结构写，在模板目录里本来就
解析不到，检查链接时跳过 `templates/`。
