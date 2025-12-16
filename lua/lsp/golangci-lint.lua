-- ============================================================================
-- golangci-lint-langserver 配置 - Neovim 0.11+ API
-- ============================================================================
-- 注意: common 已在 lsp/init.lua 中加载

-- ============================================================================
-- golangci-lint-langserver 配置 (使用 vim.lsp.config)
-- ============================================================================
vim.lsp.config("golangci_lint_ls", {
    cmd = { "/root/go/bin/golangci-lint-langserver" },
    filetypes = { "go", "gomod" },
    root_markers = { ".golangci.yml", ".golangci.yaml", ".golangci.toml", "go.mod", ".git" },
    init_options = {
        command = {
            "/root/go/bin/golangci-lint",
            "run",
            "--output.json.path",
            "stdout",
            "--show-stats=false",
        },
    },
})

-- 启用 golangci-lint-langserver
vim.lsp.enable("golangci_lint_ls")
