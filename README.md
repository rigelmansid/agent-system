# agent-system

我和 AI agent（Claude Code 为主，Codex 用于代码审查和一次性的非代码任务）协作的规则与工具。
私有仓库，远端是 GitHub 私有仓库（D-3，地址用 `git remote -v` 查看），不公开。

原则：简洁、简约、高效（D-31）。

## 三层规则

| 层 | 文件 | 生效方式 |
|---|---|---|
| 通用 | [RULE.md](RULE.md)：会话协议、决策记录、Handoff 区块、执行安全、验证、隐私、写文档 | `~/.claude/CLAUDE.md`、`~/.codex/AGENTS.md` 链接到它，每个会话自动加载；第 1–3 节只在已接入的项目执行（D-40） |
| 项目类型 | `profiles/<名称>/` 模块，现有 [code](profiles/code/PROFILE.md)（代码项目：文件结构、内容归属、git、发布）和 [general](profiles/general/PROFILE.md)（通用项目：只要交接和决策记录，不要求 git 和测试，D-56） | `/adopt` 或 `new-project` 在项目 `AGENTS.md` 开头写入 `<!-- profile: <名称> -->`，之后才加载 |
| 项目 | 项目自己的 `AGENTS.md` 与 `docs/` | 项目目录 |

代码审查规则：[profiles/code/review.md](profiles/code/review.md)，给 Codex 用。

## 工具

| 文件 | 作用 |
|---|---|
| `bin/install` | 建立上面的全局链接和技能链接；可重复运行，已有的非链接文件不覆盖。不装任何 hook（D-39）。Codex 只链接 RULE.md（D-27） |
| `bin/new-project <dir> <profile> [名称]` | 按共用骨架 `skeleton/` 和所选 profile 的 `template/` 建项目或补齐缺的文件（只补不覆盖；同一路径两边都有时用 profile 的，D-56），再运行 `bin/setup`。`<dir>` 写成 `P0NN_名称/<project>`（D-10），写成容器文件夹本身会被拒绝（D-23）；AGENTS.md 没有对应的 profile 声明时不运行 setup（D-41） |
| `bin/setup <dir>` | 恢复已接入项目的本机部分：建 `../materials/`（容器文件夹名不符时提示），运行该 profile 的 `setup`（code：git 仓库、pre-commit）。可反复运行，不建任何内容文件；没接入的项目会被拒绝（D-41） |
| `bin/next-container [根目录]` | 输出下一个容器编号 `P0NN`：根目录和下一层（如 `00_Archieve/`）里 `P0NN_`、`Proj.0NN_` 文件夹的最大编号加一，归档过的编号不再用（D-44） |
| `bin/release [--rollback]` | 在工作副本 `~/agent-system-dev` 里运行，把改动发布到正式版 `~/agent-system`：测试通过后把 main 快进到 dev，打标签 `release-N`，列出新决策（影响现有项目的标 `!`），再运行 `bin/install`；`--rollback` 把正式版退回上一个发布。不推送（D-45） |
| `.claude/skills/release` | 本仓库自己的项目命令 `/release`，只在 agent-system 仓库里出现，不由 `bin/install` 安装：在 dev 工作副本里检查未提交的改动、运行 `bin/release`、汇报新决策，再问要不要推送 main；`/release rollback` 退回上一个发布（D-53） |
| `claude/skills/pickup`、`wrap`、`adopt`、`new-project`、`profile`、`update` | `/pickup` 读取并显示项目状态，只读不动手，开场或对话中途都可用；开场不会自动读状态（D-33、D-39）；`/wrap` 收尾记录；`/adopt` 先选 profile，再把项目接入（D-34、D-40），已接入的项目里只运行 `bin/setup` 补本机部分（D-51）；`/new-project` 选 profile 新建项目，在项目根目录里先建下一个编号的容器（D-44）；`/profile` 按 [profiles/README.md](profiles/README.md) 用点选新建、修改、删除 profile，新建时可以照已有项目的文件夹、领域预设或已有 profile 开始，纯用户管的是 `my-` 开头、不进 git 的（D-55、D-57、D-58）；`/update` 从 GitHub 拉取 main、重建链接并列出新决策，开发者本机不用它（D-52）。这些命令都只在用户输入时运行（D-35）。`/pickup`、`/wrap` 在没接入的项目里也能用：只读报告、只在对话里汇报，不建文件，`/pickup` 最后会提示用 `/resume` 接着以前的对话（D-43、D-47） |
| `git-hooks/pre-commit` | 拦截令牌与密钥（常见令牌格式、URL 里的密码、`TOKEN=…` 类赋值；只报行号，D-11、D-37）、私有 IP、home 路径、U+FFFD 和 `.git/privacy-patterns` 中的词（worktree 共用这份文件）；该文件有无效正则时也拦截（D-14） |
| `tests/run.sh` | 上面这些脚本的回归测试，在临时目录和假 HOME 中运行，约 10 秒（D-17） |

