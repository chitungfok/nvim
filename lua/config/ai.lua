local M = {}
local provider_config = require("config.ai_provider")
local pending = { completion = 0, duet = 0 }
local status_initialized = false

M.filetypes = {
    "go",
    "gomod",
    "rust",
    "c",
    "cpp",
    "lua",
    "python",
    "javascript",
    "typescript",
    "javascriptreact",
    "typescriptreact",
    "sh",
    "json",
    "yaml",
    "toml",
    "markdown",
    "proto",
}

function M.status()
    local provider, error_message = provider_config.resolve()
    if not provider then
        return false, error_message
    end
    local key = vim.env[provider.api_key]
    if not key or not key:find("%S") then
        return false, "设置 " .. provider.api_key .. " 后重启 nvim，启用 " .. provider.name
    end
    return true, provider.name .. " / " .. provider.model
end

function M.available()
    local available = M.status()
    return available
end

function M.setup_status()
    if status_initialized then
        return
    end
    status_initialized = true
    local group = vim.api.nvim_create_augroup("UserAiStatus", { clear = true })
    for channel, prefix in pairs({ completion = "MinuetRequest", duet = "MinuetDuetRequest" }) do
        vim.api.nvim_create_autocmd("User", {
            group = group,
            pattern = { prefix .. "Started", prefix .. "Finished" },
            callback = function(event)
                local delta = event.match == prefix .. "Started" and 1 or -1
                pending[channel] = math.max(0, pending[channel] + delta)
                local lualine = package.loaded["lualine"]
                if lualine then
                    lualine.refresh({ place = { "statusline" } })
                end
            end,
            desc = "显示 AI 请求状态",
        })
    end
end

function M.indicator()
    if not M.available() then
        return "AI 未配置"
    end
    if pending.duet > 0 then
        return "AI 编辑预测中…"
    end
    if pending.completion > 0 then
        return "AI 续写中…"
    end
    if not M.eligible() then
        return "AI 本文件停用"
    end
    local edit_hint = vim.fn.mode():match("^i") and "Tab" or "Space aa"
    for _, item in ipairs({
        { "minuet.virtualtext", "AI 建议 · Tab" },
        { "minuet.duet", "AI 编辑建议 · " .. edit_hint },
    }) do
        local module = package.loaded[item[1]]
        if module and module.action.is_visible() then
            return item[2]
        end
    end
    if not package.loaded["minuet"] then
        return "AI 待加载"
    end
    if vim.b.minuet_virtual_text_auto_trigger or vim.b.minuet_duet_auto_trigger then
        return "AI 自动"
    end
    return "AI 手动"
end

function M.setup(options)
    M.setup_status()
    require("config.ai_stream").setup()
    require("minuet").setup(options)
    -- InsertEnter 加载时，已打开文件的 FileType 事件通常已经结束。
    for _, buffer in ipairs(vim.api.nvim_list_bufs()) do
        if
            vim.api.nvim_buf_is_loaded(buffer)
            and vim.b[buffer].minuet_virtual_text_auto_trigger == nil
            and vim.tbl_contains(options.virtualtext.auto_trigger_ft, vim.bo[buffer].filetype)
        then
            vim.b[buffer].minuet_virtual_text_auto_trigger = true
        end
    end
end

function M.eligible(buffer)
    buffer = buffer or vim.api.nvim_get_current_buf()
    if not vim.api.nvim_buf_is_loaded(buffer) or not M.available() then
        return false
    end
    if vim.bo[buffer].buftype ~= "" or not vim.bo[buffer].modifiable then
        return false
    end
    local name = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(buffer), ":t")
    if name == ".env" or name:match("^%.env%.") then
        return false
    end
    local size = vim.api.nvim_buf_get_offset(buffer, vim.api.nvim_buf_line_count(buffer))
    return size >= 0 and size < 1000000
end

function M.accept()
    local virtualtext = package.loaded["minuet.virtualtext"]
    if virtualtext and virtualtext.action.is_visible() then
        virtualtext.action.accept()
        return true
    end
    local duet = package.loaded["minuet.duet"]
    if duet and duet.action.is_visible() then
        duet.action.apply()
        return true
    end
    return false
end

function M.dismiss()
    for _, name in ipairs({ "minuet.virtualtext", "minuet.duet" }) do
        local module = package.loaded[name]
        if module and module.action.is_visible() then
            module.action.dismiss()
        end
    end
end

function M.run(command)
    local available, message = M.status()
    if not available then
        vim.notify(message, vim.log.levels.WARN)
        return
    end
    if not M.eligible() then
        vim.notify(
            "当前缓冲区不启用 AI：需要可编辑文件，排除 .env 和 1 MB 以上文件",
            vim.log.levels.WARN
        )
        return
    end
    vim.cmd("Minuet " .. command)
end

function M.options()
    local provider, error_message = provider_config.resolve()
    if not provider then
        vim.notify(error_message, vim.log.levels.WARN)
        -- 配置有误时停用 AI 请求，普通补全仍能加载。
        provider = { name = "未配置", api_key = "", end_point = "", model = "", optional = {} }
    end
    return {
        provider = "openai_compatible",
        notify = "warn",
        throttle = 1500,
        debounce = 400,
        -- high 思考可能在原来的 30 秒内尚未返回代码。
        request_timeout = 120,
        n_completions = 1,
        context_window = 12000,
        enable_predicates = {
            function()
                return M.eligible()
            end,
        },
        blink = { enable_auto_complete = false },
        virtualtext = { auto_trigger_ft = M.filetypes, keymap = {} },
        provider_options = {
            openai_compatible = provider_config.options(provider, 256),
        },
        -- Duet 会重写整段代码，输出上限要比行内续写高。
        duet = {
            provider = "openai_compatible",
            request_timeout = 120,
            provider_options = {
                openai_compatible = provider_config.options(provider, 2048),
            },
            auto_trigger = {
                auto_trigger_ft = {},
                enable_predicates = {
                    function()
                        return M.eligible()
                    end,
                },
            },
            recent_edits = { enable_predicates = { M.eligible } },
        },
    }
end

return M
