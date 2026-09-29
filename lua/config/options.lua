vim.g.mapleader = " "
vim.g.maplocalleader = " "

local opt = vim.opt
opt.encoding = "utf-8"
opt.fileencoding = "utf-8"
opt.background = "dark"
opt.termguicolors = true
opt.number = true
opt.signcolumn = "yes"
opt.laststatus = 3
opt.mouse = "a"
opt.wrap = false
opt.cursorline = true
opt.pumheight = 12
opt.splitbelow = true
opt.splitright = true
opt.scrolloff = 8
opt.sidescrolloff = 8

opt.autoindent = true
opt.smartindent = true
opt.expandtab = true
opt.shiftwidth = 4
opt.softtabstop = 4
opt.tabstop = 4

opt.hlsearch = false
opt.incsearch = true
opt.ignorecase = true
opt.smartcase = true
opt.autoread = true
opt.backup = false
opt.writebackup = false
opt.swapfile = false
opt.undofile = true
opt.updatetime = 300
opt.timeoutlen = 400

opt.list = true
opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
opt.foldcolumn = "1"
opt.foldmethod = "indent"
opt.foldlevel = 99
opt.foldlevelstart = 99
opt.foldenable = true
