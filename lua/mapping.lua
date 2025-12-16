-- ============================================================================
-- 键位映射配置
-- ============================================================================
-- 注意: mapleader 已在 basic.lua 中设置 (必须在 lazy.nvim 加载前)
--
-- 完整按键参考: lua/keymaps-reference.lua (包含所有插件内部按键)
-- 查看帮助方式:
--   <leader>? - which-key 全局帮助
--   ?         - Neo-tree/Trouble 内部帮助
--   <C-/>     - Telescope 帮助 (Insert 模式)
--
-- 按键设计原则:
--   <leader>w/q/d  - 基础操作 (保存/退出/关闭buffer)
--   <leader>l      - 文件树 (fiLe tree)
--   <leader>f*     - 搜索 (Find)
--   <leader>/      - Buffer 内搜索
--   <leader>b*     - Buffer 管理
--   <leader>c*     - 代码操作 (Code, LSP) - 见 lsp/common.lua
--   <leader>g*     - Git 操作
--   <leader>x*     - 诊断/问题 (Trouble)
--   <leader>t*     - 测试 (Test) - Go 测试生成
--   <leader>1-9    - 快速跳转 Buffer
--   <leader>?      - Which-key 帮助
--   gd/gr/gi/gD    - LSP 跳转 - 见 lsp/common.lua
--   gt/gT          - Tab 切换 (Vim 原生)
--   z*             - 代码折叠 (nvim-ufo): zR/zM/zr/zm/zK

-- ============================================================================
-- 基础操作
-- ============================================================================
vim.keymap.set("v", "<C-c>", '"+y', { desc = "Copy to clipboard" })
vim.keymap.set("v", "<C-v>", '"+p', { desc = "Paste from clipboard" })
vim.keymap.set("n", "<leader>w", "<cmd>w<cr>", { desc = "Save file" })
vim.keymap.set("n", "<leader>q", "<cmd>q<cr>", { desc = "Quit" })

-- ============================================================================
-- 窗口导航 (C-h/j/k/l)
-- ============================================================================
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Window left" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Window down" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Window up" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Window right" })

-- ============================================================================
-- 搜索 (Telescope) - <leader>f
-- ============================================================================
vim.keymap.set("n", "<leader>ff", function()
    require("telescope.builtin").find_files()
end, { desc = "Find files" })
vim.keymap.set("n", "<leader>fg", function()
    require("telescope").extensions.live_grep_args.live_grep_args()
end, { desc = "Find by grep" })
vim.keymap.set("n", "<leader>fb", function()
    require("telescope.builtin").buffers()
end, { desc = "Find buffers" })
vim.keymap.set("n", "<leader>ft", function()
    require("telescope.builtin").tags()
end, { desc = "Find tags" })
vim.keymap.set("n", "<leader>/", function()
    require("telescope.builtin").current_buffer_fuzzy_find()
end, { desc = "Search in buffer" })

-- ============================================================================
-- Git (gitsigns) - <leader>g
-- ============================================================================
vim.keymap.set("n", "]h", function()
    require("gitsigns").next_hunk()
end, { desc = "Next hunk" })
vim.keymap.set("n", "[h", function()
    require("gitsigns").prev_hunk()
end, { desc = "Previous hunk" })
vim.keymap.set("n", "<leader>gd", function()
    require("gitsigns").diffthis()
end, { desc = "Diff this" })
vim.keymap.set("n", "<leader>gn", function()
    require("gitsigns").next_hunk()
end, { desc = "Next hunk" })
vim.keymap.set("n", "<leader>gp", function()
    require("gitsigns").preview_hunk()
end, { desc = "Preview hunk" })
vim.keymap.set("n", "<leader>gr", function()
    require("gitsigns").reset_hunk()
end, { desc = "Reset hunk" })
vim.keymap.set("n", "<leader>gs", function()
    require("gitsigns").stage_hunk()
end, { desc = "Stage hunk" })

-- ============================================================================
-- 代码导航 (Navbuddy) - <leader>c
-- ============================================================================
vim.keymap.set("n", "<leader>cn", function()
    require("nvim-navbuddy").open()
end, { desc = "Code navigation (Navbuddy)" })

