return {
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        cmd = "Neotree",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "MunifTanjim/nui.nvim",
            "nvim-tree/nvim-web-devicons",
            { "antosha417/nvim-lsp-file-operations", opts = {} },
        },
        keys = {
            { "<leader>l", "<cmd>Neotree toggle reveal<cr>", desc = "文件侧栏" },
            { "<leader>e", "<cmd>Neotree toggle reveal<cr>", desc = "文件侧栏" },
            { "<leader>fe", "<cmd>Neotree float reveal<cr>", desc = "浮动文件树" },
        },
        opts = function()
            return require("config.explorer")
        end,
        config = function(_, opts)
            local function highlights()
                vim.api.nvim_set_hl(0, "NeoTreeDirectoryIcon", { fg = "#61afef" })
                vim.api.nvim_set_hl(0, "NeoTreeDirectoryName", { fg = "#61afef" })
                vim.api.nvim_set_hl(0, "NeoTreeIndentMarker", { fg = "#3b4261" })
            end
            highlights()
            vim.api.nvim_create_autocmd("ColorScheme", {
                group = vim.api.nvim_create_augroup("UserExplorerColors", { clear = true }),
                callback = highlights,
            })
            require("neo-tree").setup(opts)
        end,
    },
    {
        "nvim-telescope/telescope.nvim",
        cmd = "Telescope",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope-live-grep-args.nvim",
            { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
        },
        keys = {
            {
                "<leader>ff",
                function()
                    require("telescope.builtin").find_files()
                end,
                desc = "查找文件",
            },
            {
                "<leader>fg",
                function()
                    require("telescope").extensions.live_grep_args.live_grep_args()
                end,
                desc = "全局搜索",
            },
            {
                "<leader>fb",
                function()
                    require("telescope.builtin").buffers()
                end,
                desc = "查找已开文件",
            },
            {
                "<leader>ft",
                function()
                    require("telescope.builtin").tags()
                end,
                desc = "查找 Tags",
            },
            {
                "<leader>/",
                function()
                    require("telescope.builtin").current_buffer_fuzzy_find()
                end,
                desc = "文件内搜索",
            },
            {
                "<leader>fc",
                function()
                    require("telescope.builtin").commands()
                end,
                desc = "命令面板",
            },
            {
                "<leader>fk",
                function()
                    require("telescope.builtin").keymaps()
                end,
                desc = "搜索快捷键",
            },
        },
        config = function()
            require("config.picker").setup()
        end,
    },
    {
        "jmacadie/telescope-hierarchy.nvim",
        dependencies = { "nvim-telescope/telescope.nvim" },
        keys = {
            { "<leader>ci", "<cmd>Telescope hierarchy incoming_calls<cr>", desc = "调用树：谁调用它" },
            { "<leader>co", "<cmd>Telescope hierarchy outgoing_calls<cr>", desc = "调用树：它调用谁" },
        },
        opts = {
            extensions = {
                hierarchy = {
                    -- 先展示三层，更深的分支由用户展开，避免查询整个项目。
                    initial_multi_expand = true,
                    multi_depth = 3,
                    layout_strategy = "horizontal",
                    mappings = {
                        -- 保留 Enter 的接受行为，并避开终端的 Ctrl-s 流控键。
                        i = { ["<c-m>"] = false, ["<c-s>"] = false },
                    },
                },
            },
        },
        config = function(_, opts)
            require("telescope").setup(opts)
            require("telescope").load_extension("hierarchy")
        end,
    },
    {
        "folke/flash.nvim",
        keys = {
            {
                "<leader>jj",
                function()
                    require("flash").jump()
                end,
                mode = { "n", "x", "o" },
                desc = "Flash 跳转",
            },
            {
                "<leader>jt",
                function()
                    require("flash").treesitter()
                end,
                mode = { "n", "x", "o" },
                desc = "Flash 语法选择",
            },
            {
                "<leader>jr",
                function()
                    require("flash").remote()
                end,
                mode = "o",
                desc = "Flash 远程操作",
            },
        },
        opts = { modes = { char = { enabled = false }, search = { enabled = false } } },
    },
}