## 日常用法

- 开场：模型不会自动读项目状态，直接说要做什么。想接着上次做，先输入 `/pickup`：它读
  Handoff 区块、待办和相关决策并显示出来，之后照常下指示（D-39）。对话中途也可以用。
- 过程中：决策当场记进 `docs/decisions.md`（D-n）；看不懂某个操作时问“依据是哪条”。
- 结束：`/wrap`，agent 重写 Handoff 区块、更新记录并汇报。对话已经很长、又要离开超过 5 分钟时，
  离开前先 `/wrap`：缓存 5 分钟后过期，回来再做要先把整段对话重新写进缓存（D-61）。
- 项目资料：放在项目目录旁的 `materials/`（`refs/` 参考、`inbox/` 待整理、`scratch/`
  agent 临时产出），不进 git；想让 agent 用某份资料就在任务里点名。约定见 RULE.md 第 4 节。
- 项目容器文件夹：在用的项目命名为 `P0NN_名称`（三位编号，从 P001 起，D-59），归档不改（D-10）。改名时一并迁移
  `~/.claude/projects/` 下的目录、`~/.claude.json` 的项目键和 `~/.codex/config.toml` 的
  信任条目，做法见 D-10；改名前退出该文件夹里的所有会话。
- 审查：在 Codex 里说“按 ~/agent-system/profiles/code/review.md 审查当前未提交的改动”。
- 为一类项目建自己的 profile：输入 `/profile`，建出 `my-<名称>`，之后 `/new-project`、`/adopt` 就能选它；以后要改或删也用它（D-58）。
- 更新 agent-system：输入 `/update`（D-52）。开发者的正式版由 `bin/release` 更新，见「修改本仓库」。

## 建新项目 / 迁移已有项目

- **空的新项目**：在放所有项目的根目录开 Claude，输入 `/new-project <名称>`，它按下一个编号
  建容器 `P0NN_<名称>/`，项目目录在容器下面（D-44）。已经建好容器时，在容器里开 Claude 输入
  `/new-project`，项目目录名默认是容器名去掉 `P0NN_`。选好 profile（现有 `code`、`general`；也可以写成
  `/new-project code <名称>`）后建好骨架，再按提示输入 `/cd <项目目录>` 进入新项目，说这个
  项目要做什么，填写项目概况；AGENTS.md 的占位符在有了真实命令和规则后再填。
  也可以直接运行脚本 `~/agent-system/bin/new-project <容器>/<名称> <profile>`（在 Claude 里
  前面加 `!`），输出里没有 WARNING 即成功；路径写到容器下面一层的项目目录（D-10），写成容器
  本身会被拒绝（D-23）。
