local M = {}

function M.setup()
    local actions = require("telescope.actions")
    local maps = {
        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,
        ["<C-s>"] = false,
        ["<C-q>"] = false,
        ["<C-u>"] = false,
        ["<C-d>"] = false,
        ["<C-v>"] = false,
        ["<C-t>"] = false,
        ["<C-x>"] = actions.select_horizontal,
        ["<C-w>"] = actions.select_vertical,
        ["<C-g>"] = function(...)
            require("trouble.sources.telescope").open(...)
        end,
        ["<PageDown>"] = actions.preview_scrolling_down,
        ["<PageUp>"] = actions.preview_scrolling_up,
    }
    local fd = vim.fn.executable("fd") == 1 and "fd" or "fdfind"
    local find = vim.fn.executable(fd) == 1
            and { fd, "--type", "f", "--hidden", "--exclude", ".git", "--strip-cwd-prefix" }
        or { "rg", "--files", "--hidden", "--glob", "!.git" }
    require("telescope").setup({
        defaults = {
            mappings = { i = maps },
            vimgrep_arguments = {
                "rg",
                "--color=never",
                "--no-heading",
                "--with-filename",
                "--line-number",
                "--column",
                "--smart-case",
                "--hidden",
                "--glob=!.git/",
            },
        },
        pickers = { find_files = { find_command = find } },
    })
    -- fzf 原生库未编译时，Telescope 使用自带的 Lua 排序。
    pcall(require("telescope").load_extension, "fzf")
    require("telescope").load_extension("live_grep_args")
end

return M
