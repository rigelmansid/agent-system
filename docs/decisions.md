# 决策记录

agent-system 本身的规则取舍。做出决策时当场追加，编号递增，旧条目不改编号。推翻旧
决策时在旧条目标题后加“（已被 D-n 替代）”。格式与记录范围见 [RULE.md](../RULE.md) 第 2 节。

建立本文件（2026-10-03）之前的取舍没有逐条补记，D-1 是补记的。初始设计见首个提交
`c3fce9c` 与 [README.md](../README.md)。当前状态与待办见 [project-notes.md](project-notes.md)。

### D-1 开场技能叫 /pickup，不叫 /resume（2026-10-03，补记）（已被 D-30 替代）

已精简（按 D-22，2026-10-04）：技能已在 D-30 删除。仍适用的教训：技能不要和 Claude Code
内置命令同名（如 `/resume`），否则调不到。原文见提交 `c0ece00`。

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

已精简（D-22）：命名先后经 D-6、D-10 改定，结论见 D-10。原文见提交 `bdc281a`。

### D-6 项目容器文件夹保持 Proj.0NN_名称（2026-10-03，用户决定）（已被 D-10 替代）

已精简（D-22）：结论见 D-10。原文见提交 `bdc281a`。

### D-7 CodaPace 的容器文件夹改为 P011_CodaPace（2026-10-03，用户决定）（已并入 D-10）

已精简（D-22）：单个项目的改名操作，结果与改名做法见 D-10。原文见提交 `bdc281a`。

### D-8 meshlink 的容器文件夹改为 P012_meshlink（2026-10-03，用户决定）（已并入 D-10）

已精简（D-22）：同 D-7。原文见提交 `bdc281a`。

### D-9 Yuancheng.io 的容器文件夹改为 P013_Yuancheng.io（2026-10-03，用户决定）（已并入 D-10）

已精简（D-22）：同 D-7。原文见提交 `bdc281a`。

### D-10 在用项目的容器文件夹命名为 P0NN_名称，归档不改（2026-10-03，用户决定）（容器命名规则已被 D-62 取消，改名做法仍有效）

- 背景：项目容器文件夹原来命名为 `Proj.0NN_名称`。用户先决定统一改为 `P0NN_名称`（D-5），
  又回滚（D-6），随后把在用的 CodaPace、meshlink、Yuancheng.io 逐个改名（D-7 至 D-9），
  其他项目移进了 `00_Archieve/` 和 `Other/`。
- 选项：A 保持 `Proj.0NN_名称`，逐个例外 / B 在用项目统一 `P0NN_名称`，归档和 `Other/`
  里的文件夹不改
- 选择：B，替代 D-5、D-6，合并 D-7 至 D-9
- 理由：用户决定；规则与目录现状一致。
- 影响：RULE.md 第 4 节的示例为 `P0NN_名称/`；`bin/new-project` 在容器文件夹名不符时警告
  （不阻止）；README 与 profiles/code.md 写明 `<dir>` 的形式。
- 改名做法（D-7 至 D-9 实际执行过）：先退出该文件夹里的所有 Claude Code / Codex 会话；
  改容器文件夹名；把按路径保存的数据一并改名：`~/.claude/projects/` 下对应的目录、
  `~/.claude.json` 的项目键、`~/.codex/config.toml` 的项目信任条目（没有就跳过）。日志和
  历史报告里的旧路径不改。各项目的 pre-commit 链接指向 `~/agent-system`，不受影响。

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

### D-13 new-project 按字面量替换占位符，经临时文件写入（2026-10-03，agent 选择）（随 bin/new-project 删除，D-62）

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

### D-15 SessionStart hook 只在 agent 项目里要求复述（2026-10-03，用户决定）（已被 D-39 替代）

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

### D-16 profile 按名称通用引用，每个 profile 必须有收尾一节（2026-10-03，agent 选择）（已被 D-62 替代）

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

### D-18 本仓库只用 docs/project-notes.md 和 docs/decisions.md（2026-10-03，用户决定）（已被 D-62 替代）

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

### D-19 审查修复第 9 条的取舍（2026-10-03，用户决定）（Codex 一项已被 D-24 修正；hook 提醒一项已被 D-39 替代，改由 /pickup 提醒）

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

### D-20 new-project 的默认项目名取自解析后的目录（2026-10-03，agent 选择）（随 bin/new-project 删除，D-62）

- 背景：准备给 CodaPace 补结构时发现，在项目目录里运行 `new-project .` 时，默认项目名是
  `basename .`，即 `.`，生成的标题是 `# . 开发与维护记录`。
- 选项：A 文档里要求总是写项目名 / B 进入目录后用 `basename "$PWD"` 取默认名
- 选择：B；显式给出的项目名仍在创建任何目录之前校验
- 理由：在项目目录里直接 `new-project .` 是最自然的用法。
- 影响：`bin/new-project`；`tests/run.sh` 新增 3 项（`.`、末尾斜杠、被拒绝的名称不创建目录），
  共 94 项。2026-10-03：当前版本全过；对 8784c32 运行时 `.` 一项失败。

### D-21 已有项目补结构时先改名再运行 new-project（2026-10-03，agent 选择）（new-project 部分随 D-62 删除，改名用 git mv 仍有效）

- 背景：「进行中」原定先在 CodaPace 运行 `new-project .` 再提迁移方案。但 new-project 会按
  模板新建空的 `docs/project-notes.md`，与把原笔记 `project-notes.zh-CN.md` 改名过去冲突。
