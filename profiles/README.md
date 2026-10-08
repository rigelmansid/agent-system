# profile 必须有什么

一个 profile 是 `profiles/<名称>/` 下的一个文件夹，规定一类项目的文件结构和工作规则
（D-40、D-41）。现有 `code`、`general`，新建时以 `general` 为最小参照。本文是唯一的规范，
`/profile` 按它新建、修改和删除（D-57、D-58）。

## 1. 名称

- 只用字母、数字、`_`、`-`（项目声明 `<!-- profile: <名称> -->` 只认这些字符）。
- 用户自己建的以 `my-` 开头，被 git 忽略，`/update` 不受影响；官方的不用 `my-` 开头（D-55）。
- 不和已有的 profile 重名。

## 2. 必须有的文件

| 文件 | 要求 | 谁用它 |
|---|---|---|
| `PROFILE.md` | 第一行 `# <名称>：一句话说明`；必须有「收尾时的文档更新」一节（D-16） | `/adopt`、`/new-project` 列出第一行；已接入项目的会话开始时读全文；`/wrap` 按收尾一节执行 |
| `template/AGENTS.md` | 第 1–5 行内有 `<!-- profile: <名称> -->`；有预建的文件夹时，写一张文件夹用途表 | `bin/new-project` 复制进项目；声明不对时不运行 setup |
| `template/docs/project-notes.md` | 有 `## Handoff` 区块，字段同 RULE.md 第 3 节 | `/pickup`、`/wrap` |

`PROFILE.md` 建议的小节：适用范围（一句话，加“通用规则见 RULE.md，本文件只补充……”）、
文件结构、内容归属、收尾时的文档更新、完成标准（RULE.md 1.2 的默认值）。

## 3. 不用放进 template 的

- `docs/decisions.md`、`gitignore`：来自共用的 [skeleton/](../skeleton/)（D-56）。只有内容确实
  不同时才在 `template/` 放同一路径的文件，此时用 `template/` 的。
- `README.md`、`private-notes.md`、`CLAUDE.md` 链接：`bin/new-project` 自动建。

模板里的 `<项目名>`、`Updated: YYYY-MM-DD HH:MM`、`更新：YYYY-MM-DD` 会被替换；名为
`gitignore` 的文件复制后叫 `.gitignore`；相对链接按生成后的项目结构写。

## 4. 可选

- `setup`：可执行脚本，由 `bin/setup` 在项目目录里运行，做本机设置（code：git、pre-commit）。
  可反复运行，不建内容文件；失败时退出码非 0，警告以 `WARNING` 开头写到 stderr；兼容
  macOS bash 3.2。没有它时 `bin/setup` 只建 `../materials/`。只要和 code 一样的 git 与
  pre-commit 时，`setup` 写成一行 `exec "$(dirname "$0")/../code/setup"`。
- 预建的文件夹：自建的 profile 可以照用户习惯预建文件夹。`bin/new-project` 只复制文件、不建空
  文件，所以每个文件夹里放一个只有一行的 `.keep`（Finder 里看不到）；文件夹的用途只写在
  `template/AGENTS.md` 的表里（D-58）。
- 按需再读的文件（code：`publish.md`、`review.md`）：只在特定任务时读，由 `PROFILE.md` 的
  「按需再读」一节指向（D-49）。
- profile 专用的命令和 hook 暂不支持（D-40 Q4）。

## 5. 写法

- `PROFILE.md` 在每个已接入项目的会话里都要读，写短：不重复 RULE.md，只写这类项目特有的
  （参考：general 约 2.4k 字节，code 约 5.5k）。
- 官方 profile 只写这类项目里至少两个项目会重复用到的规则；只有一个项目用的，写进那个
  项目的 `AGENTS.md`。自建的不受这条限制。
- 官方 profile 不预建文件夹，需要时再加；自建的可以（第 4 节）。

## 6. 检查

1. `~/agent-system/bin/new-project <临时目录>/P001_t/t <名称>`：退出码 0，输出里没有 WARNING。
2. 生成的项目里 `head -1 AGENTS.md` 是这个 profile 的声明；`docs/project-notes.md` 有 Handoff。
3. 在生成的项目里开 Claude 输入 `/pickup`，能显示 Handoff。

官方 profile 另外要：在 RULE.md 的 Profile 一段登记，在 `tests/run.sh` 加测试，记一条决策。
自建的不登记；它不在 git 里，换电脑时自己复制 `profiles/my-*`。

## 7. 修改、改名和删除

已接入的项目在 `AGENTS.md` 里写着 profile 名称，改名或删除后这些项目的 `bin/setup` 会拒绝
运行，所以改名或删除前，先把声明了它的项目改用别的 profile。`PROFILE.md` 的改动在这些项目下次
开会话时生效；`template/` 的改动只影响以后新建或补齐的。

`my-` 开头的用 `/profile` 修改或删除：它会找出在用的项目、问怎么处理，改动或删除前把旧版本放进
`profiles/.trash/`（被 git 忽略，可以找回，不要了可以删）。官方的不在 `/profile` 里改或删（D-55）。
