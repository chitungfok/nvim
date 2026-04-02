-- ============================================================================
-- LSP 公共配置模块 (Neovim 0.11+ 新 API)
-- ============================================================================
local M = {}

-- ============================================================================
-- 全局 LSP 默认配置 (应用于所有 LSP 服务器)
-- ============================================================================
-- 自定义 capabilities (会与 blink.cmp 合并)
M.custom_capabilities = {
    textDocument = {
        -- 折叠支持 (nvim-ufo 等插件需要)
        foldingRange = {
            dynamicRegistration = false,
            lineFoldingOnly = true,
        },
        -- 禁用 snippet，补全函数时不插入参数占位符
        completion = {
            completionItem = {
                snippetSupport = false,
            },
        },
    },
}

vim.lsp.config("*", {
    root_markers = { ".git" },
    capabilities = M.custom_capabilities,
})

-- ============================================================================
-- LspAttach: 统一处理 LSP 附加事件 (替代 on_attach 回调)
-- ============================================================================
vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("lsp-attach-config", { clear = true }),
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if not client then
            return
        end

        local bufnr = args.buf
        local opts = { buffer = bufnr, silent = true }

        -- ====================================================================
        -- 按键映射 (直接在 LspAttach 中设置，无需 on_attach)
        -- ====================================================================
        -- 跳转 (g 前缀，符合 Vim 习惯)
        vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = bufnr, desc = "Hover documentation" })
        vim.keymap.set("n", "gd", function()
            require("trouble").toggle("lsp_definitions")
        end, { buffer = bufnr, desc = "Go to definition" })
        vim.keymap.set("n", "gD", function()
            require("trouble").toggle("lsp_declarations")
        end, { buffer = bufnr, desc = "Go to declaration" })
        vim.keymap.set(
            "n",
            "gr",
            "<cmd>Trouble lsp_references toggle focus=true<cr>",
            { buffer = bufnr, desc = "Go to references" }
        )
        vim.keymap.set(
            "n",
            "gi",
            "<cmd>Trouble lsp_implementations toggle focus=true<cr>",
            { buffer = bufnr, desc = "Go to implementations" }
        )

        -- 诊断导航
        vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { buffer = bufnr, desc = "Previous diagnostic" })
        vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { buffer = bufnr, desc = "Next diagnostic" })

        -- LSP 操作 (<leader>c 代码操作组)
        vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, { buffer = bufnr, desc = "Rename symbol" })
        vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { buffer = bufnr, desc = "Code action" })
        vim.keymap.set("n", "<leader>cf", function()
            vim.lsp.buf.format({ async = false })
        end, { buffer = bufnr, desc = "Format buffer" })
        vim.keymap.set("n", "<leader>cs", function()
            require("telescope.builtin").lsp_document_symbols({ bufnr = bufnr })
        end, { buffer = bufnr, desc = "Document symbols" })

        -- ====================================================================
        -- Inlay Hints (Neovim 0.10+，默认关闭，<leader>ch 切换)
        -- ====================================================================
        if client:supports_method("textDocument/inlayHint") then
            vim.keymap.set("n", "<leader>ch", function()
                vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }), { bufnr = bufnr })
            end, { buffer = bufnr, desc = "Toggle inlay hints" })
        end

        -- ====================================================================
        -- 附加 navbuddy (仅支持 documentSymbols 的服务器)
        -- ====================================================================
        if client:supports_method("textDocument/documentSymbol") then
            local ok, navbuddy = pcall(require, "nvim-navbuddy")
            if ok then
                navbuddy.attach(client, bufnr)
            end
        end
    end,
})

-- ============================================================================
-- 诊断配置优化
-- ============================================================================
vim.diagnostic.config({
    virtual_text = {
        prefix = "●",
        spacing = 4,
    },
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = '',
            [vim.diagnostic.severity.WARN] = '',
            [vim.diagnostic.severity.INFO] = '',
            [vim.diagnostic.severity.HINT] = "󰌵 ",
        },
    },
    underline = true,
    update_in_insert = false,
    severity_sort = true,
    float = {
        border = "rounded",
        source = true,
    },
})

-- ============================================================================
-- 工具函数
-- ============================================================================

--- 创建保存时格式化的 autocmd
---@param pattern string 文件模式
---@param organize_imports? boolean 是否整理 imports (Go 专用)
M.format_on_save = function(pattern, organize_imports)
    vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = pattern,
        callback = function(args)
            -- Go 特殊处理: organize imports
            if organize_imports then
                local clients = vim.lsp.get_clients({ bufnr = args.buf })
                local encoding = clients[1] and clients[1].offset_encoding or "utf-16"
                local params = vim.lsp.util.make_range_params(0, encoding)
                params.context = { only = { "source.organizeImports" } }
                local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 800)
                for cid, res in pairs(result or {}) do
                    for _, r in pairs(res.result or {}) do
                        if r.edit then
                            local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or "utf-16"
                            vim.lsp.util.apply_workspace_edit(r.edit, enc)
                        end
                    end
                end
            end
            vim.lsp.buf.format({ async = false, bufnr = args.buf })
        end,
    })
end

return M