- 选项：A 先运行，再删模板文件、改名 / B 先 `git mv` 原笔记，再运行，new-project 保留已有文件
- 选择：B
- 理由：new-project 从不覆盖已有文件，B 不需要删任何东西，改名历史也由 git 保留。
- 影响：`profiles/code.md` 第 1 节加一句已有项目的做法。CodaPace 按此完成，其决策记为
  CodaPace D-1（AGENTS.md 用中文、不变量保留编号、backlog 继续作逐条记录）。
  2026-10-03 验证：CodaPace 的 `swift run CoreTests` 490 通过、UI 类型检查无输出、
  pre-commit 对全部改动（临时索引）通过、SessionStart hook 注入了「进行中」与 D-1。

### D-22 精简已被替代和已并入的决策（2026-10-03，用户决定）

- 背景：用户要求清理本文件中无用的记录。D-5、D-6 已被 D-10 替代；D-7 至 D-9 是单个项目的
  改名操作，唯一仍有用的是改名做法，README 写的是“做法见 D-7”。RULE.md 第 2 节只允许追加，
  没有清理的规定。
- 选项：A 删除这些条目 / B 保留标题和编号，正文精简为一行，有用内容并入 D-10
- 选择：B，并在 RULE.md 第 2 节补一条精简规则
- 理由：用户决定清理，agent 建议 B。提交信息里的 `Why: D-n` 和文档里的引用仍能找到条目；
  原文留在提交 `bdc281a`，用 `git show bdc281a:docs/decisions.md` 查看。
- 影响：D-5 至 D-9 精简为一行；D-10 改写为可独立阅读，收入改名做法；README 的引用由 D-7
  改为 D-10；RULE.md 第 2 节新增精简规则（全局生效）。D-1 至 D-4、D-11 及以后未改动。

### D-23 new-project 拒绝在 P0NN_ 容器文件夹上运行（2026-10-03，用户决定）（随 bin/new-project 删除，D-62）

- 背景：在容器文件夹 `P011_CodaPace/` 里运行了 `new-project .`，它把容器当成项目：在真实
  仓库外层 `git init`、生成一套空模板，并在上一层 `VBCD/` 建了 `materials/`。已按用户指示删除
  这些产物，`CodaPace/` 与 `P011_CodaPace/materials/` 未受影响。
- 选项：A 只警告 / B 目标目录名是 `P0NN_*` 时拒绝，退出码 2，不创建任何东西
- 选择：B
- 理由：用户决定。按 D-10 容器与项目是两层，在容器上运行没有正当用途，警告容易被忽略。
- 影响：`bin/new-project` 在创建任何目录前检查目标目录名（已存在的取解析后的名字，否则取
  参数的 basename）；`tests/run.sh` 新增 4 项，共 98 项。2026-10-03：当前版本全过；对修改前的
  脚本运行时这 4 项失败；在真实的 `P011_CodaPace/` 里运行被拒绝，目录内容不变。

### D-24 Codex 支持 SessionStart hook，修正 D-19 的前提（2026-10-04，用户决定）

- 背景：D-19 写“Codex 没有 SessionStart hook，开场靠 RULE.md 1.1”，没有查文档。2026-10-04 核对
  Codex 官方文档（learn.chatgpt.com/docs/hooks）：hook 默认开启，有 SessionStart、Stop 等事件，
  配置在 `~/.codex/hooks.json`，纯文本 stdout 作为上下文交给模型；非托管 hook 要先在 `/hooks`
  里信任（按 hook 内容的哈希记录，改动后要重新信任）。本机 Codex 为 0.159.3。
- 选项：A 只改说法 / B 改说法，并把 hook 和技能接到 Codex（用户要求的第 2 条，见后续决策）
- 选择：先 A，随后做 B
- 理由：用户要求先修正错误说法。
- 影响：README 工具表、RULE.md 1.1 的说法改为两个工具都有 hook；D-19 标题注明 Codex 一项
  已被本条修正。

### D-25 把 SessionStart hook 和技能接到 Codex（2026-10-04，用户决定）（已被 D-27 替代）

已精简（按 D-22，2026-10-04）：已由 D-27 撤回。以后若再接 Codex 可参考：技能目录
`~/.agents/skills/`（格式同 Claude Code），hook 在 `~/.codex/hooks.json`、在会话 cwd 运行、
不提供 `CLAUDE_PROJECT_DIR`。原文见提交 `c0ece00`。

### D-26 SessionStart hook 改为 JSON 输出，给用户显示一行摘要，不设会话标题（2026-10-04，用户决定）（已被 D-28 替代）

已精简（按 D-22，2026-10-04）：未提交即由 D-28 退回纯文本，保留其中的 `LC_ALL=C` 修复。
以后若想让用户看到开场摘要可参考：JSON 的 `systemMessage` 显示给用户；JSON 无效时 Claude
会丢弃全部输出；`sessionTitle` 在 resume 时会覆盖用户起的会话名。原文见提交 `c0ece00`。

### D-27 仓库原则：简洁、不过度自动化；Codex 只链接 RULE.md（2026-10-04，用户决定）（原则中“不过度自动化”已被 D-31 替代）

- 背景：D-25 按 README“Codex 用于审查和非代码任务”的字面意思，把 hook 和技能接到了 Codex，
  事先没有问清用法。用户说明：Codex 只用于代码审查和一次性的非代码任务（在 Mac 上控制
  Windows 建模等），不需要跨会话交接；对本仓库的愿景是简洁、简约、高效，不过度自动化，
  自动化在长期使用中逐步加，不在初期预先建。
- 选项：A Codex 只链接 RULE.md，撤掉 D-25 / B 保留 D-25，只在 Codex 不显示摘要 / C 给 Codex
  一份单独精简的全局规则
- 选择：A；并把上面的愿景定为本仓库的原则
- 理由：用户决定。审查时 review.md 已要求读 AGENTS.md、决策和 diff，hook 和技能对一次性
  任务没有用处，却要多一步信任和一份维护。
