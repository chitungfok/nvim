-- ============================================================================
-- gopls (Go Language Server) 配置 - Neovim 0.11+ API
-- ============================================================================

-- 获取公共配置工具函数（common 已在 lsp/init.lua 中加载）
local common = require("lsp.common")

-- Go 文件保存时自动整理 imports 并格式化
common.format_on_save("*.go", true)

-- ============================================================================
-- gopls 配置 (使用 vim.lsp.config)
-- ============================================================================
vim.lsp.config("gopls", {
    cmd = { "/root/go/bin/gopls", "serve" },
    filetypes = { "go", "gomod", "gowork", "gotmpl" },
    root_markers = { "go.work", "go.mod", ".git" },
    settings = {
        gopls = {
            gofumpt = true,
            semanticTokens = true,
            usePlaceholders = true,
            completeUnimported = true,
            staticcheck = true,
            analyses = {
                unusedparams = true,
                shadow = true,
                nilness = true,
                unusedwrite = true,
                useany = true,
            },
            hints = {
                assignVariableTypes = true,
                compositeLiteralFields = true,
                compositeLiteralTypes = true,
                constantValues = true,
                functionTypeParameters = true,
                parameterNames = true,
                rangeVariableTypes = true,
            },
        },
    },
})

-- 启用 gopls
vim.lsp.enable("gopls")
