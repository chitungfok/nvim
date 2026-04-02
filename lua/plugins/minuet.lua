-- ============================================================================
-- Minuet AI 补全配置 (DeepSeek + Virtual Text)
-- ============================================================================

local M = {}

M.opts = {
    provider = "openai_compatible",
    notify = "warn",

    -- 请求控制
    throttle = 1500,
    debounce = 500,
    request_timeout = 4,

    -- 补全设置
    n_completions = 1,
    context_window = 12000,

    -- 关闭 blink 自动补全 (使用 virtual text)
    blink = { enable_auto_complete = false },

    -- Virtual Text 模式
    virtualtext = {
        auto_trigger_ft = { "go" }, -- 所有文件类型自动触发
        keymap = {
            accept = "<Tab>",
            accept_line = "<C-l>",
            next = "<C-n>",
            prev = "<C-p>",
            dismiss = "<C-]>",
        },
    },

    -- DeepSeek 配置
    provider_options = {
        openai_compatible = {
            api_key = "SILICONFLOW_API_KEY",
            end_point = "https://api.siliconflow.cn/v1/chat/completions",
            model = "Qwen/Qwen3-Coder-30B-A3B-Instruct",
            name = "Qwen3",
            stream = true,
            optional = {
                max_tokens = 256,
                top_p = 0.9,
            },
        },
    },
}

return M