- 影响：替代 D-25 和 D-26 中 Codex 的部分。`bin/install` 恢复为 48bdbd2 的版本；
  `session-start.sh` 去掉没有 `CLAUDE_PROJECT_DIR` 时回退到 git 根目录的逻辑；`tests/run.sh`
  去掉 Codex 的用例，加一项确认 install 不再为 Codex 建技能和 hook；README 开头写明原则，
  工具表和新电脑步骤去掉 Codex 部分；RULE.md 1.1 只写 Claude Code 的 hook。本机删除 D-25
  创建的 `~/.agents/`（只有两个技能链接）和 `~/.codex/hooks.json`（删前确认是 install 写的
  原样）。D-24 的事实更正保留。以后的改进按此原则取舍：对比清单里的 plugin 分发、Stop hook
  先不做，等实际使用中出现需要再说。

### D-28 SessionStart hook 退回纯文本，只保留 LC_ALL=C 修复（2026-10-04，用户决定）（已被 D-39 替代）

- 背景：D-26 为了在开场给用户显示一行摘要，在 hook 里加了约 60 行 JSON 转义（iconv、tr、sed、
  按字节截断）。按 D-27 的原则，这一项偏重。D-26 的测试顺带发现一个旧 bug：UTF-8 环境下
  project-notes 有无效字节时，awk 报错，「进行中」整块丢失。
- 选项：A 保留 JSON 摘要 / B 退回纯文本，保留 `LC_ALL=C` 修复
- 选择：B，替代 D-26（D-26 未提交）
- 理由：用户决定。摘要是锦上添花，转义代码是长期维护负担；bug 修复只要一行。
- 影响：`claude/hooks/session-start.sh` 恢复为 48bdbd2 的纯文本版本，加 `export LC_ALL=C`
  和注释；`tests/run.sh` 去掉 JSON 包装与摘要用例，加 2 项无效字节回归测试，共 101 项；README
  工具表写明纯文本输出。2026-10-04 验证：测试全过；对 1ad7235 运行时这 2 项和 D-27 的 1 项
  失败；4 个真实项目在 UTF-8 环境下的输出与 48bdbd2 版本逐字相同。用户开场看不到摘要，
  要看状态就让 agent 复述或用 /pickup。

### D-29 提高决策记录门槛；项目状态不写进 agent 自带记忆（2026-10-04，用户决定）

- 背景：本仓库一天半记了 28 条、341 行，其中不少是一次性的实现取舍，“影响”里还堆着验证
  细节；Claude Code 的 auto memory 与仓库文档可能各记一份项目状态。
- 选择：只记用户决定、会改变以后做法的选择、对旧结论的修正；实现取舍和验证过程写进提交
  信息；每项一两行。项目状态只写仓库文档，auto memory 只记个人偏好和跨项目习惯。
- 影响：RULE.md 第 2、3 节；wrap 第 2 步。旧条目不回头精简（RULE.md 第 2 节只在用户要求时）。

### D-30 去掉 /pickup 技能（2026-10-04，用户决定）（已被 D-33 替代）

- 背景：开场时 hook 已注入「进行中」并做过时检查，RULE.md 1.1 要求先复述，/pickup 与之重复。
- 选择：删除 `claude/skills/pickup/` 和 `~/.claude/skills/pickup` 链接；替代 D-1。保留 /wrap。
- 影响：README 工具表与日常用法。

### D-31 原则改为“简洁、简约、高效”，撤掉“不过度自动化”（2026-10-04，用户决定）

- 选择：保留简洁、简约、高效；撤掉 D-27 中“不过度自动化、自动化等长期使用后再加”。D-27 里
  Codex 只链接 RULE.md 的决定不变（依据是用户的 Codex 用法）。
- 影响：README 原则一行；D-27 标题注明；D-27 搁置的 plugin 分发、Stop hook 改为可评估的待办。
  已按旧原则做的 D-28、D-30 不回退。

### D-32 开场不重复读已载入的内容；一次性任务不复述、不收尾（2026-10-04，用户决定）（已被 D-39 替代）

- 选择：RULE.md 1.1 第 1 步改为 AGENTS.md 与「进行中」已自动载入时不再读；新增一句：代码审查、
  问答、单次操作跳过复述和 1.4 收尾。
- 影响：RULE.md 1.1（全局，含 Codex）。

### D-33 恢复 /pickup：只读查看状态，只能由用户调用（2026-10-04，用户决定）

- 背景：D-30 认为开场 hook 已注入状态、/pickup 重复，但忽略了两点：“继续”是有歧义的自然
  语言，而且会接着动手；对话中途想看状态时，开场注入的那份已经过时。
- 选择：恢复 /pickup，每次重新读磁盘上的「进行中」、待办、git 状态和引用的决策；对话中途
  时列出本会话还没写进「进行中」的进展；只读不动手；`disable-model-invocation: true`，只有
  用户输入 `/pickup` 才运行，描述不占上下文。“继续”的含义不变。替代 D-30。
- 影响：`claude/skills/pickup/`、README 工具表与日常用法。

### D-34 /adopt：把已有项目补成标准结构的命令（2026-10-04，用户决定）（已被 D-62 替代）

- 选择：新增技能 `/adopt`，只能由用户调用；分两段，先检查（位置、工作区、已有文件）并给出
  迁移方案后停下，用户确认后再执行（D-21 的先改名后运行、隐私扫描、验证、记迁移决策、不
  提交）。不在会话里移动项目目录。迁移步骤只在技能里维护，README 改为一句话指向它。
- 影响：`claude/skills/adopt/`、README 工具表与“建新项目 / 迁移已有项目”一节。

### D-35 收尾只由 /wrap 触发（2026-10-04，用户决定）

- 选择：wrap 设 `disable-model-invocation: true`，描述去掉中文触发词；RULE.md 1.4 改为只在
  用户输入 `/wrap` 时收尾，agent 可在工作单元结束时提醒一句，不自行收尾。
