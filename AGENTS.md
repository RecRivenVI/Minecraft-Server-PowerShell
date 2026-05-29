# PowerShell-MinecraftServerLauncher

## 全局注意事项

- **提交规范**：所有提交必须遵循 Conventional Commits（type(scope): 中文描述，scope 使用英文模块名），提交标题需概括所有变更中的重点变更，正文需列出所有变动文件（同类文件可合并列举）并说明大致修改内容。
  - **SSH 签名**：提交必须使用 SSH 密钥签名（`--gpg-sign=~/.ssh/id_ed25519.pub`）。
  - **保留时间戳**：rebase/squash 时使用 `--committer-date-is-author-date` 参数，确保 Committer Date 与 Author Date 一致。
  - **签名验证**：`git verify-commit` 因环境缺少 `gpg.ssh.allowedSignersFile` 会报错属正常现象，只要 commit object 中包含 `gpgsig` 字段即视为已签名。