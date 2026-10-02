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

### D-5 项目容器文件夹命名为 P0NN_名称（2026-10-03，用户决定）（已被 D-6 替代）

- 背景：存放各项目的目录下，项目容器文件夹原来命名为 `Proj.0NN_名称`。
- 选项：A 保持 `Proj.0NN_名称` / B 改为 `P0NN_名称`
- 选择：B，已有的文件夹一并改名
- 理由：用户的命名偏好。
- 影响：RULE.md 第 4 节的示例改为 `P0NN_名称/`。新项目用 `bin/new-project` 时，容器
  文件夹按此命名。已有文件夹的改名不在本仓库里做；Claude Code 与 Codex 按路径保存的
  会话历史、memory 和信任设置要随之迁移，在所有相关会话退出后执行。

### D-6 项目容器文件夹保持 Proj.0NN_名称（2026-10-03，用户决定）（已被 D-10 替代）

- 背景：按 D-5 把已有文件夹改为 `P0NN_名称` 后，用户回滚了改名，文件夹仍是
  `Proj.0NN_名称`。
- 选项：A 保持 `Proj.0NN_名称` / B 按 D-5 改为 `P0NN_名称`
- 选择：A，替代 D-5
- 理由：用户决定不改名。
- 影响：RULE.md 第 4 节的示例恢复为 D-5 之前的 `Proj.x/`。改名计划文件和改名时的配置
  备份已删除；文件夹、`~/.claude/projects/`、`~/.claude.json`、`~/.codex/config.toml`
  已核对为原状。

### D-7 CodaPace 的容器文件夹改为 P011_CodaPace（2026-10-03，用户决定）

- 背景：D-6 决定所有容器文件夹保持 `Proj.0NN_名称`；随后用户要求单独把 CodaPace 改名。
- 选项：A 维持 D-6 / B 只改 CodaPace，其余项目不变
- 选择：B，修改 D-6 中 CodaPace 一项
- 理由：用户决定。
- 影响：容器文件夹 `Proj.011_CodaPace` 改为 `P011_CodaPace`；`~/.claude/projects/` 下两个
  对应目录、`~/.claude.json` 的两个项目键随之改名（Codex 配置里没有该项目）。其余项目和
  RULE.md 的示例不变，因此容器文件夹命名暂时不统一。`codapace bak/` 里的旧审查报告仍写着
  更早的旧路径，属于历史记录，未改。

### D-8 meshlink 的容器文件夹改为 P012_meshlink（2026-10-03，用户决定）

- 背景：D-7 之后，用户要求 `Proj.012_meshlink` 同样改名。
- 选项：A 保持 `Proj.012_meshlink` / B 按 D-7 的做法改为 `P012_meshlink`
- 选择：B，修改 D-6 中 meshlink 一项
- 理由：用户决定。
- 影响：容器文件夹改名；`~/.claude/projects/` 下两个对应目录、`~/.claude.json` 的两个项目键、
  `~/.codex/config.toml` 的项目信任条目随之改名。`Proj.012_ATCS` 的旧条目对应的文件夹已不存在，
  未动。meshlink 的 pre-commit 链接指向 `~/agent-system`，不受影响。

### D-9 Yuancheng.io 的容器文件夹改为 P013_Yuancheng.io（2026-10-03，用户决定）

- 背景：D-8 之后，用户要求 `Proj.013_Yuancheng.io` 同样改名。
- 选项：A 保持 `Proj.013_Yuancheng.io` / B 按 D-7 的做法改为 `P013_Yuancheng.io`
- 选择：B，修改 D-6 中 Yuancheng.io 一项
- 理由：用户决定。
- 影响：容器文件夹改名；`~/.claude/projects/` 下两个对应目录、`~/.claude.json` 的两个项目键
  随之改名（Codex 配置里没有该项目）。仓库内只有 `.astro/dev.log` 含旧路径，是开发服务器
  日志，未改。改名时 Astro 开发服务器未在运行。

### D-10 在用项目的容器文件夹命名为 P0NN_名称，归档不改（2026-10-03，用户决定）

- 背景：D-7、D-8、D-9 把在用的三个项目逐个改为 `P0NN_名称`；用户同时把其他项目移进了
  `00_Archieve/` 和 `Other/`。D-6 只剩归档里的旧文件夹仍适用，RULE.md 的示例与实际不符。
- 选项：A 维持 D-6，逐个例外 / B 在用项目统一 `P0NN_名称`，归档和 `Other/` 里的文件夹不改
- 选择：B，替代 D-6，并合并 D-7、D-8、D-9 的结果
- 理由：用户决定；规则与目录现状一致。
- 影响：RULE.md 第 4 节的示例改为 `P0NN_名称/`。新项目用 `bin/new-project` 时，容器文件夹
  按此命名，容器文件夹名不符时 `bin/new-project` 给出警告（不阻止）；README 与
  profiles/code.md 写明 `<dir>` 的形式。以后改名按 D-7 的做法迁移 `~/.claude/projects/`、
  `~/.claude.json` 和 `~/.codex/config.toml` 中按路径保存的数据，README 日常用法有一句提示。
