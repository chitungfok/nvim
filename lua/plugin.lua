-- ============================================================================
-- 插件管理 (lazy.nvim) - Neovim 0.11+
-- ============================================================================
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- ============================================================================
-- 插件列表
-- ============================================================================
local plugins = {
    -- ========================================================================
    -- 核心依赖
    -- ========================================================================
    "nvim-lua/plenary.nvim",
    {
        "nvim-tree/nvim-web-devicons",
        lazy = false,
        config = true,
    },
    {
        "echasnovski/mini.icons",
        lazy = true,
        opts = {},
    },
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        dependencies = { "echasnovski/mini.icons" },
        keys = {
            {
                "<leader>?",
                function()
                    require("which-key").show({ global = true })
                end,
                desc = "Keymaps (which-key)",
            },
        },
        opts = {
            delay = 300,
            icons = {
                mappings = true, -- 启用映射图标 (由 mini.icons 提供)
                colors = true, -- 使用 mini.icons 的颜色高亮
                keys = {
                    Up = " ",
                    Down = " ",
                    Left = " ",
                    Right = " ",
                    C = "󰘴 ",
                    M = "󰘵 ",
                    D = "󰘳 ",
                    S = "󰘶 ",
                    CR = "󰌑 ",
                    Esc = "󱊷 ",
                    ScrollWheelDown = "󱕐 ",
                    ScrollWheelUp = "󱕑 ",
                    NL = "󰌑 ",
                    BS = "󰁮",
                    Space = "󱁐 ",
                    Tab = "󰌒 ",
                    F1 = "󱊫",
                    F2 = "󱊬",
                    F3 = "󱊭",
                    F4 = "󱊮",
                    F5 = "󱊯",
                    F6 = "󱊰",
                    F7 = "󱊱",
                    F8 = "󱊲",
                    F9 = "󱊳",
                    F10 = "󱊴",
                    F11 = "󱊵",
                    F12 = "󱊶",
                },
            },
            spec = {
                { "<leader>a", group = "AI" },
                { "<leader>b", group = "Buffer" },
                { "<leader>c", group = "Code" },
                { "<leader>f", group = "Find" },
                { "<leader>g", group = "Git" },
                { "<leader>t", group = "Test" },
                { "<leader>x", group = "Trouble" },
            },
        },
    },

    -- ========================================================================
    -- 文件导航与搜索
    -- ========================================================================
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        cmd = "Neotree",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "MunifTanjim/nui.nvim",
            -- 文件操作增强
            {
                "antosha417/nvim-lsp-file-operations",
                config = true,
            },
        },
        keys = {
            { "<leader>l", "<cmd>Neotree toggle reveal<cr>", desc = "File tree (reveal)" },
        },
        opts = function()
            return require("plugins.neo-tree")
        end,
        config = function(_, opts)
            -- 设置 Neo-tree 高亮（文件夹图标蓝色）
            vim.api.nvim_set_hl(0, "NeoTreeDirectoryIcon", { fg = "#61afef" }) -- 蓝色
            vim.api.nvim_set_hl(0, "NeoTreeDirectoryName", { fg = "#61afef" }) -- 蓝色
            vim.api.nvim_set_hl(0, "NeoTreeIndentMarker", { fg = "#3b4261" }) -- 缩进线颜色
            require("neo-tree").setup(opts)
        end,
    },
    {
        -- 重命名增强（支持 LSP 重命名）
        "folke/snacks.nvim",
        priority = 1000,
        lazy = false,
        opts = {
            rename = { enabled = true },
        },
    },
    {
        "nvim-telescope/telescope.nvim",
        cmd = "Telescope",
        dependencies = {
            "nvim-telescope/telescope-live-grep-args.nvim",
            {
                "nvim-telescope/telescope-fzf-native.nvim",
                build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release --target install",
            },
        },
        config = function()
            require("telescope").setup({
                defaults = {
                    initial_mode = "insert",
                    mappings = require("mapping").telescope(),
                    -- 使用 rg 进行文件内容搜索（默认配置，显式声明）
                    vimgrep_arguments = {
                        "rg",
                        "--color=never",
                        "--no-heading",
                        "--with-filename",
                        "--line-number",
                        "--column",
                        "--smart-case",
                        "--hidden", -- 搜索隐藏文件
                        "--glob=!.git/", -- 排除 .git 目录
                    },
                },
                pickers = {
                    find_files = {
                        -- 使用 fd 进行文件查找（性能优于默认的 find）
                        find_command = {
                            "fd",
                            "--type",
                            "f",
                            "--hidden", -- 包含隐藏文件
                            "--exclude",
                            ".git", -- 排除 .git 目录
                            "--strip-cwd-prefix",
                        },
                    },
                },
            })
            require("telescope").load_extension("fzf")
            require("telescope").load_extension("live_grep_args")
        end,
    },
    {
        "SmiteshP/nvim-navbuddy",
        dependencies = { "SmiteshP/nvim-navic", "MunifTanjim/nui.nvim" },
        event = "LspAttach",
    },

    -- ========================================================================
    -- 编辑增强
    -- ========================================================================
    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        event = "BufRead",
        config = function()
            vim.opt.list = true
            vim.opt.listchars:append("space:⋅")
            vim.opt.listchars:append("eol:↴")
            require("ibl").setup()
        end,
    },
    {
        "numToStr/Comment.nvim",
        keys = { "gcc", "gbc", { "gc", mode = "v" }, { "gb", mode = "v" } },
        config = true,
    },
    {
        "kevinhwang91/nvim-ufo",
        dependencies = { "kevinhwang91/promise-async" },
        event = "BufRead",
        config = function()
            vim.o.foldcolumn = "1"
            vim.o.foldlevel = 99
            vim.o.foldlevelstart = 99
            vim.o.foldenable = true

            local handler = function(virtText, lnum, endLnum, width, truncate)
                local newVirtText = {}
                local suffix = ("  %d "):format(endLnum - lnum)
                local sufWidth = vim.fn.strdisplaywidth(suffix)
                local targetWidth = width - sufWidth
                local curWidth = 0

                for _, chunk in ipairs(virtText) do
                    local chunkText = chunk[1]
                    local chunkWidth = vim.fn.strdisplaywidth(chunkText)
                    if targetWidth > curWidth + chunkWidth then
                        table.insert(newVirtText, chunk)
                    else
                        chunkText = truncate(chunkText, targetWidth - curWidth)
                        table.insert(newVirtText, { chunkText, chunk[2] })
                        chunkWidth = vim.fn.strdisplaywidth(chunkText)
                        if curWidth + chunkWidth < targetWidth then
                            suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
                        end
                        break
                    end
                    curWidth = curWidth + chunkWidth
                end
                table.insert(newVirtText, { suffix, "MoreMsg" })
                return newVirtText
            end

            require("ufo").setup({
                provider_selector = function()
                    return { "lsp", "indent" }
                end,
                fold_virt_text_handler = handler,
            })
        end,
    },

    -- ========================================================================
    -- UI 增强
    -- ========================================================================
    {
        "nvim-lualine/lualine.nvim",
        event = "VeryLazy",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        opts = function()
            return require("plugins.lualine")
        end,
    },
    {
        "akinsho/bufferline.nvim",
        version = "*",
        event = "BufAdd",
        opts = {
            options = {
                diagnostics = "nvim_lsp",
                offsets = {
                    { filetype = "neo-tree", text = "File Explorer", highlight = "Directory", text_align = "left" },
                },
            },
        },
    },
    {
        "folke/trouble.nvim",
        cmd = "Trouble",
        opts = {
            defaults = { focus = true },
            modes = {
                symbols = {
                    win = {
                        size = 50,
                        wo = {
                            wrap = true,
                        },
                    },
                    format = "{kind_icon} {symbol.name}",
                },
            },
        },
    },

    -- ========================================================================
    -- Git 集成
    -- ========================================================================
    {
        "lewis6991/gitsigns.nvim",
        event = "BufRead",
        opts = {
            signcolumn = true,
            numhl = true,
            current_line_blame = true,
        },
    },

    -- ========================================================================
    -- 补全 (blink.cmp - 高性能补全引擎)
    -- ========================================================================
    {
        "saghen/blink.cmp",
        version = "1.*",
        event = "InsertEnter",
        config = function()
            require("plugins.cmp")
        end,
    },
    {
        "saghen/blink.pairs",
        version = "*",
        event = "InsertEnter",
        dependencies = "saghen/blink.download",
        opts = {
            mappings = { enabled = true },
            highlights = { enabled = true },
        },
    },

    -- ========================================================================
    -- AI 补全 (Minuet - DeepSeek Virtual Text)
    -- ========================================================================
    {
        "milanglacier/minuet-ai.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        event = "InsertEnter",
        config = function()
            require("minuet").setup(require("plugins.minuet").opts)
        end,
    },

    -- ========================================================================
    -- 语言支持
    -- ========================================================================
    {
        "yanskun/gotests.nvim",
        ft = "go",
        config = true,
    },

    -- ========================================================================
    -- 主题
    -- ========================================================================
    {
        "olimorris/onedarkpro.nvim",
        lazy = false,
        priority = 1000,
    },
}

-- ============================================================================
-- lazy.nvim 配置
-- ============================================================================
return require("lazy").setup(plugins, {
    defaults = {
        lazy = true, -- 默认延迟加载
    },
    performance = {
        cache = {
            enabled = true,
        },
        rtp = {
            disabled_plugins = {
                "gzip",
                "matchit",
                "matchparen",
                "netrwPlugin",
                "tarPlugin",
                "tohtml",
                "tutor",
                "zipPlugin",
            },
        },
    },
})
