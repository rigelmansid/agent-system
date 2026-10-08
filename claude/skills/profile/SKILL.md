---
name: profile
description: Create, edit or delete a profile, the rules and folder template for a kind of project. Asks with clickable choices; a new profile can start from an existing project's folders, a domain preset or an existing profile. Users manage my- profiles that git ignores; in the agent-system dev worktree the developer can also create official ones. Runs only when the user types /profile (or /profile new|edit|delete [name]).
disable-model-invocation: true
---

# /profile：新建、修改、删除 profile

规范只在 `profiles/README.md`（下称规范），先读它和 `profiles/general/` 的全部文件。这些路径都在
`~/agent-system/` 下；开发者建官方 profile 时读 dev 工作副本里的。领域预设在
[presets.md](presets.md)，选了预设才读（D-58）。

**提问**：一律用选择框（AskUserQuestion）让用户点选，不让用户打字作答。每轮最多 4 题，每题
2–4 个选项，推荐的放第一个并标“（推荐）”；文件夹结构放进选项的预览；用户想写别的，用选择框
自带的“其他”。用户已经说过的不再问，用不上的题跳过。

**安全**：写入前给出最终预览，等用户点“确认”；不覆盖已有的文件；修改或删除前，把旧版本放进
`profiles/.trash/<名称>-<YYYYMMDD-HHMM>/`（被 git 忽略，可以找回）；不提交。

## 零、先确定

- **操作**：参数是 `new`、`edit`、`delete` 时直接用，否则点选：新建 / 修改 / 删除。修改和删除
  只针对 `my-` 开头的；官方的不删、不改（D-55），想在它基础上改，就新建、起点选“从已有 profile 改”。
- **根目录**（放所有项目的文件夹）：当前目录下有 `P[0-9][0-9][0-9]_` 文件夹，就是当前目录；当前
  目录本身是这样的容器，就是上一层；上一层是容器，就是上两层。都不是时点选：当前目录 / 其他。
- **在用它的项目**：`find <根目录> -mindepth 3 -maxdepth 4 -name AGENTS.md`（归档在下一层也算），
  前 5 行有 `<!-- profile: <名称> -->` 的。

## 一、新建

建在哪里：在开发者的 dev 工作副本里（`git rev-parse --show-toplevel` 不是 `~/agent-system`，有
`profiles/README.md`，`git worktree list --porcelain | grep -c '^worktree '` 大于 1）点选：自建 /
官方（写在工作副本的 `profiles/` 里，名称不用 `my-`）。其他情况都是自建，写在
`~/agent-system/profiles/my-<名称>/`。

1. **第 1 轮**
   - 起点：照已有项目（推荐）/ 领域预设 / 从已有 profile 改。
   - 这类项目属于：调研与写作 / 设计与建筑 / 科学实验 / 财务与法律（用来挑预设、建议名称）。
2. **第 2 轮**，按起点：
   - 照已有项目：选项是根目录下最近修改的 3 个项目（`ls -td <根目录>/P[0-9][0-9][0-9]_*/*/`，
     不含 `materials/`），当前目录是项目时放第一个。只读文件夹名，不读文件内容：
     `find <项目> -mindepth 1 -maxdepth 2 -type d`，跳过隐藏文件夹、`materials`、`node_modules`、
     `__pycache__`，子文件夹超过 8 个时只留这一层。客户名、人名、日期、版本号换成通用名
     （`2025-03_客户A_方案` → `方案`）。
   - 领域预设：在所选的类里点选，每个选项的预览是它的结构。
   - 从已有 profile 改：选项是 `profiles/*/PROFILE.md` 的第一行（多于 4 个时列官方的和最近修改的，
     其余用“其他”）。
3. **第 3 轮**，结构（单选，预览是整理后的文件夹树）：用这个结构（推荐）/ 文件夹名改成英文（或
   中文）/ 只要第一层 / 不预建文件夹（同 general）。
4. **第 4 轮**，规则：
   - 资料类文件夹（参考、资料这类，或预设里标了“资料类”的）：放到项目外的 `../materials/`
     （推荐，与其他项目一致）/ 留在项目里。
   - 文件命名：预设或已有项目的习惯（推荐）/ 日期前缀 `YYYYMMDD_` / 版本后缀 `_v01` / 不规定。
   - 完成标准（多选，默认全选）：预设给的各条；没有预设时用 general 的。
   - git：不用（推荐，同 general）/ 用 git 和提交前隐私检查（同 code）。
