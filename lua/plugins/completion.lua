return {
    {
        "saghen/blink.cmp",
        version = "1.*",
        event = "InsertEnter",
        opts = function()
            return require("config.completion")
        end,
    },
    {
        "milanglacier/minuet-ai.nvim",
        event = "InsertEnter",
        cmd = "Minuet",
        keys = {
            {
                "<leader>at",
                function()
                    require("config.ai").run("virtualtext toggle")
                end,
                desc = "切换自动续写",
            },
            {
                "<leader>ap",
                function()
                    require("config.ai").run("duet predict")
                end,
                desc = "预测下一处编辑",
            },
            {
                "<leader>aa",
                function()
                    require("config.ai").run("duet apply")
                end,
                desc = "接受编辑预览",
            },
            {
                "<leader>ad",
                function()
                    require("config.ai").dismiss()
                end,
                desc = "取消 AI 建议",
            },
            {
                "<leader>an",
                function()
                    require("config.ai").run("duet toggle")
                end,
                desc = "切换自动编辑预测",
            },
        },
        opts = function()
            return require("config.ai").options()
        end,
        config = function(_, options)
            require("config.ai").setup(options)
        end,
    },
}
