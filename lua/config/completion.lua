local ai = require("config.ai")

local function cycle_ai(cmp, direction)
    if not ai.eligible() then
        return false
    end
    local action = require("minuet.virtualtext").action[direction]
    -- Minuet 会隐藏菜单打开时的行内建议，手动请求前先收起菜单。
    if not cmp.hide({ callback = action }) then
        action()
    end
    return true
end

return {
    keymap = {
        preset = "none",
        -- Tab 先接受可见的 AI 建议，再处理菜单、占位符和缩进。
        ["<Tab>"] = {
            ai.accept,
            function(cmp)
                if cmp.snippet_active() then
                    return cmp.accept()
                end
                return cmp.select_and_accept()
            end,
            "snippet_forward",
            "fallback",
        },
        ["<S-Tab>"] = { "snippet_backward", "select_prev", "fallback" },
        ["<CR>"] = { "accept", "fallback" },
        ["<Down>"] = { "select_next", "fallback" },
        ["<Up>"] = { "select_prev", "fallback" },
        ["<C-n>"] = { "select_next", "show", "fallback" },
        ["<C-p>"] = { "select_prev", "fallback" },
        ["<C-j>"] = { "select_next", "fallback" },
        ["<C-k>"] = { "select_prev", "fallback" },
        ["<C-e>"] = {
            function()
                ai.dismiss()
            end,
            "cancel",
            "fallback",
        },
        ["<C-y>"] = {
            function()
                local vt = package.loaded["minuet.virtualtext"]
                if vt and vt.action.is_visible() then
                    vt.action.accept_line()
                    return true
                end
            end,
            "fallback",
        },
        ["<C-g>n"] = {
            function(cmp)
                return cycle_ai(cmp, "next")
            end,
            "fallback",
        },
        ["<C-g>p"] = {
            function(cmp)
                return cycle_ai(cmp, "prev")
            end,
            "fallback",
        },
        ["<PageDown>"] = { "scroll_documentation_down", "fallback" },
        ["<PageUp>"] = { "scroll_documentation_up", "fallback" },
    },
    sources = {
        default = { "lsp", "path", "snippets", "buffer" },
        providers = {
            lsp = { name = "LSP", score_offset = 10 },
            path = { name = "路径", score_offset = 5 },
            snippets = { name = "片段" },
            buffer = { name = "缓冲区", score_offset = -3, min_keyword_length = 3 },
            cmdline = { name = "命令" },
        },
    },
    completion = {
        accept = { auto_brackets = { enabled = true } },
        list = { selection = { preselect = false, auto_insert = false } },
        menu = {
            border = "rounded",
            draw = {
                columns = { { "kind_icon" }, { "label", "label_description", gap = 1 }, { "source_name" } },
                components = {
                    source_name = {
                        text = function(context)
                            return "[" .. context.source_name .. "]"
                        end,
                    },
                },
            },
        },
        documentation = { auto_show = true, auto_show_delay_ms = 200, window = { border = "rounded" } },
        ghost_text = { enabled = false },
    },
    signature = { enabled = true, window = { border = "rounded" } },
    appearance = { nerd_font_variant = "mono" },
    fuzzy = { implementation = "prefer_rust_with_warning" },
    cmdline = {
        keymap = {
            preset = "none",
            ["<Tab>"] = { "show_and_insert_or_accept_single", "select_next" },
            ["<S-Tab>"] = { "select_prev", "fallback" },
            ["<CR>"] = { "accept_and_enter", "fallback" },
            ["<Down>"] = { "select_next", "fallback" },
            ["<Up>"] = { "select_prev", "fallback" },
            ["<C-j>"] = { "select_next", "fallback" },
            ["<C-k>"] = { "select_prev", "fallback" },
            ["<C-n>"] = { "select_next", "show", "fallback" },
            ["<C-p>"] = { "select_prev", "fallback" },
        },
    },
}