- 影响：`claude/skills/wrap/`、RULE.md 1.4（全局）、README 工具表。

### D-36 一个项目只由一个会话写 decisions.md 和「进行中」（2026-10-04，用户决定）

- 选择：照用户的正常工作流写成规则，其他会话只读。不另加“写前重读、合并”的机制：D-22 撞号
  是两个会话同时改本仓库的特殊情况。
- 影响：RULE.md 第 2 节末尾一行（全局）。

### D-37 审查修复：worktree 共用敏感词、补充令牌格式、/pickup 过时判断与 hook 一致（2026-10-05，用户决定）

- 背景：2026-10-05 全面审查发现：在 worktree 里提交时 `.git/privacy-patterns` 被忽略；
  Google、GitLab、npm、Stripe 令牌、JWT、URL 里的密码会被放行；/pickup 写的过时规则会误报；
  profiles/code.md 对 pre-commit 的描述过时；RULE.md 示例编号和本仓库的真实决策重名。
- 选择：pre-commit 从共用的 git 目录读 privacy-patterns，并补上这些格式（URL 密码以 `<`、`$`、
  `{` 开头时视为占位符）；/pickup 改用 D-19 的判断；code.md 改为指向 README；示例改成 D-n。
- 影响：git-hooks/pre-commit、tests/run.sh、claude/skills/pickup、profiles/code.md 第 5 节、
  README 工具表、RULE.md 第 1.3、2、3 节的示例。

### D-38 项目 AGENTS.md 只写项目特有的规则，不重复 RULE.md（2026-10-06，用户决定）

- 背景：审查 A1 发现模板 AGENTS.md 和 CodaPace、meshlink 的 AGENTS.md 都写了开场复述、收尾
  这类会话流程，和 RULE.md 重复；AGENTS.md 优先级更高，RULE.md 改了也不生效。用户的本意是
  两者没有交集，有交集时以 AGENTS.md 为准；这两个项目早于本仓库就有自己的 AGENTS.md。
- 选择：RULE.md 开头写明这条；模板去掉会话流程，改为一句指向 RULE.md；/adopt 出方案时
  列出已有 AGENTS.md 里和 RULE.md 重复的内容，建议删掉。CodaPace、meshlink 在各自项目里改。
- 影响：RULE.md 开头、templates/code/AGENTS.md、claude/skills/adopt。

### D-39 开场不自动读项目状态，只在用户输入 /pickup 时读；去掉 SessionStart hook（2026-10-06，用户决定）

- 背景：用户不一定每次都接着上次的工作，开场自动读「进行中」和待办会浪费 token；“继续”这个
  特定反应和 /pickup 作用重复。替代 D-15、D-28、D-32，以及 D-19 中 hook 提醒一项。
- 选择：RULE.md 1.1 改为开场不读状态，按用户的话做；/pickup 才读并显示。删除
  `claude/hooks/session-start.sh` 和 settings.json 里的登记；过时、超长提醒移进 /pickup。
  Claude Code 开场自带 git 状态快照，不再另外注入。
- 影响：RULE.md 1.1、claude/skills/pickup、profiles/code.md 第 1 节、claude/skills/adopt、
  bin/install、tests/run.sh、README；本机 ~/.claude/settings.json 删除该 hook。

### D-40 架构：全局部分 + 模块化 profile，/adopt 选定后才加载（2026-10-06，用户决定）（/pickup、/wrap 在没接入项目里的做法已被 D-43 替代）（已被 D-62 替代）

- 背景：用户明确本仓库分两部分：全局部分对所有项目生效；profile 按项目类型（代码、网页设计、
  建筑设计、演示等）做成模块，项目执行 /adopt 选定 profile 后，才加载它的文件夹结构、规则、
  专用命令和 hook，以后可以方便地增加模块。
- 选择：
  - 所有 profile 共用最小结构：AGENTS.md（CLAUDE.md 链接到它）、docs/project-notes.md
    （「进行中」、待办）、docs/decisions.md、private-notes.md、../materials/；各 profile 再加自己的。
  - RULE.md 保持全局；第 1–3 节只在已接入的项目（AGENTS.md 有 profile 声明）执行，第 4–7 节
    处处适用；未接入的项目里 /pickup、/wrap 提示可用 /adopt。
  - 是否用 git、是否装 pre-commit 由 profile 决定；依赖 git 的规则只对用 git 的项目适用。
  - 专用命令链接进项目 `.claude/skills/`，hook 写进 `.claude/settings.local.json`，都不进 git；
    先定目录约定，链接逻辑等第一个需要的 profile 出现时再写。此项待优化，按需求再升级（如改用
    plugin）。
  - 一个项目先只选一个 profile。模块只复制项目自有内容的骨架，不复制共享规则（承接 D-38）。
  - 模块放在 `profiles/<名称>/`（规则、骨架、可选的专用命令、hook、审查规则）；new-project 拆成
    “建结构”（/adopt 时做一次）和可反复运行的 setup（只恢复本机链接和设置）。
- 影响：待实施，实施时再改 README（不描述还不存在的东西）。审查 B3 不再适用，关闭；审查 C3
  由 setup 解决。

### D-41 profile 模块的组成，new-project 与 setup 的分工（2026-10-06，用户决定）（已被 D-62 替代）

- 背景：落实 D-40。
- 选择：模块是 `profiles/<名称>/`：`PROFILE.md`（第一行是名称和一句话说明，/adopt 列出它）、
  `template/`（只补不覆盖的骨架）、可选的 `setup` 脚本（本机设置，可反复运行）。
  `bin/new-project <dir> <profile> [名称]` 建结构，profile 必须写明；AGENTS.md 没有对应声明时
  不运行 setup，加声明属于改用户文件，交给 /adopt。新增 `bin/setup <dir>`：按 AGENTS.md 的
  声明建 `../materials/`、运行该 profile 的 setup，不建内容文件，拒绝没接入的项目；换电脑后
  对每个已接入的项目运行一次（解决审查 C3）。RULE.md 第 1–3 节只在已接入的项目执行，依赖 git
  的规则加前提；默认完成标准由 profile 规定，code 是相关测试通过加一次证明可用的检查；
  /pickup、/wrap 在没接入的项目里提示 /adopt。所有 profile 共用的骨架，等第二个 profile
  出现时再抽出来。
