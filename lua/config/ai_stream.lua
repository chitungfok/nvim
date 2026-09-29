local M = {}

local function notify(provider, message, level)
    local severity = level == "error" and vim.log.levels.ERROR or vim.log.levels.WARN
    require("minuet.utils").notify(provider .. "：" .. message, level or "warn", severity)
end

local function error_detail(value)
    if type(value) == "table" then
        for _, field in ipairs({ "code", "type", "message" }) do
            if type(value[field]) == "string" or type(value[field]) == "number" then
                value = value[field]
                break
            end
        end
    end
    if type(value) ~= "string" and type(value) ~= "number" then
        return "服务端未提供错误说明"
    end
    -- 保留错误标识或短说明，避免把整段响应写入消息历史。
    return vim.fn.strcharpart(tostring(value):gsub("%c", " "), 0, 160)
end

local function report_api_error(chunk, provider)
    if type(chunk) == "table" and chunk.error and chunk.error ~= vim.NIL then
        notify(provider, "接口错误：" .. error_detail(chunk.error), "error")
        return true
    end
    return false
end

---@param response vim.SystemCompleted
---@param data_file string
---@param provider string
---@param get_text function
---@return string?
function M.decode(response, data_file, provider, get_text)
    vim.uv.fs_unlink(data_file)
    if response.signal == 15 or response.signal == 2 then
        return
    end

    -- HTTP 错误也可能返回带换行的普通 JSON，而不是 SSE。
    local decoded, body = pcall(vim.json.decode, response.stdout or "")
    if decoded and report_api_error(body, provider) then
        return
    end

    local parts = {}
    local has_reasoning, token_limit, parsed = false, false, false
    for line in (response.stdout or ""):gmatch("[^\r\n]+") do
        local payload = line:match("^%s*data:%s*(.*)$") or line
        local ok, chunk = pcall(vim.json.decode, payload)
        if ok and type(chunk) == "table" then
            parsed = true
            -- error 字段才表示接口错误；思考内容也可能包含 error 单词。
            if report_api_error(chunk, provider) then
                return
            end
            local choice = type(chunk.choices) == "table" and chunk.choices[1]
            if type(choice) == "table" then
                token_limit = token_limit or choice.finish_reason == "length"
                local delta = choice.delta
                if type(delta) == "table" then
                    has_reasoning = has_reasoning
                        or (type(delta.reasoning_content) == "string" and delta.reasoning_content ~= "")
                end
            end
            local success, text = pcall(get_text, chunk)
            if success and type(text) == "string" and text ~= "" then
                parts[#parts + 1] = text
            end
        end
    end

    if response.code ~= 0 and response.code ~= 28 then
        notify(provider, "请求失败，curl 退出码 " .. response.code, "error")
        return
    end
    if #parts > 0 then
        if response.code == 28 then
            notify(provider, "请求超时，仅保留已收到的补全文本")
        elseif token_limit then
            notify(provider, "已达到 token 上限，补全文本可能不完整")
        end
        return table.concat(parts)
    end
    if token_limit then
        notify(provider, "已达到 token 上限，未返回补全文本；检查思考与输出预算")
    elseif response.code == 28 then
        local detail = has_reasoning and "只收到思考内容，未返回补全文本" or "未收到补全文本"
        notify(provider, "请求超时：" .. detail .. "；可调整 config.ai 中的 request_timeout")
    elseif has_reasoning then
        notify(provider, "请求已结束，但只收到思考内容，没有补全文本")
    elseif not parsed and (response.stdout or ""):find("%S") then
        notify(provider, "无法解析响应，请检查接口是否支持 Chat Completions 流式输出")
    else
        notify(provider, "请求已结束，但没有返回补全文本")
    end
end

function M.setup()
    -- Minuet 3b0a4c5 的空结果分支会误报并打印原始响应；上游修复后可移除此兼容层。
    require("minuet.utils").stream_decode = M.decode
    local duet = package.loaded["minuet.duet.utils"]
    if duet then
        duet.stream_decode = M.decode
    end
end

return M
