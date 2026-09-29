return {
    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        event = { "BufReadPost", "BufNewFile" },
        opts = {},
    },
    {
        "saghen/blink.pairs",
        version = "*",
        event = "InsertEnter",
        dependencies = { "saghen/blink.lib" },
        build = function()
            require("blink.pairs").download():pwait(60000)
        end,
        opts = {
            mappings = { enabled = true, wrap = { ["<C-b>"] = false, ["<C-S-b>"] = false } },
            highlights = { enabled = true },
        },
    },
}
