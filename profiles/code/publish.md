# publish.md：code 项目的公开发布

推送公开仓库、建 Release 之前读本文件；平时不用读（`PROFILE.md` 第 6 节）。

- 推送、建 Release 前再做一次全量隐私检查：
  `git ls-files | xargs grep -nE "<模式>"`，以及发布包的元数据（属主、扩展属性）。
- 本地历史里曾经提交过个人信息时，公开从全新的 orphan 分支开始，原分支永不推送：
  ```sh
  git checkout --orphan public && git commit -m "Initial public release"
  ```
- 公开仓库的提交身份用 GitHub noreply 地址，写在仓库的 git config 里。