5. **第 5 轮**
   - 名称：2–3 个建议，只用字母、数字、`_`、`-`，自建的以 `my-` 开头（如 `my-research`）；
     已有同名文件夹的不列。
   - 额外文件和收尾（多选，默认全选）：预设给的额外文件（如 `docs/sources.md`）和收尾时要更新的。
6. **第 6 轮**，最终预览（文件树，加 PROFILE.md 各节要点）：确认 / 改结构 / 改规则 / 取消。

确认后写入：

1. `PROFILE.md`：第一行 `# <名称>：<一句话说明>`；适用范围、文件结构、内容归属、收尾时的文档
   更新、完成标准，用 git 时加版本管理。按规范第 5 节写短，只写用户选过的，用用户的语言。
2. `template/AGENTS.md`：第一行是声明；有预建文件夹时写一张“文件夹 | 放什么”表，再写文件命名、
   完成前的检查和隐私（照 general）。
3. `template/docs/project-notes.md`：照 general，保留 Handoff 区块；额外文件放进 `template/docs/`。
4. 每个预建的文件夹里放一个只有一行的 `.keep`（规范第 4 节）。
5. 用 git：`setup` 用规范第 4 节的一行写法，`chmod +x`；要忽略数据文件夹时写 `template/gitignore`：
   `skeleton/gitignore` 的内容加上这些文件夹。
6. 检查：没有 U+FFFD；按规范第 6 节的 1、2 在 `mktemp -d` 的临时目录里运行 `bin/new-project`
   （自建用 `~/agent-system/bin/`，官方用工作副本里的），看完删除临时目录。官方的再按规范第 6 节
   登记 RULE.md、加测试、记决策，运行 `tests/run.sh`。

## 二、修改

1. 点选要改的 `my-` profile（多于 4 个时列最近修改的 3 个，其余用“其他”）；一个都没有时说明，
   建议新建。
2. 多选要改的：文件夹结构 / 规则（说明、完成标准、收尾、命名）/ git / 改名。
3. 按第一节对应的轮次问，当前的值标“（当前）”并放第一个。
4. 最终预览列出改前改后的差别：确认 / 取消。确认后先把旧版本复制进 `.trash`，再写入，检查同
   第一节第 6 步。
5. 改了文件夹结构或额外文件时，列出在用它的项目，点选：补进这些项目（推荐）/ 不补。补就对每个
   项目运行 `~/agent-system/bin/new-project <项目> <名称>`：只补缺的，不覆盖、不删除；去掉的
   文件夹不会从已有项目里删掉，告诉用户。
6. 改名：按新名称建好后，列出在用它的项目，点选确认后把它们 `AGENTS.md` 的声明改成新名称，
   对每个运行 `~/agent-system/bin/setup <项目>`，再把旧文件夹移进 `.trash`。

`PROFILE.md` 的改动，在用它的项目下次开会话就生效；`template/` 的改动只影响以后新建或补齐的。

## 三、删除

1. 点选要删的 `my-` profile。
2. 列出在用它的项目。有的话点选：改用 general（推荐）/ 改用别的 profile / 取消。改用时把这些
   项目 `AGENTS.md` 的声明改成新名称，再对每个运行 `~/agent-system/bin/setup <项目>`。
3. 最终确认后，把文件夹移进 `.trash`。

## 输出

写法同 `/pickup`：

```markdown
**Created**：<profile 文件夹路径>，N 个文件（修改写 **Changed**，删除写 **Deleted**）

**Checked**
- new-project：退出码 0，无 WARNING
- 声明、Handoff：有

**Projects**：在用它的项目改了什么；没有写“无”

**Next**
- 新建项目：`/new-project <名称>`；接入已有项目：`/adopt <名称>`
- 在生成的项目里输入 `/pickup` 确认能显示 Handoff
- 自建的不在 git 里，换电脑时复制 `profiles/my-*`；旧版本在 `profiles/.trash/`，不要了可以删
```

官方 profile 的 Next 改为：提交后输入 `/release` 发布。
