# 决策记录

agent-system 本身的规则取舍。做出决策时当场追加，编号递增，旧条目不改编号。推翻旧
决策时在旧条目标题后加“（已被 D-n 替代）”。格式与记录范围见 [RULE.md](../RULE.md) 第 2 节。

建立本文件（2026-10-03）之前的取舍没有逐条补记，D-1 是补记的。初始设计见首个提交
`c3fce9c` 与 [README.md](../README.md)。当前状态与待办见 [project-notes.md](project-notes.md)。

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
- 选择：B，GitHub 私有仓库（地址用 `git remote -v` 查看，D-12），默认分支 `main`
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

### D-11 pre-commit 拦截令牌与密钥，命中时不回显内容（2026-10-03，用户决定）

- 背景：审查发现 pre-commit 只查私有 IP、home 路径、U+FFFD 和自定义词，`TOKEN=<真实令牌>`
  可以直接提交；而 Claude Code 的 settings.json 这类文件就含有令牌。原有的报告方式会把命中
  的整行打印出来，用在令牌上等于再输出一次。
- 选项：A 只加已知令牌格式 / B 已知格式 + 按名称识别的赋值（`TOKEN`、`SECRET`、`PASSWORD`、
  `API_KEY`、`ACCESS_KEY`、`PRIVATE_KEY` 等）；另需决定是否做白名单
- 选择：B，不做白名单
- 理由：令牌格式很多，只靠前缀漏得多（例如第三方中转服务的 `cr_` 令牌）。赋值规则为了减少
  误报，要求值是 16 位以上、含数字、后面紧跟引号/空白/逗号/分号/行尾的完整字符串；以 `<`、
  `$`、`{` 开头的视为占位符或变量。白名单等真遇到误报再加（用户决定）。
- 影响：`git-hooks/pre-commit` 新增 `secret` 检查，命中时只报文件和行号。2026-10-03 用
  19 个用例在临时仓库验证，并扫描 agent-system、blog、CodaPace、meshlink 的全部入库文件：
  首版在 CodaPace 有 3 处误报（`sqlite3_column_int64(`、同一行别处的数字），收紧后为 0。

### D-12 入库文件不写 GitHub 用户名，历史不改写（2026-10-03，用户决定）

- 背景：审查发现 README 和 D-3 写了真实的 GitHub 用户名，违反 RULE.md 第 6 节；D-3 只决定了
  用私有远端，没有声明隐私例外。
- 选项：A 在规则里登记例外 / B 脱敏，真实值放 private-notes / C 脱敏，改为引用
  `git remote -v`；另需决定是否改写已推送的历史
- 选择：C，历史不改写
- 理由：`.git/config` 里本来就有远端地址，不必再维护一份 private-notes。仓库私有，改写历史
  要强制推送，代价大于收益；只保证以后不再写入。提交身份里的 noreply 地址含用户名，属于
  git 元数据，不在 pre-commit 的检查范围内，保持不变。
- 影响：README 第 4 行和 D-3 的“选择”改为引用 `git remote -v`（D-3 只改这一处措辞，编号和
  结论不变）。本仓库的 `.git/privacy-patterns` 加入该用户名（不入库，换电脑时要重建）。

### D-13 new-project 按字面量替换占位符，经临时文件写入（2026-10-03，agent 选择）

- 背景：审查发现项目名直接拼进 sed 表达式。含 `/` 时 sed 失败，模板文件变成 0 字节而退出码
  仍为 0；重跑时空文件被当作“已存在”跳过，无法自愈。含 `&` 时标题出错。另外
  `更新：YYYY-MM-DD HH:MM` 只替换了日期。
- 选项：A 转义后仍用 sed / B awk 用 `index`/`substr` 做字面量替换
- 选择：B；先写临时文件，非空才 `mv` 到位；任何文件失败或已有文件为 0 字节时，报告并以
  非 0 退出（已有文件仍不覆盖）；项目名为空或含控制字符时拒绝；`HH:MM` 换成当前时间
