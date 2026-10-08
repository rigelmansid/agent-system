---
name: new-profile
description: Create a profile for a kind of project, following profiles/README.md. Users get a my- profile in ~/agent-system/profiles that git ignores; in the agent-system dev worktree the developer can also create an official one. Asks a few questions, shows the plan, writes the files only after the user confirms, then checks them. Runs only when the user types /new-profile (or /new-profile <name>).
disable-model-invocation: true
---

# /new-profile：按规范新建一个 profile

规范只在 `profiles/README.md`（下称规范），先读它，再读 `profiles/general/` 的全部文件
作为最小参照（D-57）。这些路径都在 `~/agent-system/` 下；开发者建官方 profile 时读 dev 工作
副本里的。问清楚、出方案，停下等用户确认后再写；不覆盖已有的文件，不提交。

## 一、建在哪里（只读）

- **开发者的 dev 工作副本**（`git rev-parse --show-toplevel` 不是 `~/agent-system`，有
  `profiles/README.md`，并且 `git worktree list --porcelain | grep -c '^worktree '` 大于 1）：
  问用户建官方 profile（写在这个工作副本的 `profiles/` 里，名称不用 `my-`）还是自建的。
- **其他情况**：建自建 profile，写在 `~/agent-system/profiles/my-<名称>/`（D-55）。

## 二、问缺的信息

一次问完，每项附默认值，用户已经说了的不再问：

1. **名称**：参数或用户的话里给了就用。自建的没有 `my-` 前缀时自动加上，并说明原因；只用字母、
   数字、`_`、`-`；`profiles/` 下已有同名文件夹时请用户换一个。
2. **这类项目是什么**：交付什么、举一两个例子。写成 `PROFILE.md` 第一行的一句话说明和适用范围。
3. **除 general 的结构外还要哪些文件**：例如 `docs/sources.md`。默认不加。
4. **完成标准**：默认同 general，交付物已生成并按 `AGENTS.md` 检查过。
5. **收尾时还要更新什么**：默认同 general，待办和当前状态。
6. **要不要 git 和提交前隐私检查**：默认不要；要的话 `setup` 用规范第 4 节的一行写法调用
   code 的 setup，`PROFILE.md` 的版本管理一节照 code 第 5 节写提交规则。

## 三、方案（输出后停下）

列出要建的路径、每个文件的来源（照 general 改写 / 新写），以及 `PROFILE.md` 各节要写的要点。
`PROFILE.md` 按规范第 5 节写短，不重复 RULE.md；只写用户说过的，不替用户补规则。

## 四、执行（用户确认后）

1. 建 `PROFILE.md`、`template/AGENTS.md`（第一行是 `<!-- profile: <名称> -->`）、
   `template/docs/project-notes.md`（保留 Handoff 区块），以及方案里的其他文件；
   `docs/decisions.md`、`gitignore` 不放，它们来自 skeleton（规范第 3 节）。要 `setup` 时
   `chmod +x`。
2. 检查中文没有写入 U+FFFD（RULE.md 第 7 节）。
3. 按规范第 6 节的 1、2 检查：在 `mktemp -d` 建的临时目录里运行 `bin/new-project`（官方用工作
   副本里的，自建用 `~/agent-system/bin/new-project`），看完删除临时目录。第 3 项留给用户。
4. 官方 profile：按规范第 6 节登记 RULE.md、加测试、记决策，运行 `tests/run.sh`。

**输出**，写法同 `/pickup`：

```markdown
**Created**：<profile 文件夹路径>，N 个文件

**Checked**
- new-project：退出码 0，无 WARNING
- 声明、Handoff：有

**Next**
- 新建项目：`/new-project <名称>`；接入已有项目：`/adopt <名称>`
- 在生成的项目里输入 `/pickup` 确认能显示 Handoff
- 自建的不在 git 里，换电脑时复制 `profiles/my-*`
```

官方 profile 的 Next 改为：提交后输入 `/release` 发布。
