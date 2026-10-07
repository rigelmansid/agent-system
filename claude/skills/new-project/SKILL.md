---
name: new-project
description: Create a new project from a profile. Inside a P0NN_ container it creates the project folder there; in the folder that holds all projects it first creates the next-numbered container. Runs only when the user types /new-project (or /new-project <profile> <name>).
disable-model-invocation: true
---

# /new-project：用 profile 新建项目

按当前目录决定建在哪里，问清 profile 和名称，再运行 `~/agent-system/bin/new-project`
（D-41、D-44）。只建新项目，已有内容的文件夹用 `/adopt`。不提交。

## 一、判断位置（只读）

参数里和某个 profile 同名的是 profile，其余是项目名；项目名同时用作文件夹名。

1. **容器里**（当前目录名是 `P0NN_名称`）：建在 `./<项目名>/`，项目名默认是容器名去掉
   `P0NN_`（`P014_Foo` → `Foo`）。容器里已有 `materials/` 以外的文件夹时先问用户：是在这里
   再建一个项目，还是进去对已有的用 `/adopt`。
2. **容器里的项目目录**（上一层是 `P0NN_` 容器）：目录是空的（`.DS_Store` 不算）就建在 `.`；
   有内容时停下，建议用 `/adopt`。
3. **项目根目录**（当前目录下有 `P0NN_` 容器）：运行 `~/agent-system/bin/next-container`
   得到下一个编号，建在 `P0NN_<项目名>/<项目名>/`。根目录里已有同名容器（任何编号）时先问用户。
4. **其他位置**：说明上面三种用法后停下；用户确认这里就是放所有项目的根目录时，按第 3 种做。

## 二、问缺的信息

参数里没有 profile 时，列出 `~/agent-system/profiles/*/PROFILE.md` 的第一行请用户选；第 3 种
没有项目名时一起问。提问时写出将要建的路径。都已给出时不问，直接执行。

## 三、执行

1. 运行 `~/agent-system/bin/new-project <项目目录> <profile>`，处理输出里的 WARNING、ERROR。
2. 汇报建了什么（新容器、项目目录、`materials/`），请用户输入 `/cd <项目目录的绝对路径>`
   把会话移进新项目，这样会加载它的 CLAUDE.md（`/cd` 只能由用户输入）。已经在项目目录里时不用
   `/cd`，改为读一遍新建的 AGENTS.md 和所选 profile 的 PROFILE.md。然后请用户说这个项目要做
   什么，再填项目概况。
