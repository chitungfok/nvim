-- ============================================================================
-- 基础配置 (使用 vim.opt 统一设置)
-- ============================================================================

-- Leader 键 (必须在 lazy.nvim 加载前设置)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- 编码设置
vim.opt.encoding = "UTF-8"
vim.opt.fileencoding = "utf-8"

-- 外观
vim.opt.background = "dark"
vim.opt.termguicolors = true
vim.opt.number = true
vim.opt.signcolumn = "yes"
-- vim.opt.cmdheight = 0 -- 隐藏命令行区域，需要时自动显示
vim.opt.laststatus = 3 -- 全局状态栏（配合 lualine globalstatus）

-- 缩进
vim.opt.cindent = true
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.tabstop = 4

-- 搜索
vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- 文件处理
vim.opt.autoread = true
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.swapfile = false
vim.opt.undofile = true

-- 外部文件变化自动重载
-- autoread 只是基础设置，需要配合 autocmd 主动触发检查
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
    pattern = "*",
    callback = function()
        if vim.fn.mode() ~= "c" then
            vim.cmd("checktime")
        end
    end,
    desc = "Check if file changed externally",
})

-- 文件被外部修改后显示提示信息
vim.api.nvim_create_autocmd("FileChangedShellPost", {
    pattern = "*",
    callback = function()
        vim.notify("文件已被外部修改并重新加载", vim.log.levels.WARN)
    end,
    desc = "Notify when file reloaded",
})

-- 其他
vim.opt.mouse = ""
vim.opt.syntax = "enable"
vim.opt.updatetime = 300
vim.opt.timeoutlen = 500
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8
