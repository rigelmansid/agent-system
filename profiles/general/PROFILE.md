# general：通用项目，只要交接和决策记录，不要求 git 和测试

适用于在 `AGENTS.md` 开头声明 `<!-- profile: general -->` 的项目，例如调研、写作、设计这类
没有源码和测试的项目。通用规则见 `~/agent-system/RULE.md`，本文件只补充这类项目的部分。
需要测试或提交前隐私检查的项目用 `code`。

---

## 1. 文件结构

```text
<project>/
├── README.md              # 项目是什么，交付物在哪
├── AGENTS.md              # 这个项目特有的工作规则
├── CLAUDE.md -> AGENTS.md # 符号链接，只编辑 AGENTS.md
├── .gitignore             # 以后用 git 时，private-notes.md 不入库
├── private-notes.md       # 真实姓名、地址、账号、个人配置，不外传
└── docs/
    ├── project-notes.md   # Handoff、概况、当前状态、待办
    └── decisions.md       # 决策 D-n，只追加
```

项目目录旁还有一个 `../materials/`（`refs/`、`inbox/`、`scratch/`），约定见 RULE.md 第 4 节。
交付物和工作文件按项目需要放，不预先建空目录。新建项目用 `/new-project`，接入已有项目用
`/adopt`。

---

## 2. 内容归属

| 写到哪里 | 内容 |
|---|---|
| `AGENTS.md` | 怎么做：交付物的格式与位置、完成前的检查、项目特有的约定 |
| `project-notes.md` | 项目是什么、做到哪了：Handoff、概况、当前状态、待办、参考 |
| `decisions.md` | 用户拍板的事和会改变以后做法的选择（RULE.md 第 2 节） |

- 引用的资料原件放在 `../materials/refs/`，文档里写出处和相对路径，不大段复制原文。
- `AGENTS.md` 与 project-notes 开头各用一句话互相指向。

---

## 3. 收尾时的文档更新

在 `/wrap` 的步骤之外：

- project-notes 的待办：完成的删掉，新发现的加上。
- 当前状态只保留最新进展；过时的结论删掉，或注明日期移到参考。

---

## 4. 完成标准

RULE.md 1.2 的默认值：交付物已经生成，并按 `AGENTS.md` 的检查过一遍（链接能打开、引用有
出处、格式符合要求）。

---

## 5. 版本管理

不要求 git。用 git 时：只在用户要求时提交，推送只在用户明确指示时进行；提交主题用简短的
英文祈使句，有对应决策时正文写 `Why: D-n`。
