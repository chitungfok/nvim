return {
    {
        "lewis6991/gitsigns.nvim",
        event = { "BufReadPost", "BufNewFile" },
        keys = {
            {
                "]h",
                function()
                    require("gitsigns").nav_hunk("next")
                end,
                desc = "下一个修改块",
            },
            {
                "[h",
                function()
                    require("gitsigns").nav_hunk("prev")
                end,
                desc = "上一个修改块",
            },
            {
                "<leader>gn",
                function()
                    require("gitsigns").nav_hunk("next")
                end,
                desc = "下一个修改块",
            },
            {
                "<leader>gd",
                function()
                    require("gitsigns").diffthis()
                end,
                desc = "查看文件差异",
            },
            {
                "<leader>gp",
                function()
                    require("gitsigns").preview_hunk()
                end,
                desc = "预览修改块",
            },
            {
                "<leader>gr",
                function()
                    require("gitsigns").reset_hunk()
                end,
                desc = "重置修改块",
            },
            {
                "<leader>gs",
                function()
                    require("gitsigns").stage_hunk()
                end,
                desc = "暂存修改块",
            },
        },
        opts = { signcolumn = true, numhl = true, current_line_blame = true },
    },
}
