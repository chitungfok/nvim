local M = {}

M.servers = { "gopls", "golangci_lint_ls", "clangd", "rust_analyzer", "lua_ls" }
local group = vim.api.nvim_create_augroup("UserLsp", { clear = true })

vim.diagnostic.config({
    virtual_text = { prefix = "●", spacing = 4 },
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = "",
            [vim.diagnostic.severity.WARN] = "",
            [vim.diagnostic.severity.INFO] = "",
            [vim.diagnostic.severity.HINT] = "󰌵",
        },
    },
    underline = true,
    update_in_insert = false,
    severity_sort = true,
    float = { border = "rounded", source = true },
})

vim.api.nvim_create_autocmd("LspAttach", {
    group = group,
    callback = function(event)
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if not client then
            return
        end
        local buffer = event.buf
        local function map(key, action, description, mode)
            vim.keymap.set(mode or "n", key, action, { buffer = buffer, silent = true, desc = description })
        end
        map("K", vim.lsp.buf.hover, "悬浮文档")
        map("gd", vim.lsp.buf.definition, "跳转到定义")
        map("gD", vim.lsp.buf.declaration, "跳转到声明")
        map("gr", "<cmd>Trouble lsp_references toggle focus=true<cr>", "查看引用")
        map("gi", "<cmd>Trouble lsp_implementations toggle focus=true<cr>", "查看实现")
        map("<leader>cD", "<cmd>Trouble lsp_definitions toggle focus=true<cr>", "预览定义列表")
        map("<leader>cR", "<cmd>Trouble lsp_declarations toggle focus=true<cr>", "预览声明列表")
        map("<leader>cr", vim.lsp.buf.rename, "重命名符号")
        map("<leader>ca", vim.lsp.buf.code_action, "代码操作", { "n", "x" })
        map("<leader>cf", function()
            require("config.format").format(buffer)
        end, "格式化文件")
        map("<leader>cs", function()
            require("telescope.builtin").lsp_document_symbols()
        end, "查找文档符号")
        if client:supports_method("textDocument/inlayHint") then
            map("<leader>ch", function()
                vim.lsp.inlay_hint.enable(
                    not vim.lsp.inlay_hint.is_enabled({ bufnr = buffer }),
                    { bufnr = buffer }
                )
            end, "切换类型提示")
        end
        if client.name == "gopls" and vim.bo[buffer].filetype == "go" then
            map("<leader>tt", function()
                vim.lsp.buf.code_action({
                    context = { only = { "source.addTest" }, diagnostics = {} },
                    filter = function(action)
                        return action.kind == "source.addTest"
                    end,
                    apply = true,
                })
            end, "生成当前函数测试（原生 LSP / gopls）")
        end
    end,
})

function M.setup()
    if M.initialized then
        return
    end
    local capabilities = require("blink.cmp").get_lsp_capabilities({
        textDocument = { foldingRange = { dynamicRegistration = false, lineFoldingOnly = true } },
        -- 文件树按需加载，重命名等能力仍须在 LSP 初始化时声明。
        workspace = {
            fileOperations = {
                didCreate = true,
                willCreate = true,
                didRename = true,
                willRename = true,
                didDelete = true,
                willDelete = true,
            },
        },
    })
    M.initialized = true
    vim.lsp.config("*", { capabilities = capabilities, root_markers = { ".git" } })
    for _, name in ipairs(M.servers) do
        local command = vim.lsp.config[name].cmd[1]
        if vim.fn.executable(command) == 1 then
            vim.lsp.enable(name)
        end
    end
end

-- 打开已配置语言的文件时再初始化 LSP，避免阅读文档也加载补全引擎。
vim.api.nvim_create_autocmd("FileType", {
    group = group,
    pattern = {
        "go",
        "gomod",
        "gowork",
        "gotmpl",
        "rust",
        "c",
        "cpp",
        "objc",
        "objcpp",
        "cuda",
        "proto",
        "lua",
    },
    once = true,
    callback = M.setup,
    desc = "初始化文件语言服务",
})

vim.api.nvim_create_autocmd("BufWritePre", {
    group = group,
    pattern = { "*.go", "*.rs" },
    callback = function(event)
        require("config.format").on_save(event.buf)
    end,
    desc = "保存 Go/Rust 时格式化",
})

return M
