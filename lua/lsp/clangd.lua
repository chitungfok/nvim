-- ============================================================================
-- clangd (C/C++ Language Server) 配置 - Neovim 0.11+ API
-- ============================================================================
-- 注意: common 已在 lsp/init.lua 中加载

-- ============================================================================
-- clangd 配置 (使用 vim.lsp.config)
-- ============================================================================
vim.lsp.config("clangd", {
    cmd = {
        "/usr/bin/clangd",
        "--background-index",
        "--compile-commands-dir=build",
        "-j=4",
        "--query-driver=/usr/bin/clang++",
        "--clang-tidy",
        "--all-scopes-completion",
        "--completion-style=detailed",
        "--header-insertion=iwyu",
        "--pch-storage=disk",
        "--offset-encoding=utf-16",
    },
    filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
    root_markers = {
        ".clangd",
        ".clang-tidy",
        ".clang-format",
        "compile_commands.json",
        "compile_flags.txt",
        "configure.ac",
        ".git",
    },
})

-- 启用 clangd
vim.lsp.enable("clangd")
