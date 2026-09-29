local ai = require("config.ai")
ai.setup_status()

return {
    options = {
        theme = "onedark",
        globalstatus = true,
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
        disabled_filetypes = {
            statusline = { "neo-tree", "lazy", "mason" },
        },
    },
    sections = {
        lualine_a = { "mode" },
        lualine_b = {
            { "branch", icon = "" },
            {
                "diff",
                symbols = { added = " ", modified = " ", removed = " " },
            },
        },
        lualine_c = {
            {
                "filename",
                path = 1,
                symbols = { modified = " ●", readonly = " ", unnamed = "[No Name]" },
            },
        },
        lualine_x = {
            { ai.indicator, color = { gui = "bold" } },
            {
                "diagnostics",
                sources = { "nvim_lsp" },
                symbols = { error = " ", warn = " ", info = " ", hint = "󰌵 " },
            },
            "encoding",
            { "fileformat", icons_enabled = true },
            { "filetype", icon_only = false },
        },
        lualine_y = { "progress" },
        lualine_z = { "location" },
    },
    inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { { "filename", path = 1 } },
        lualine_x = { "location" },
        lualine_y = {},
        lualine_z = {},
    },
    extensions = { "neo-tree", "lazy", "trouble" },
}
