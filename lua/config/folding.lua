local M = {}

local expression = "v:lua.vim.lsp.foldexpr()"

local function refresh(buffer, detached_client)
    if not vim.api.nvim_buf_is_valid(buffer) or vim.bo[buffer].buftype ~= "" then
        return
    end
    local method = "indent"
    for _, client in ipairs(vim.lsp.get_clients({ bufnr = buffer, method = "textDocument/foldingRange" })) do
        if client.id ~= detached_client then
            method = "expr"
            break
        end
    end
    -- 折叠选项属于窗口；同一文件在多个分屏中打开时都要更新。
    for _, window in ipairs(vim.fn.win_findbuf(buffer)) do
        local options = vim.wo[window][0]
        if method == "expr" and options.foldexpr ~= expression then
            options.foldexpr = expression
        end
        if options.foldmethod ~= method then
            options.foldmethod = method
        end
    end
end

function M.peek()
    local first = vim.fn.foldclosed(".")
    if first == -1 then
        vim.lsp.buf.hover({ border = "rounded" })
        return
    end
    local last = vim.fn.foldclosedend(".")
    local lines = vim.api.nvim_buf_get_lines(0, first - 1, last, false)
    vim.lsp.util.open_floating_preview(lines, vim.bo.filetype, {
        border = "rounded",
        focus_id = "native-fold-preview",
        max_height = 20,
        max_width = math.max(1, math.floor(vim.o.columns * 0.8)),
    })
end

function M.setup()
    local group = vim.api.nvim_create_augroup("UserFolding", { clear = true })
    vim.api.nvim_create_autocmd({ "BufWinEnter", "FileType", "LspAttach" }, {
        group = group,
        callback = function(event)
            refresh(event.buf)
        end,
        desc = "有 LSP 折叠能力时使用原生表达式，否则按缩进折叠",
    })
    vim.api.nvim_create_autocmd("LspDetach", {
        group = group,
        callback = function(event)
            vim.schedule(function()
                refresh(event.buf, event.data.client_id)
            end)
        end,
        desc = "语言服务退出后重新选择折叠方式",
    })
end

return M