- **已有内容的项目**：先放进 `P0NN_名称/` 容器（要移动时按 D-10 迁移按路径保存的数据）。
  在项目目录开 Claude，输入 `/adopt`（或 `/adopt code`）：先选 profile，再检查并给出迁移
  方案，确认后再执行，步骤见 [claude/skills/adopt](claude/skills/adopt/SKILL.md)（D-34）。
  CodaPace 是按这个流程迁移的。没有 `/adopt` 过的项目只受 RULE.md 第 4–7 节约束（D-40），
  `/pickup`、`/wrap` 照样能用，但不会建出 agent-system 的文件（D-43）。
- **不要在这些项目里用内置的 `/init`**：它会生成或改写 CLAUDE.md，而这里的 CLAUDE.md 是
  指向 AGENTS.md 的软链接，会不会改坏 AGENTS.md 或替换掉软链接没有验证过。补结构用 `/adopt`。

## 在新电脑上安装

1. 装好 Claude Code 和 Codex，配置好各自的登录或 API（不在本仓库）。
2. 登录 GitHub 后 clone 到 `~/agent-system`（D-4）。
3. 运行 `~/agent-system/bin/install`。出现 `SKIP` 时把那个文件移走再运行。再建工作副本：
   `git -C ~/agent-system worktree add -b dev ~/agent-system-dev`（D-45）。
4. 重建本机才有的东西（都不随 clone 过来）：
   - 本仓库的 `.git/privacy-patterns`（D-12）；
   - 每个已接入的项目（AGENTS.md 开头有 profile 声明）：clone 后在项目里开 Claude 输入 `/adopt`，
     它运行 `bin/setup`，恢复 `../materials/` 目录和该 profile 的本机设置（code：pre-commit）
     （D-41、D-51），没有 `.git/privacy-patterns` 时问你要拦哪些敏感词并写进去（D-54）。没接入的项目不用管；
   - 各项目的 `private-notes.md` 和 `../materials/` 里的资料，从旧电脑自行同步（setup 只建
     空目录）。
5. 运行 `tests/run.sh`，再在一个项目里开新会话，输入 `/pickup`，确认能显示 Handoff 区块。

## 修改本仓库

`~/agent-system` 是正式版：链接和规则里的路径都指向它，在这里改了，之后新开的会话就会用上。
所以改本仓库要在工作副本 `~/agent-system-dev`（同一仓库的 git worktree，`dev` 分支）里开
Claude（D-45）。改了 `bin/`、`git-hooks/` 或 `profiles/*/setup` 后运行 `tests/run.sh`，全部
通过再提交；提交后输入 `/release`（它运行 `~/agent-system-dev/bin/release`，D-53）发布。发布后出了问题，运行
`bin/release --rollback` 退回上一个发布（每运行一次退一个），在 dev 里修好再发布。
推送只推 main，dev 和发布标签留在本地（D-48）；每次推送都要用户明确同意。
新决策在「影响」一项末尾写“影响现有项目：是/否（原因）”，“影响现有项目：是”不要跨行，
`bin/release` 靠它把这类决策标出来。
每个 profile 是 `profiles/<名称>/` 下的一个模块（D-40、D-41），所有 profile 共用的文件放在
`skeleton/`（D-56）。一个 profile 必须有什么、怎么检查，只写在 [profiles/README.md](profiles/README.md)；
新增官方 profile 时在 dev 里输入 `/profile`，选“新建”和“官方”（D-58）。
规则的取舍当场记进 [docs/decisions.md](docs/decisions.md)（D-n），提交正文写 `Why: D-n`。
本仓库不按 code profile 管理，只用 [docs/project-notes.md](docs/project-notes.md)（Handoff
区块与待办）和 docs/decisions.md 两个文件（D-18）。本仓库没有 profile 声明，`/pickup`、`/wrap`
在这里走简化模式，提示里的 `/adopt` 不适用（D-18、D-47）。
`profiles/*/template/` 里的相对链接（如 `../README.md`）按生成后的项目结构写，在模板目录里
本来就解析不到，检查链接时跳过这些目录。