- 影响：bin/new-project、bin/setup、profiles/code/setup 与 PROFILE.md、RULE.md、三个技能、
  tests/run.sh、README。

### D-42 「进行中」区块改名 Handoff，字段改成英文（2026-10-07，用户决定）

- 选择：标题 `## Handoff`；字段 Updated、Task、Stopped at、Decisions、Waiting on user、Next、
  Don't repeat，内容可以用中文。旧项目里的「进行中」区块（中文字段）/pickup 和 /wrap 照样读，
  下次 /wrap 重写时改成新格式，不专门去改现有项目。
- 影响：RULE.md 第 1、2、3 节，code 模板与 new-project 的时间替换，PROFILE.md，三个技能，
  README，本仓库自己的 project-notes。影响现有项目：是（CodaPace、meshlink 下次 /wrap 时自动
  改格式）。

### D-43 没接入的项目里也能用 /pickup、/wrap，但不建 agent-system 的文件（2026-10-07，用户决定）

- 选择：/pickup 只读报告：git 状态和最近提交、项目自己笔记里的 Handoff（或「进行中」）区块、
  本会话进展，最后说明没有接入。/wrap 只在对话里汇报；项目自己的笔记里有交接区块时，问用户
  要不要更新它。都不建 docs/decisions.md、project-notes 等文件。替代 D-40 中“提示可用 /adopt
  后停下”一项。
- 影响：claude/skills/pickup、claude/skills/wrap、README。影响现有项目：是（blog 这类没接入的
  项目里两个命令开始可用）。

### D-44 新增 /new-project，在项目根目录里自动建下一个编号的容器（2026-10-07，用户决定）（已被 D-62 替代）

- 背景：新建项目要手动建 `P0NN_名称/` 容器、查下一个编号，再运行 `bin/new-project`；用户
  要在容器里或放所有项目的根目录里输入一个命令就建好。
- 选项：下一个编号 A 由技能里的模型数文件夹得出 / B 由脚本 `bin/next-container` 算
- 选择：B。技能按当前目录分三种：容器里、容器里的空项目目录、项目根目录（先建新容器）；
  建好后由用户输入 `/cd` 进入新项目。
- 理由：编号要扫描根目录和归档，用脚本算稳定、能测试；技能只做判断和询问。
- 影响：新增 `claude/skills/new-project/`、`bin/next-container`；README、code profile。归档里
  用过的编号不再用。影响现有项目：否（只在用户输入 `/new-project` 时运行）。

### D-45 在工作副本里改本仓库，用 bin/release 发布到正式版（2026-10-07，用户决定）

- 背景：链接和规则里的路径都指向 `~/agent-system`，改动一保存就影响所有项目，没改完的也一样。
- 选项：A 照旧直接改 / B 正式版留在 `~/agent-system`（main），在 worktree `~/agent-system-dev`
  （dev 分支）里改，`bin/release` 测试通过后发布、可回滚，新决策标注是否影响现有项目
- 选择：B，正式版目录不设只读。标签用 `release-N` 而不用日期时间：编号不会重名，回滚按编号
  找上一个（agent 选择）。
- 理由：链接和路径都不用改；发布前必须通过测试，出了问题能退回上一个发布。
- 影响：新增 `bin/release` 和测试、README。首次发布把当时的正式版标为 `release-0`；回滚只切换
  正式版的检出，不改写历史（D-12）。影响现有项目：否（以后的改动发布后才生效）。

### D-46 已有 docs/project-notes.md 的项目也适用第 1–3 节，/pickup 提示 /resume（2026-10-07，用户决定）（方案 A 已被 D-47 替代，/resume 提示仍有效）

- 背景：本仓库按 D-18 不接入 profile，按 D-43 算没接入：/pickup 读不到它的 Handoff，/wrap 不
  更新它，/pickup 还会建议用本仓库不该用的 /adopt。
- 选项：A 以有没有 docs/project-notes.md 作第二个标记 / B 给本仓库加 AGENTS.md 指向笔记 /
  C 以有没有 AGENTS.md 作标记
- 选择：A，替代 D-40 中第 1–3 节的适用范围和 D-43 的适用条件。两者都没有的文件夹照旧简化，
  /pickup 最后提示用 /resume 接着以前的对话、用 /adopt 持久记录。
- 理由：project-notes 是这套规则自己的文件，别人的仓库不会有；AGENTS.md 是多个工具共用的约定，
  会误判。B 只解决 /pickup 读 Handoff。
- 影响：RULE.md、claude/skills/pickup、claude/skills/wrap、README。影响现有项目：否（CodaPace、
  meshlink 已接入，不变；blog 没有 project-notes，只是 /pickup 多一句 /resume 提示）。

### D-47 撤回 D-46 的方案 A，保留 /pickup 的 /resume 提示（2026-10-07，用户决定）（已被 D-62 替代）

- 背景：D-46 让已有 docs/project-notes.md、没有 profile 声明的项目也适用第 1–3 节，已发布为
  release-2；用户决定撤回这部分。
- 选项：A 保留 D-46 / B 撤回方案 A，只留 /resume 提示 / C 用 bin/release --rollback 退回
  release-1（/resume 提示也会一起撤掉）
- 选择：B。D-40 的第 1–3 节适用范围和 D-43 的适用条件恢复有效，只看 profile 声明；本仓库没有
  声明，/pickup、/wrap 在这里走简化模式。
