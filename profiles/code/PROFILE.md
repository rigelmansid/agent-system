# code：代码项目，有源码和测试，用 git 管理，提交前做隐私检查

适用于在 `AGENTS.md` 开头声明 `<!-- profile: code -->` 的项目。通用规则见
`~/agent-system/RULE.md`，本文件只补充代码项目特有的部分。

---

## 1. 文件结构

```text
<project>/
├── README.md              # 面向使用者：是什么、怎么装、怎么用
├── AGENTS.md              # 面向 agent 与维护者：这个项目特有的工作规则
├── CLAUDE.md -> AGENTS.md # 符号链接，只编辑 AGENTS.md
├── .gitignore             # 至少包含 private-notes.md
├── private-notes.md       # 不入库：真实地址、用户名、个人配置
└── docs/
    ├── project-notes.md   # 热：进行中、概况、当前状态、待办、规划
    ├── decisions.md       # 冷：决策 D-n，只追加
    ├── pitfalls.md        # 冷：踩过的坑，编号 坑 n，只追加
    └── log.md             # 冷：阶段记录与验证记录，只追加
```

项目目录旁还有一个不入库的 `../materials/`（`refs/`、`inbox/`、`scratch/`），约定见
RULE.md 第 4 节。

按需再加，不预先建空目录：`scripts/`、`src/`、`tests/`、`experiments/`（一次性实验，
结论写回文档）、`docs/` 下的独立指南、`README.<lang>.md`、`LICENSE`。

新项目用 `~/agent-system/bin/new-project <dir> code` 初始化（骨架在本模块的 `template/`）。
`<dir>` 写成 `P0NN_名称/<project>`，每个项目一个容器文件夹（agent-system D-10）。已有项目在
项目里输入 `/adopt` 选 code 接入：先把原有笔记 `git mv` 为 `docs/project-notes.md`，再运行
`new-project . code`，它只补缺的文件（agent-system D-21、D-41）。

### 按读取频率分文件

| 文件 | 什么时候读 | 控制 |
|---|---|---|
| `AGENTS.md` | 每次会话 | 只写规则，约 200 行内 |
| `project-notes.md` | 用户输入 `/pickup` 时读「进行中」与待办；其余按需 | 约 600 行内；超出时把稳定的参考内容拆出去 |
| `decisions.md` | 改动涉及某个决策、或看不懂某个做法时 | 只追加 |
| `pitfalls.md` | 改动某个模块前，查相关的坑 | 只追加 |
| `log.md` | 需要历史证据时 | 只追加 |

---

## 2. 内容归属

判断标准：这条内容是在指导**怎么做**，还是在记录**项目是什么、发生了什么**？

| 写到哪里 | 内容 |
|---|---|
| `AGENTS.md` | 接手步骤；命令及前置条件；修改时不能破坏的不变量（引用 D-n / 坑 n）；操作真实环境的约定；项目特有的验证、隐私与发布规则 |
| `project-notes.md` | 进行中；概况与范围；当前状态（文件表、最新快照、验证现状摘要）；架构、环境、配置、日常使用；待办；规划与待定事项 |
| `decisions.md` | 每个决策的背景、选项、选择、理由、影响 |
| `pitfalls.md` | 现象、原因、修法、→ 对后续工作的启示 |
| `log.md` | 阶段记录（时间 / 进展 / 验证与限制）；验证记录（时间与来源 / 已确认 / 适用范围与限制） |

- 踩坑的现象和原因写进 `pitfalls.md`，由此得出的行为规则写进 `AGENTS.md`，规则旁
  标注“坑 n”。
- `AGENTS.md` 与 project-notes 开头各用一句话互相指向。
- `README.md` 只面向使用者，不写开发过程和内部讨论。
- 公开仓库的 `AGENTS.md` 要能独立使用：外部贡献者没有 `~/agent-system`，项目关键的
  验证与隐私规则在 `AGENTS.md` 里写全，不只引用本文件。

---

## 3. 收尾时的文档更新

在 RULE.md 第 1.4 节的基础上，代码项目还要：

- `log.md` 阶段记录追加一行；有真实验证的，验证记录追加一行。
- project-notes 的待办：完成的删掉（结果已在 log.md），新发现的加上。
- 当前状态只保留最新快照，过时的结论移进 log.md 并注明日期。
- 新的坑按下一个编号追加到 `pitfalls.md`；需要的话在 `AGENTS.md` 加对应规则。
- 规划事项定了：在规划章节更新状态，可执行的下一步移到待办，同时记一条决策。

---

## 4. 代码与测试

- 测试随功能一起写。每次行为改动都要有对应的测试场景。
- 修改模块前，先读相关决策和坑，并运行现有测试确认起点是好的。
- 带原因注释的代码（“这里必须这样，否则……”）在防止已知的静默失败，不要为了
  “简化”删掉；确需改动，先读注释引用的 D-n / 坑 n。
- 不凭空引入构建系统、依赖或新语言；需要时先记一条决策。
- 完成标准（RULE.md 1.2 的默认值）：相关测试通过，加上一次能证明功能可用的检查。

---

## 5. Git

- 只在用户要求时提交；推送只在用户明确指示时进行。
- 提交主题用简短的英文祈使句（`Add tunnel reconnect test`）。有对应决策时，正文写
  `Why: D-n`。
- 一个提交只做一件事；不混入与任务无关的改动。
- pre-commit hook 由本模块的 `setup` 装上：`new-project` 和 `/adopt` 会自动运行；换电脑后对
  项目运行一次 `~/agent-system/bin/setup <项目目录>`（agent-system D-41）。它检查哪些内容见
  agent-system 的 README 工具表。
  项目特有的敏感词（真实用户名、主机名）一行一个正则，写进
  `.git/privacy-patterns`（在 `.git` 里，不会被提交）。
- hook 拦下时修正内容，不用 `--no-verify` 绕过；确属误报，先告诉用户。

## 6. 公开发布

- 推送、建 Release 前再做一次全量隐私检查：
  `git ls-files | xargs grep -nE "<模式>"`，以及发布包的元数据（属主、扩展属性）。
- 本地历史里曾经提交过个人信息时，公开从全新的 orphan 分支开始，原分支永不推送：
  ```sh
  git checkout --orphan public && git commit -m "Initial public release"
  ```
- 公开仓库的提交身份用 GitHub noreply 地址，写在仓库的 git config 里。

---

## 7. 用 Codex 审查

审查代码时让 Codex 按 `~/agent-system/profiles/code/review.md` 进行，例如在 Codex 中：

> 按 ~/agent-system/profiles/code/review.md 审查当前未提交的改动。

审查结果交回 Claude Code 处理；采纳或不采纳的理由按需记为决策。