-- ============================================================================
-- Trouble (诊断面板) - <leader>x
-- ============================================================================
vim.keymap.set("n", "<leader>xx", "<cmd>Trouble diagnostics toggle focus=true<cr>", { desc = "Diagnostics" })
vim.keymap.set("n", "<leader>xs", "<cmd>Trouble symbols toggle focus=true<cr>", { desc = "Symbols" })
vim.keymap.set("n", "<leader>xq", "<cmd>Trouble qflist toggle<cr>", { desc = "Quickfix list" })
vim.keymap.set("n", "<leader>xl", "<cmd>Trouble loclist toggle<cr>", { desc = "Location list" })

-- ============================================================================
-- 代码折叠 (nvim-ufo) - z 前缀 (符合 Vim 折叠习惯)
-- ============================================================================
vim.keymap.set("n", "zR", function()
    require("ufo").openAllFolds()
end, { desc = "Open all folds" })
vim.keymap.set("n", "zM", function()
    require("ufo").closeAllFolds()
end, { desc = "Close all folds" })
vim.keymap.set("n", "zr", function()
    require("ufo").openFoldsExceptKinds()
end, { desc = "Fold less" })
vim.keymap.set("n", "zm", function()
    require("ufo").closeFoldsWith()
end, { desc = "Fold more" })
vim.keymap.set("n", "zK", function()
    local winid = require("ufo").peekFoldedLinesUnderCursor()
    if not winid then
        vim.lsp.buf.hover()
    end
end, { desc = "Peek fold" })

-- ============================================================================
-- Go 测试生成 (gotests.nvim) - <leader>t (Test)
-- ============================================================================
vim.keymap.set("n", "<leader>tt", function()
    require("gotests").generate()
end, { desc = "Generate test for function" })
vim.keymap.set("n", "<leader>ta", function()
    require("gotests").generate_all()
end, { desc = "Generate tests for all functions" })

-- ============================================================================
-- Buffer 管理 (Bufferline) - <leader>b 和 <leader>1-9
-- ============================================================================
-- 快速跳转到指定 buffer
for i = 1, 9 do
    vim.keymap.set("n", "<leader>" .. i, function()
        require("bufferline").go_to_buffer(i, true)
    end, { desc = "Buffer " .. i })
end

-- Buffer 导航
vim.keymap.set("n", "<leader>bp", "<cmd>BufferLineCyclePrev<cr>", { desc = "Previous buffer" })
vim.keymap.set("n", "<leader>bn", "<cmd>BufferLineCycleNext<cr>", { desc = "Next buffer" })
vim.keymap.set("n", "<leader>bh", "<cmd>BufferLineMovePrev<cr>", { desc = "Move buffer left" })
vim.keymap.set("n", "<leader>bl", "<cmd>BufferLineMoveNext<cr>", { desc = "Move buffer right" })

-- 关闭当前 buffer (保存后自动跳转到前一个)
vim.keymap.set("n", "<leader>d", function()
    if vim.bo.modified then
        vim.cmd.write()
    end
    local buf = vim.fn.bufnr()
    require("bufferline").cycle(-1)
    vim.cmd.bdelete(buf)
end, { desc = "Close buffer" })

-- ============================================================================
-- 按键帮助命令
-- ============================================================================
-- :Keymaps - 打开按键映射参考文档
vim.api.nvim_create_user_command("Keymaps", function()
    vim.cmd("edit " .. vim.fn.stdpath("config") .. "/lua/keymaps-reference.lua")
end, { desc = "Open keymaps reference" })

-- ============================================================================
-- 导出配置 (供插件配置使用)
-- ============================================================================
local M = {}

-- Telescope 内部映射
M.telescope = function()
    return {
        i = {
            ["<C-j>"] = "move_selection_next",
            ["<C-k>"] = "move_selection_previous",
            ["<C-s>"] = "file_split",
            ["<C-v>"] = "file_vsplit",
            ["<C-t>"] = function(...)
                require("trouble.sources.telescope").open(...)
            end,
        },
    }
end

return M