- 理由：用户决定；用户认为原来只按 profile 声明区分的逻辑没有问题。
- 影响：RULE.md、claude/skills/wrap 恢复到 release-1；/pickup 只多出 /resume 提示；README。
  影响现有项目：否（CodaPace、meshlink 不变；blog 保留 /resume 提示）。

### D-48 远端只同步 main，dev 和发布标签只在本地（2026-10-07，用户决定）

- 背景：D-45 之后本地有 main、dev 两个分支和 release-N 标签，推送时要定推哪些。
- 选项：A 只推 main / B main 和 dev 都推 / C 连标签一起推
- 选择：A。每次推送仍要用户明确指示（RULE 第 4 节）。
- 理由：用户决定。远端只放发布过的版本；发布后 dev 与 main 一致，换电脑后第一次发布会重新建
  release-0（D-45）。
- 影响：README「修改本仓库」。影响现有项目：否。

### D-49 /pickup、/wrap 只读用得上的部分；RULE.md、PROFILE.md 移出少用的细节（2026-10-08，用户决定）（PROFILE.md 一项随 D-62 删除）

- 背景：/pickup、/wrap 没规定怎么读文件，整份读入 project-notes（已接入项目各约 18k 字符）和
  decisions.md（本仓库约 21k 字符）时，一次 /pickup 可能近 2 万 token，用到的不到 2k。
- 选项：1 按章节、按条目读 / 2 精简 meshlink 的 AGENTS.md / 3 RULE.md 去掉与 /wrap 重复的步骤和
  模板 / 4 PROFILE.md 移出少用的章节 / 5 RULE.md 第 1–3 节改用 @ 导入 / 6 精简已替代的决策
- 选择：1、3、4。2 在 meshlink 里另做（D-38 的待办），5、6 暂不做。
- 理由：用户决定。1 省得最多且不改变行为；3、4 只是移动内容，每处仍只维护一份。
- 影响：pickup、wrap（读取方式；Handoff 格式和四段汇报移进 wrap）；RULE.md 1.4、第 2、3 节；
  PROFILE.md 第 1、3、5、6 节，新增 profiles/code/publish.md；adopt；README。影响现有项目：否（规则内容不变，项目文件不用改）。

### D-50 /pickup 的输出改成分项分行的 Markdown（2026-10-08，agent 选择，用户已确认）

- 背景：用户反馈 /pickup 的输出挤在一起难以阅读：原格式限 10 行，每项的多条内容用分号串成一行，
  在终端里折行后分不清项与项。
- 选项：A 保留 10 行，只缩短内容 / B 每项一个加粗标题，多条内容分行列出
- 选择：B，项的顺序不变，新增 Todo（最多 3 条）。每项最多 5 条、每条约 30 个汉字，删解释不删命令、
  路径和编号；过时标在 Handoff 的 Updated 后面；Uncommitted、Waiting on user 没有时写“无”，其余
  空项省略；没接入的项目用同样写法输出 Git、Handoff、New this session。
- 理由：用户要求优化；具体排版是 agent 的选择，按 /code-review 的意见补了空项、长度和过时的规则。
- 影响：claude/skills/pickup 的输出格式。影响现有项目：否（只改显示方式）。

### D-51 已接入的项目里输入 /adopt，直接运行 bin/setup 补本机部分（2026-10-08，用户决定）（bin/setup 部分已被 D-62 替代）

- 背景：换电脑后，已接入的项目要手动运行 `bin/setup`；用户希望尽量只用 Claude 命令。
- 选项：A 扩展 /adopt / B 新增 /setup 命令 / C 保持现状
- 选择：A。/adopt 遇到已有 profile 声明时不出方案，直接运行 `bin/setup .` 并提醒 setup 补不回的东西。
- 理由：用户决定。setup 只补本机部分、可反复运行，不需要确认；“文件夹在本机用不起来就输入
  /adopt”一条就够，命令数不变。`bin/install` 仍要在终端运行，因为命令要靠它才装上。
- 影响：claude/skills/adopt（新增第零节，后面各节顺延）、README 新电脑步骤、code PROFILE.md 第 5 节。影响现有项目：否。

### D-52 新增 /update：纯用户用一个命令更新 agent-system（2026-10-08，用户决定）

- 背景：纯用户没有 dev 工作副本，更新要在终端里 `git pull`、运行 `bin/install`，还看不到
  `bin/release` 那样的“影响现有项目”提醒。
- 选项：A 只在 README 写三条命令 / B 新增 /update
- 选择：B。只做 `pull --ff-only`、`bin/install` 和列出新决策（标 `!`）；有本地修改、不在 main 上时
  停下；本机有 dev 工作副本（开发者）时不更新，指向 `bin/release`。
- 理由：用户决定，符合简洁好用。步骤都是固定命令，只读 diff（D-49），不另写脚本。
- 影响：新增 claude/skills/update、README。影响现有项目：否（只在用户输入 /update 时运行）。

### D-53 开发者专用的 /release，放在本仓库的项目命令里（2026-10-08，用户决定）

- 背景：发布要记住说“运行 bin/release”；只说“发布到 main”时，模型可能自己用 git 合并，跳过测试
  和打标签。
- 选项：A 只靠记忆 / B 全局命令 / C 本仓库的项目命令 `.claude/skills/release`
- 选择：C。只在 agent-system 仓库里出现，不由 bin/install 装给所有用户；只运行 bin/release，
  未提交时先问，推送 main 要用户在对话里明确同意；纯用户的 clone 里也有这个文件，但会被第 1 步拦下。
- 理由：用户决定。和 /update 一起，开发者和纯用户各有一个命令，不用记脚本路径。
- 影响：新增 .claude/skills/release、README。影响现有项目：否。