- 理由：字面量替换不需要考虑 sed 和 awk 各自的特殊字符，`\` 也不例外；临时文件保证失败
  不留下空文件。
- 影响：`bin/new-project`。2026-10-03 在临时目录验证：`a/b`、`R&D`、`back\slash`、普通名称
  均生成正确；普通名称的输出与修改前相比只差 `HH:MM` 一行；重跑退出 0；已有空文件时
  警告并退出 1；控制字符退出 2。

### D-14 privacy-patterns 有无效正则时阻止提交（2026-10-03，agent 选择）

- 背景：审查发现 `.git/privacy-patterns` 写入无效正则时，grep 报错被吞掉，提交照常成功，
  等于静默关闭了项目自定义的隐私检查。
- 选项：A 跳过无效行并警告 / B 阻止提交，指出无效的行号
- 选择：B；另外扫描时 grep 出错（退出码 2）也阻止提交
- 理由：隐私检查失效时应该吵闹地失败；跳过某一行同样会让那一个词漏过去。
- 影响：`git-hooks/pre-commit` 在扫描前逐行校验正则（跳过空行和 `#` 注释，最后一行无换行
  也校验），grep 改用 `-e` 传入，以 `-` 开头的模式也能用。2026-10-03 用系统 BSD grep 2.6.0
  在临时仓库验证 11 个用例，含 `foo(`、`foo[`、末尾单个 `\`、注释后的第 3 行；D-11 的扫描
  也用 `/usr/bin/grep` 重跑，4 个仓库仍为 0 命中（首次扫描误用了交互 shell 里的 ugrep）。

### D-15 SessionStart hook 只在 agent 项目里要求复述（2026-10-03，用户决定）

- 背景：审查发现 hook 在任何 git 仓库里都输出“项目状态快照”并要求按 RULE.md 1.1 复述，
  与注释“项目外不输出”不符。改动后 CodaPace（尚无 `AGENTS.md`，笔记是
  `docs/project-notes.zh-CN.md`）和 agent-system 本身会被当作普通仓库。
- 选项：A agent 项目只认 `AGENTS.md` 或 `docs/project-notes.md`，CodaPace 以后补成标准结构 /
  B 把 `CLAUDE.md`、`docs/project-notes*.md` 等变体也算作 agent 项目
- 选择：A
- 理由：用户决定。判断规则保持简单；B 也注入不了 CodaPace 的「进行中」。
- 影响：`claude/hooks/session-start.sh`：agent 项目输出完整快照和复述要求；普通 git 仓库只
  输出 git 状态并注明不按 agent 项目处理；其他目录不输出。meshlink、blog 的输出与修改前
  逐字相同（2026-10-03 验证）。待办：CodaPace 用 `bin/new-project` 补成标准结构（单独任务）；
  agent-system 本身的处理见审查修复第 8 条。

### D-16 profile 按名称通用引用，每个 profile 必须有收尾一节（2026-10-03，agent 选择）

- 背景：RULE.md、pickup、wrap 都把 `profile: code` 和 `profiles/code.md` 写死，新增非代码
  profile 时这些地方不会生效；wrap 还按“第 3 节”引用，各 profile 的章节号不一定相同。
- 选项：A 每加一个 profile 就在这些地方逐个登记 / B 按 `<!-- profile: <名称> -->` 读
  `profiles/<名称>.md`，收尾按固定标题「收尾时的文档更新」引用
- 选择：B
- 理由：新增 profile 时只需要加文件、在 RULE.md 列出名称，不必改技能。
- 影响：RULE.md 的 Profile 一段（另加“文件不存在时告诉用户”和现有 profile 列表）；
  `claude/skills/pickup` 第 1 步；`claude/skills/wrap` 开头与第 4 步；README“修改本仓库”
  写明每个 profile 要有「收尾时的文档更新」一节。profiles/code.md 第 3 节已是这个标题。

### D-17 用 tests/run.sh 做脚本回归测试（2026-10-03，agent 选择）

- 背景：审查发现本仓库没有自动化测试，new-project 的特殊项目名问题因此没被发现；D-11 到
  D-15 的验证都是一次性命令。
- 选项：A 引入测试框架（如 bats）/ B 一个纯 bash 3.2 脚本
- 选择：B
- 理由：不引入依赖（profiles/code.md 第 4 节），换电脑 clone 后直接能跑。
- 影响：新增 `tests/run.sh`，覆盖 pre-commit、new-project、session-start、install。在临时目录、
  假 HOME、`GIT_CONFIG_GLOBAL=/dev/null` 下运行，不碰真实项目和配置；假令牌、私有 IP、home
  路径在运行时拼出，文件本身能通过 pre-commit。README 写明改脚本后先跑它。2026-10-03：
  当前版本 84 项全过；对 HEAD 版本（修复前）运行有 32 项失败，覆盖 D-11、D-13、D-14、D-15
  的每一处修复。

### D-18 本仓库只用 docs/project-notes.md 和 docs/decisions.md（2026-10-03，用户决定）

- 背景：按 D-15，没有 `AGENTS.md` 或 `docs/project-notes.md` 的仓库只注入 git 状态，
  agent-system 本身因此没有「进行中」，跨会话的工作接不上。
- 选项：A 补最小状态文档，`decisions.md` 移到 `docs/` / B 用 new-project 完整套用 code
  profile / C 保持普通仓库，只在 README 说明
- 选择：A，不加 `AGENTS.md`，不套用 code profile
- 理由：用户决定。用 hook 的约定路径即可注入「进行中」和最近决策；规则仓库不需要
  pitfalls、log 等文件。
- 影响：`decisions.md` 移到 `docs/decisions.md`（用 `mv`，提交时由 git 识别为改名），其中
  指向 RULE.md、README.md 的相对链接改为 `../`；新增 `docs/project-notes.md`（进行中与
  待办）；README“修改本仓库”的链接与说明相应修改。

### D-19 审查修复第 9 条的取舍（2026-10-03，用户决定）

- 背景：审查和自查剩下 6 个小问题：install 不自动改 settings.json、缺换电脑步骤、模板链接
  在模板目录里解析不到、hook 不提示过时与超长、profile 不自动加载、Codex 没有 hook。
- 选项与选择（用户同意 agent 的建议）：
  - install 自动合并 settings.json：不做，README 写清楚只检查不修改。该文件含令牌，macOS
    默认没有 jq，用文本工具改 JSON 容易改坏。
  - 换电脑步骤：写进 README，列出不随 clone 过来、要在本机重建的东西。
  - 模板链接：README 说明 `templates/` 的链接按生成后的结构写，检查链接时跳过。
  - hook 提醒：「进行中」时间戳之后有不更新 project-notes 的提交时提醒过时（同时更新了
    project-notes 的提交不算）；AGENTS.md 超过 200 行、project-notes 超过 600 行时提醒
    （阈值来自 profiles/code.md 第 1 节）。
  - 模板 AGENTS.md 用 `@` 导入 profile：不做。每个会话多占约 120 行上下文，公开仓库里
    路径不存在，Codex 不支持；pickup 和 RULE.md 已要求读 profile，发现漏读再考虑。
  - Codex 没有 SessionStart hook：README 写明开场靠 RULE.md 1.1。
- 影响：`claude/hooks/session-start.sh`、`tests/run.sh`（新增 7 项，共 91 项）、README。
  2026-10-03 对真实项目运行 hook：meshlink 的 project-notes 有 612 行，触发超长提醒（属实，
  未改动该项目）；blog 无提醒。

### D-20 new-project 的默认项目名取自解析后的目录（2026-10-03，agent 选择）

- 背景：准备给 CodaPace 补结构时发现，在项目目录里运行 `new-project .` 时，默认项目名是
  `basename .`，即 `.`，生成的标题是 `# . 开发与维护记录`。
- 选项：A 文档里要求总是写项目名 / B 进入目录后用 `basename "$PWD"` 取默认名
- 选择：B；显式给出的项目名仍在创建任何目录之前校验
- 理由：在项目目录里直接 `new-project .` 是最自然的用法。
- 影响：`bin/new-project`；`tests/run.sh` 新增 3 项（`.`、末尾斜杠、被拒绝的名称不创建目录），
  共 94 项。2026-10-03：当前版本全过；对 8784c32 运行时 `.` 一项失败。
