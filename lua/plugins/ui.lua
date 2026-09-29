local buffers = {
    { "<leader>bp", "<cmd>BufferLineCyclePrev<cr>", desc = "上一个文件" },
    { "<leader>bn", "<cmd>BufferLineCycleNext<cr>", desc = "下一个文件" },
    { "<leader>bh", "<cmd>BufferLineMovePrev<cr>", desc = "标签左移" },
    { "<leader>bl", "<cmd>BufferLineMoveNext<cr>", desc = "标签右移" },
    {
        "<leader>d",
        function()
            if vim.bo.modified then
                vim.cmd.write()
            end
            local buffer = vim.api.nvim_get_current_buf()
            require("bufferline").cycle(-1)
            vim.cmd.bdelete(buffer)
        end,
        desc = "保存并关闭文件",
    },
}
for index = 1, 9 do
    buffers[#buffers + 1] = {
        "<leader>" .. index,
        function()
            require("bufferline").go_to_buffer(index, true)
        end,
        desc = "文件 " .. index,
    }
end

return {
    {
        "olimorris/onedarkpro.nvim",
        lazy = false,
        priority = 1000,
        opts = {
            highlights = {
                MinuetVirtualText = { fg = "${purple}", italic = true },
                TroubleNormal = { link = "NormalFloat" },
                TroubleNormalNC = { link = "NormalFloat" },
                -- 缩进线和位置标记只设前景色，避免继承行号区的底色。
                TroubleIndent = { fg = "${line_number}", bg = "NONE" },
                TroubleIndentFoldClosed = { fg = "${purple}", bg = "NONE" },
                TroublePos = { fg = "${line_number}", bg = "NONE" },
                TroubleIconFile = { fg = "${fg}", bg = "NONE" },
                -- 路径和结果计数沿用浮窗背景，避免继承行号区和 NonText 的底色。
                TelescopeResultsLineNr = { fg = "${line_number}", bg = "NONE" },
                TelescopePromptCounter = { fg = "${gray}", bg = "NONE" },
            },
        },
        config = function(_, opts)
            require("onedarkpro").setup(opts)
            vim.cmd.colorscheme("onedark_vivid")
        end,
    },
    { "nvim-tree/nvim-web-devicons", opts = {} },
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        keys = {
            {
                "<leader>?",
                function()
                    require("which-key").show({ global = true })
                end,
                desc = "快捷键帮助",
            },
        },
        opts = {
            delay = 300,
            icons = { mappings = false },
            spec = {
                { "<leader>a", group = "AI 补全" },
                { "<leader>b", group = "文件标签" },
                { "<leader>c", group = "代码" },
                { "<leader>f", group = "查找" },
                { "<leader>g", group = "Git" },
                { "<leader>j", group = "Flash 跳转" },
                { "<leader>t", group = "测试" },
                { "<leader>v", group = "窗口" },
                { "<leader>x", group = "问题面板" },
                -- 只补充提示，不覆盖原生操作符和计数行为。
                { "gc", group = "注释（原生）", mode = "n" },
                { "gcc", desc = "切换当前行注释（原生）", mode = "n" },
                { "gc", desc = "切换所选行注释（原生）", mode = "x" },
                { "z", group = "折叠 / 视图（原生）", mode = "n" },
                { "za", desc = "切换当前折叠（原生）" },
                { "zA", desc = "递归切换当前折叠（原生）" },
                { "zo", desc = "展开当前折叠一层（原生）" },
                { "zO", desc = "递归展开当前折叠（原生）" },
                { "zc", desc = "收起当前折叠一层（原生）" },
                { "zC", desc = "递归收起当前折叠（原生）" },
                { "zr", desc = "减少折叠层级（原生）" },
                { "zm", desc = "增加折叠层级（原生）" },
                { "zR", desc = "展开全部折叠（原生）" },
                { "zM", desc = "收起全部折叠（原生）" },
            },
        },
    },
    {
        "nvim-lualine/lualine.nvim",
        event = "VeryLazy",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        opts = function()
            return require("config.statusline")
        end,
    },
    {
        "akinsho/bufferline.nvim",
        version = "*",
        event = "VeryLazy",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        keys = buffers,
        opts = function()
            return {
                options = {
                    -- 统一标签和空白区的背景，选中状态仍由文字和标记区分。
                    style_preset = require("bufferline").style_preset.minimal,
                    diagnostics = "nvim_lsp",
                    offsets = { { filetype = "neo-tree", text = "文件", text_align = "left" } },
                },
            }
        end,
    },
    {
        "folke/trouble.nvim",
        cmd = "Trouble",
        keys = {
            { "<leader>cn", "<cmd>Trouble symbols open focus=true<cr>", desc = "代码结构（Trouble）" },
            { "<leader>xx", "<cmd>Trouble diagnostics toggle focus=true<cr>", desc = "诊断面板" },
            { "<leader>xs", "<cmd>Trouble symbols toggle focus=true<cr>", desc = "符号面板" },
            { "<leader>xq", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix 列表" },
            { "<leader>xl", "<cmd>Trouble loclist toggle<cr>", desc = "Location 列表" },
        },
        opts = {
            focus = true,
            modes = {
                symbols = { win = { size = 50, wo = { wrap = true } }, format = "{kind_icon} {symbol.name}" },
            },
        },
    },
}