### D-54 /adopt 帮项目建 .git/privacy-patterns（2026-10-08，用户决定）

- 背景：项目的敏感词文件要手动建，换电脑后也要重建，容易忘；没有它时 pre-commit 只拦通用的模式。
- 选择：/adopt 接入或补本机部分时，文件不存在就问要拦哪些真实用户名、主机名等，写成正则并检查
  有效性；用户说不需要就跳过，已存在不改。这些词只写进这个文件。
- 理由：用户决定。和 D-51 一起，换电脑后一个 /adopt 补齐所有本机部分（资料内容和 private-notes 除外）。
- 影响：claude/skills/adopt 第零节和第四节、README、code PROFILE.md 第 5 节。影响现有项目：否。

### D-55 用户自己决定有哪些 profile：官方的不删，自建的用 my- 前缀（2026-10-08，用户决定）（已被 D-62 替代）

- 背景：用户希望每个人自己决定 `profiles/` 下有哪些模块，可以增加自己需要的、不要用不到的。
  直接在 `~/agent-system/profiles/` 里删或加会让 `/update` 因工作区不干净而停下；自建的和以后
  发布的同名时 pull 报错（2026-10-08 在临时仓库实测）。
- 选项：A 只由开发者发布 profile / B 另建本机 profile 目录，所有查找改成查两处 /
  C 官方 profile 不删、不用就行；自建的放同一目录、名称以 `my-` 开头，由 `.gitignore` 忽略
- 选择：C。引导用户建 profile 的 `/new-profile` 等第二个 profile 做完、写好“profile 必须有什么”
  的说明后再做；第二个 profile 先做通用最小 profile。
- 理由：没用到的 profile 不读、不花 token，删掉没有收益；C 只加一行 `.gitignore`，脚本和规则里
  的查找不用改。代价是自建的 profile 不在 git 里，换电脑时由用户自己复制。
- 影响：`.gitignore` 加 `/profiles/my-*/`；官方 profile 不用 `my-` 开头。影响现有项目：否。

### D-56 第二个 profile general，所有 profile 共用的骨架抽到 skeleton/（2026-10-08，用户决定）（已被 D-62 替代）

- 背景：落实 D-55 的“先做通用最小 profile”；D-41 定了第二个 profile 出现时抽共用骨架。按现在的
  规则，只有接入了 profile 的项目才有 Handoff 和决策记录，非代码项目只能选 code。
- 选项：骨架 A 现在抽到仓库根目录的 `skeleton/` / B 先复制一份，以后再抽
- 选择：新增 `profiles/general`：AGENTS.md、project-notes（Handoff、概况、当前状态、待办）、
  decisions，不要求 git 和测试，没有 setup 脚本；完成标准是交付物已生成并按 AGENTS.md 检查过。
  骨架选 A：两个 profile 相同的 `docs/decisions.md`、`gitignore` 移到 `skeleton/`，`bin/new-project`
  先取 skeleton 再取 profile 的 template，同一路径用 template 的。
- 理由：用户决定。AGENTS.md 和 project-notes 两个 profile 不同，留在各自的 template。
- 影响：bin/new-project、tests/run.sh、RULE.md 的 Profile 段、adopt、README。code 生成的项目只差
  decisions.md 开头一句（去掉了 pitfalls 的指向，general 没有这个文件）。影响现有项目：否（只影响新建和补齐的文件）。

### D-57 profile 的规范写在 profiles/README.md，/new-profile 按它新建（2026-10-08，用户决定）（/new-profile 部分已被 D-58 替代）（已被 D-62 替代）

- 背景：落实 D-55。一个 profile 必须有什么，原来只散在 README「修改本仓库」一段里，是写给开发者的；
  纯用户自建时没有可照着做的说明，也容易漏掉 `my-` 前缀或声明。
- 选择：规范只写在 `profiles/README.md`（名称、必须有的文件、不用放进 template 的、可选的 setup、
  写法、检查、改名和删除），README 只链接它。新增 `/new-profile`：先读规范和 general，问名称、
  项目类型、额外文件、完成标准、收尾、要不要 git，出方案等确认，再写文件并在临时目录检查。
  纯用户只能建 `my-` 开头的；在 dev 工作副本里开发者可以选建官方的。
- 理由：用户决定。“至少两个项目重复用到才写进 profile”只约束官方 profile，自建的不限。需要
  git 和 pre-commit 时，`setup` 一行调用 code 的 setup，不复制脚本（2026-10-08 实测）。
- 影响：profiles/README.md、claude/skills/new-profile（`bin/install` 自动链接）、README。影响现有
  项目：否。

### D-58 /new-profile 改为 /profile：点选提问，三种起点，领域预设，可以修改和删除（2026-10-08，用户决定）（已被 D-62 替代）

- 背景：用户实测 /new-profile：一次问六个开放问题，全靠打字，体验不好；而且用户对自己那类项目
  往往已有习惯的文件夹结构，命令没有用上。自建的 profile 还没有修改和删除的办法。
- 选项：修改和删除 A 改成一个 `/profile`，进来点选新建、修改、删除 / B 保留 /new-profile，另加
  /edit-profile、/delete-profile / C 不加命令，只在规范里写手动做法
- 选择：A，替代 D-57 里的 /new-profile。全程用选择框点选。新建有三种起点：照已有项目的文件夹
  （只读文件夹名，具体名称换成通用名）、领域预设（调研、写作、设计、建筑、实验、财务、法律案件，
  写在命令旁的 presets.md，选了才读）、从已有 profile 改。自建的可以预建文件夹，每个放一行的
  `.keep`，用途写在 template 的 AGENTS.md。修改和删除只针对 `my-`：先找出在用的项目、点选怎么
  处理，旧版本放进被 git 忽略的 `profiles/.trash/`。
