-- ============================================================================
-- rust-analyzer (Rust Language Server) 配置 - Neovim 0.11+ API
-- ============================================================================

-- 获取公共配置工具函数（common 已在 lsp/init.lua 中加载）
local common = require("lsp.common")

-- Rust 文件保存时自动格式化
common.format_on_save("*.rs")

-- ============================================================================
-- rust-analyzer 配置 (使用 vim.lsp.config)
-- 注意: Neovim 0.11 内置 inlay hints，不再需要 rust-tools
-- ============================================================================
vim.lsp.config("rust_analyzer", {
    cmd = { "/root/.cargo/bin/rust-analyzer" },
    filetypes = { "rust" },
    root_markers = { "Cargo.toml", "rust-project.json", ".git" },
    settings = {
        ["rust-analyzer"] = {
            checkOnSave = {
                command = "clippy",
            },
            cargo = {
                allFeatures = true,
                loadOutDirsFromCheck = true,
            },
            procMacro = {
                enable = true,
            },
            inlayHints = {
                bindingModeHints = { enable = true },
                chainingHints = { enable = true },
                closingBraceHints = { enable = true },
                closureReturnTypeHints = { enable = "with_block" },
                lifetimeElisionHints = { enable = "skip_trivial" },
                parameterHints = { enable = true },
                typeHints = { enable = true },
            },
        },
    },
})

-- 启用 rust-analyzer
vim.lsp.enable("rust_analyzer")
