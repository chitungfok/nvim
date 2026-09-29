local M = {}
local timeout_ms = 1500

local function organize_imports(client, buffer)
    local params = vim.api.nvim_buf_call(buffer, function()
        return vim.lsp.util.make_range_params(0, client.offset_encoding)
    end)
    params.context = { only = { "source.organizeImports" }, diagnostics = {} }
    local response, err = client:request_sync("textDocument/codeAction", params, timeout_ms, buffer)
    if err or (response and response.err) then
        vim.notify("整理 Go imports 失败：" .. vim.inspect(err or response.err), vim.log.levels.WARN)
        return
    end
    for _, action in ipairs(response and response.result or {}) do
        if not action.disabled then
            if not action.edit and action.data and client:supports_method("codeAction/resolve") then
                local resolved = client:request_sync("codeAction/resolve", action, timeout_ms, buffer)
                action = resolved and resolved.result or action
            end
            if action.edit then
                vim.lsp.util.apply_workspace_edit(action.edit, client.offset_encoding)
            end
            if action.command then
                local command = type(action.command) == "table" and action.command or action
                client:request_sync("workspace/executeCommand", command, timeout_ms, buffer)
            end
        end
    end
end

function M.format(buffer)
    buffer = buffer or vim.api.nvim_get_current_buf()
    local preferred = ({ go = "gopls", rust = "rust_analyzer" })[vim.bo[buffer].filetype]
    local clients = vim.lsp.get_clients({ bufnr = buffer, method = "textDocument/formatting" })
    for _, client in ipairs(clients) do
        if not preferred or client.name == preferred then
            vim.lsp.buf.format({ bufnr = buffer, id = client.id, timeout_ms = timeout_ms })
            return
        end
    end
end

function M.on_save(buffer)
    if vim.bo[buffer].filetype == "go" then
        local client = vim.lsp.get_clients({ bufnr = buffer, name = "gopls" })[1]
        if client then
            organize_imports(client, buffer)
        end
    end
    M.format(buffer)
end

return M