- 理由：用户决定。点选比打字省事，也不容易漏项；照已有项目最贴近用户自己的习惯。预设只是起点，
  复制成 `my-` 后由用户自己改，不当作官方 profile 维护。
- 影响：claude/skills/profile（原 new-profile）、presets.md；profiles/README.md 第 4、5、7 节；
  `.gitignore` 加 `/profiles/.trash/`；`bin/install` 删掉指向本仓库、但命令已不存在的链接
  （改名后不留死链接）；README、tests。影响现有项目：否。

### D-59 容器编号保持三位 P0NN_（2026-10-08，用户决定）（已被 D-62 替代）

- 背景：用户问 `P0NN_` 里的 0 能否去掉改成 `PNN_`，或让用户自己定格式。0 其实是三位编号的百位
  （P001–P999），写法 `P0NN` 容易让人以为是固定字符。
- 选项：A 保持 `P0NN_` / B 识别时几位都认，新编号的位数跟着已有容器，新用户第一次点选 /
  C 加本机配置文件，前缀和位数都能自定义
- 选择：A。README 写明是三位编号。
- 理由：用户决定。脚本、命令和现有容器都不用改；C 要加系统里第一个配置文件，前缀可变后还会把
  `Web2_site` 这类项目文件夹误认成容器。
- 影响：README 一句说明；以后不再讨论 PNN 或自定义格式，除非用户提出。影响现有项目：否。

### D-60 只有 /profile 用选择框，其他命令保持文字提问（2026-10-08，用户决定）（/profile 已随 D-62 删除，原则仍有效）

- 背景：D-58 让 /profile 全程点选后，agent 提议把 /new-project、/adopt、/release、/wrap 里的提问
  也改成点选。
- 选项：A 这几个命令也改成点选 / B 只有 /profile 用点选，其他保持原样
- 选择：B，撤回已经做好、还没提交的 A。原则：点选只用于 /profile 这类复杂、要多轮提问的命令，
  是为纯用户设计的；简单的交互保持文字。
- 理由：用户决定。
- 影响：无文件改动；以后新加的命令按上面的原则定提问方式；不再提议把这几个命令改成点选，除非
  用户提出。影响现有项目：否。

### D-61 /wrap 的读、改、检查合并成最多 5 轮（2026-10-09，用户决定）

- 背景：CodaPace 2026-10-06 的两次 /wrap 跑了 17 轮和 6 轮（按 Opus 5.5 标价约 $3.42、$0.65）。收尾时
  上下文 330k–380k，每轮都重发整段对话；读和改按文件拆开是轮数多的原因，离开 0.7 小时后才做又多了一次缓存重写。
- 选项：A 整份读文件，少一轮 / B 保留 D-49 的分节读，读、改、检查各合并成一轮 / C 交给子 agent 改文件
- 选择：B，最多 5 轮：一次读齐、按行号读其他节、一次改完、一次检查、汇报。加在文件末尾的内容
  用命令追加；Handoff 在最上方，直接读前 40 行；汇报每段一到三行。README 提示离开前先 /wrap。
- 理由：用户决定。实测中文约 1.2 字一个 token，CodaPace 的 project-notes 整份约 1.5 万 token，350k 时
  整份读和多一轮花费相当，A 省不了；C 有子 agent 的冷启动成本，和 B 差不多还更复杂。
- 影响：claude/skills/wrap、README。影响现有项目：否（只改收尾的做法，项目文件不用改）。

### D-62 收敛为 RULE.md 和 /adopt、/pickup、/wrap、/private 四个命令，删除 profile 等构架（2026-10-09，用户决定）

- 背景：profile、骨架、容器编号、new-project、setup 让“接入”变成先选 profile 的步骤；用户真正要的是
  通用的 /pickup、/wrap 和决策记录，general 这种只为打开交接而存在的 profile 说明门放错了位置。
- 选项：A 维持现状 / B 文件按需建、profile 改成可选（讨论过，未实施）/ C 收敛：只留四个命令和交付工具
- 选择：C，在 core 分支上做。有 `docs/project-notes.md` 就算接入；/adopt 没有笔记时建空白的
  project-notes、decisions、pitfalls、private-notes，有笔记时先出迁移方案、同意后再迁，git 项目另装
  pre-commit 和敏感词文件；pitfalls 成为通用文件；新增 /private，查改过的文件、同意后脱敏。保留
  bin/install、bin/release、/update、/release、git-hooks/pre-commit、tests，review.md 移到 docs/。删除
  profiles/、skeleton/、bin/new-project、bin/setup、bin/next-container、/new-project、/profile 和 P0NN_
  容器命名（容器文件夹本身保留）。
- 理由：用户决定。命令和文件对所有项目都一样，少一层概念、少一套模式；code 项目不再每次会话加载 PROFILE.md。
- 影响：替代 D-16、D-18、D-34、D-40、D-41、D-44、D-47、D-55 至 D-59 和其他条目里的相应部分；RULE.md、
  四个命令、README、tests、.gitignore。影响现有项目：是（CodaPace、meshlink 的 profile 声明不再起作用，code profile 的规则不再加载）。

### D-63 dev 分支留作 release-8 的存档，以后在 core 上开发（2026-10-09，用户决定）

- 背景：D-62 在 core 分支上做，已发布为 release-9；dev 停在 release-8（4e8c073），是删除 profile 之前的最后状态。
- 选项：A 把 dev 快进到 core，继续在 dev 上开发 / B dev 留作存档，以后在 core 上开发
- 选择：B。工作副本 `~/agent-system-dev` 留在 core；`bin/release` 发布工作副本当前所在的分支，不用改。
  两个分支和发布标签都只在本地（D-48）。
- 理由：用户决定；保留删除 profile 之前的完整状态，方便对照。
- 影响：README 新电脑步骤的工作分支名改为 core，/release 的说明改为“工作分支”。影响现有项目：否。
