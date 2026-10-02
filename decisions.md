# 决策记录

agent-system 本身的规则取舍。做出决策时当场追加，编号递增，旧条目不改编号。推翻旧
决策时在旧条目标题后加“（已被 D-n 替代）”。格式与记录范围见 [RULE.md](RULE.md) 第 2 节。

建立本文件（2026-10-03）之前的取舍没有逐条补记，D-1 是补记的。初始设计见首个提交
`c3fce9c` 与 [README.md](README.md)。

### D-1 开场技能叫 /pickup，不叫 /resume（2026-10-03，补记）

- 背景：开场恢复状态的技能最初命名为 `resume`。
- 选项：A 保留 `resume` / B 改名 `pickup`
- 选择：B
- 理由：Claude Code 内置的 `/resume` 命令会覆盖同名技能，输入 `/resume` 调不到技能。
- 影响：`claude/skills/resume/` 改为 `claude/skills/pickup/`，README 同步；
  `~/.claude/skills/pickup` 链接到新目录。

### D-2 项目资料放在项目目录旁的 materials/（2026-10-03，用户决定）

- 背景：参考资料、待整理资料不想放进项目仓库；RULE.md 只说“临时文件不写进项目目录”，
  没有固定位置，agent 每次要另选目录。
- 选项：A 仓库内建 git-ignored 目录 / B 与项目目录同级的 `materials/`（`refs/`、
  `inbox/`、`scratch/`）/ C 统一的资料库（如 iCloud）
- 选择：B
- 理由：在仓库外，`git add -A`、打包脚本和全仓搜索都碰不到，不会误提交或进发布包；
  和项目放在同一个容器文件夹里，好找；入库文件用相对路径 `../materials/`，不含个人路径。
- 影响：RULE.md 第 4 节写入约定；profiles/code.md、模板 AGENTS.md 与 project-notes、
  README.md 补充引用；`bin/new-project` 自动建 `../materials/` 三个子目录。约定假设每个
  项目有自己的容器文件夹；项目直接放在共享目录下时，`../materials/` 会被多个项目共用。
  这个约定是在 meshlink 项目里定的，那边记为 D-15。

### D-3 本仓库推送到 GitHub 私有仓库（2026-10-03，用户决定）

- 背景：本仓库只在本机，没有远端；用户要长期维护。
- 选项：A 只留本地 / B GitHub 私有仓库
- 选择：B，`rigelmansid/agent-system`，私有，默认分支 `main`
- 理由：有异地备份和修改历史，换机器时能直接 clone。
- 影响：仓库保持私有，不改为公开。推送前照常检查没有真实地址、个人路径和密钥；提交
  身份用 GitHub noreply 地址。README 开头的说明相应修改。

### D-4 本仓库留在 ~/agent-system，不移进项目目录（2026-10-03，用户决定）

- 背景：用户考虑把本仓库移到存放各项目的目录下，作为一个单独的项目文件夹。最初放在
  home 的原因没有记录。
- 选项：A 留在 `~/agent-system` / B 移到项目目录，原位置留符号链接 / C 移走并改全部链接
- 选择：A
- 理由：本仓库是所有项目共用的工具，不是某个项目；`~/agent-system` 路径短且固定，
  RULE.md、技能和各项目文档可以直接写这个路径，不含用户名，能入库；移动后
  `~/.claude`、`~/.codex` 的链接、SessionStart hook 和各项目的 pre-commit 链接都要跟着处理。
- 影响：无改动。以后若要移动，按 B 或 C 处理上面列出的链接。
