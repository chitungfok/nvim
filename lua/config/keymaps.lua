local map = vim.keymap.set
map("n", "zK", function()
    require("config.folding").peek()
end, { desc = "预览折叠 / 悬浮文档（原生 API）" })

map("n", "<leader>w", "<cmd>write<cr>", { desc = "保存文件" })
map("n", "<leader>q", "<cmd>quit<cr>", { desc = "关闭窗口" })
map({ "n", "x" }, "<leader>y", '"+y', { desc = "复制到系统剪贴板" })
map({ "n", "x" }, "<leader>p", '"+p', { desc = "粘贴系统剪贴板" })

for _, direction in ipairs({ "h", "j", "k", "l" }) do
    map("n", "<leader>v" .. direction, "<C-w>" .. direction, { desc = "切换窗口 " .. direction })
end
map("n", "<leader>vs", "<cmd>split<cr>", { desc = "上下分屏" })
map("n", "<leader>vv", "<cmd>vsplit<cr>", { desc = "左右分屏" })
map("n", "<leader>v=", "<C-w>=", { desc = "均分窗口" })
map("n", "<leader>ve", "<cmd>vsplit | terminal<cr>", { desc = "打开终端" })
map("t", "<Esc><Esc>", [[<C-\><C-n>]], { desc = "退出终端输入模式" })

map("n", "[d", function()
    vim.diagnostic.jump({ count = -1, float = true })
end, { desc = "上一个诊断" })
map("n", "]d", function()
    vim.diagnostic.jump({ count = 1, float = true })
end, { desc = "下一个诊断" })
map("n", "<leader>cd", vim.diagnostic.open_float, { desc = "查看诊断详情" })

vim.api.nvim_create_user_command("Keymaps", function()
    vim.cmd.edit(vim.fn.fnameescape(vim.fn.stdpath("config") .. "/docs/keymaps.md"))
end, { desc = "打开快捷键说明" })
