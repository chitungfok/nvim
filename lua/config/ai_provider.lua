local M = {}

local providers = {
    siliconflow = {
        name = "SiliconFlow",
        api_key = "SILICONFLOW_API_KEY",
        end_point = "https://api.siliconflow.cn/v1/chat/completions",
        model = "deepseek-ai/DeepSeek-V4-Flash",
        -- SiliconFlow 将思考预算与补全文本的上限分开计算。
        reasoning_budget = 0,
        optional = { enable_thinking = true, reasoning_effort = "high", thinking_budget = 8192 },
    },
    deepseek = {
        name = "DeepSeek",
        api_key = "DEEPSEEK_API_KEY",
        end_point = "https://api.deepseek.com/chat/completions",
        model = "deepseek-flash",
        optional = { thinking = { type = "enabled" }, reasoning_effort = "low" },
    },
    opencode = {
        name = "OpenCode Zen",
        api_key = "OPENCODE_API_KEY",
        end_point = "https://opencode.ai/zen/v1/chat/completions",
        model = "deepseek-v4.1-flash",
        optional = { thinking = { type = "enabled" }, reasoning_effort = "high" },
    },
    opencode_go = {
        name = "OpenCode Go",
        api_key = "OPENCODE_GO_API_KEY",
        end_point = "https://opencode.ai/zen/go/v1/chat/completions",
        model = "deepseek-v4.1-flash",
        optional = { thinking = { type = "enabled" }, reasoning_effort = "high" },
    },
    openai = {
        name = "OpenAI",
        api_key = "OPENAI_API_KEY",
        end_point = "https://api.openai.com/v1/chat/completions",
        model = "gpt-5.6-luna",
        token_limit = "max_completion_tokens",
        -- OpenAI 用 reasoning_effort 开启推理，不接受 DeepSeek 的 thinking 字段。
        optional = { reasoning_effort = "high" },
    },
    custom = {
        name = "自定义接口",
        api_key = "NVIM_AI_API_KEY",
        optional = { thinking = { type = "enabled" }, reasoning_effort = "high" },
    },
}

local function env(name)
    local value = vim.env[name]
    if value and value:find("%S") then
        return vim.trim(value)
    end
end

function M.resolve()
    local name = (env("NVIM_AI_PROVIDER") or "deepseek"):lower()
    if not providers[name] then
        return nil,
            "NVIM_AI_PROVIDER 可选 siliconflow、deepseek、opencode、opencode_go、openai 或 custom"
    end

    local provider = vim.deepcopy(providers[name])
    provider.api_key = env("NVIM_AI_API_KEY_ENV") or provider.api_key
    provider.end_point = env("NVIM_AI_ENDPOINT") or provider.end_point
    provider.model = env("NVIM_AI_MODEL") or provider.model
    -- 流式续写超时后仍可解析已收到的代码；Duet 后端也使用 SSE。
    provider.stream = true
    provider.optional = provider.optional or {}

    if not provider.end_point or not provider.model then
        return nil, "自定义接口需要同时设置 NVIM_AI_ENDPOINT 和 NVIM_AI_MODEL"
    end
    if not provider.end_point:match("^https?://%S+$") then
        return nil, "NVIM_AI_ENDPOINT 需要填写完整的 HTTP(S) 接口地址"
    end
    if not provider.api_key:match("^[%a_][%w_]*$") then
        return nil, "NVIM_AI_API_KEY_ENV 应填写密钥的环境变量名"
    end
    return provider
end

function M.options(provider, max_tokens)
    local options = vim.deepcopy(provider)
    -- 为思考额外留出 8192 token，避免用完原来的小预算后没有代码输出。
    options.optional[options.token_limit or "max_tokens"] = max_tokens + (options.reasoning_budget or 8192)
    options.token_limit = nil
    options.reasoning_budget = nil
    return options
end

return M
