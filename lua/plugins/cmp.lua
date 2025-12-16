-- ============================================================================
-- blink.cmp 补全配置 (替代 nvim-cmp)
-- ============================================================================
-- 特点:
-- - 内置 LSP、path、buffer、snippets 源
-- - 使用 Neovim 0.10+ 原生 vim.snippet API
-- - Rust 编写的模糊匹配，性能更好
-- ============================================================================

require("blink.cmp").setup({
    -- ========================================================================
    -- 键位映射
    -- ========================================================================
    keymap = {
        preset = "none",
        ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
        ["<C-e>"] = { "cancel", "fallback" },
        ["<CR>"] = { "accept", "fallback" },
        ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
        ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
        ["<Down>"] = { "select_next", "fallback" },
        ["<Up>"] = { "select_prev", "fallback" },
        ["<C-j>"] = { "select_next", "fallback" },
        ["<C-k>"] = { "select_prev", "fallback" },
        ["<C-n>"] = { "select_next", "fallback" },
        ["<C-p>"] = { "select_prev", "fallback" },
        ["<C-d>"] = { "scroll_documentation_down", "fallback" },
        ["<C-u>"] = { "scroll_documentation_up", "fallback" },
    },

    -- ========================================================================
    -- 补全源配置
    -- ========================================================================
    sources = {
        default = { "lsp", "path", "buffer" },
        providers = {
            lsp = {
                score_offset = 10, -- LSP 优先
            },
            path = {
                score_offset = 5,
            },
            buffer = {
                score_offset = -3,
                min_keyword_length = 3,
            },
        },
    },

    -- ========================================================================
    -- 补全菜单外观
    -- ========================================================================
    completion = {
        list = {
            selection = {
                preselect = true,
                auto_insert = false,
            },
        },
        menu = {
            border = "rounded",
            draw = {
                columns = {
                    { "kind_icon" },
                    { "label", "label_description", gap = 1 },
                },
                treesitter = { "lsp" },
            },
        },
        documentation = {
            auto_show = true,
            auto_show_delay_ms = 200,
            window = {
                border = "rounded",
            },
        },
        ghost_text = {
            enabled = false,
        },
    },

    -- ========================================================================
    -- 签名帮助
    -- ========================================================================
    signature = {
        enabled = true,
        window = {
            border = "rounded",
        },
    },

    -- ========================================================================
    -- 外观
    -- ========================================================================
    appearance = {
        use_nvim_cmp_as_default = false,
        nerd_font_variant = "mono",
    },
})
