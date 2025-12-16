-- ============================================================================
-- LSP 配置加载入口
-- ============================================================================
-- 1. 首先加载公共配置（LspAttach、诊断配置等）
local common = require("lsp.common")

-- 2. 然后加载各语言的 LSP 配置
require("lsp.clangd")
require("lsp.gopls")
require("lsp.golangci-lint")
require("lsp.rust")

-- 3. 导出公共模块供其他地方使用
return common
