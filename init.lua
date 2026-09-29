if vim.fn.has("nvim-0.12") == 0 then
    error("此配置需要 Neovim 0.12 或更新版本")
end

require("config.options")
require("config.autocmds")
require("config.folding").setup()
require("config.keymaps")
require("config.lazy")
require("config.lsp")
