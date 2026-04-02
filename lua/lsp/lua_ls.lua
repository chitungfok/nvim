-- ============================================================================
-- Lua Language Server (LuaLS/sumneko)
-- https://github.com/LuaLS/lua-language-server
-- ============================================================================

vim.lsp.config("lua_ls", {
	cmd = { "lua-language-server" },
	filetypes = { "lua" },
	root_markers = { ".luarc.json", ".luarc.jsonc", ".luacheckrc", ".stylua.toml", "stylua.toml", ".git" },
	settings = {
		Lua = {
			runtime = {
				-- Neovim 使用 LuaJIT
				version = "LuaJIT",
			},
			diagnostics = {
				-- 识别 vim 全局变量
				globals = { "vim" },
			},
			workspace = {
				-- 让 LSP 识别 Neovim runtime 文件
				library = vim.api.nvim_get_runtime_file("", true),
				-- 禁用第三方库检测提示
				checkThirdParty = false,
			},
			telemetry = {
				enable = false,
			},
			completion = {
				callSnippet = "Replace",
			},
			hint = {
				enable = true,
				setType = true,
			},
		},
	},
})

vim.lsp.enable("lua_ls")
