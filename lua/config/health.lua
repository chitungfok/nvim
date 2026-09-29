local M = {}

function M.check()
    local health = vim.health
    health.start("本地 Neovim 配置")
    for _, command in ipairs({ "git", "rg", "make", "curl" }) do
        if vim.fn.executable(command) == 1 then
            health.ok(command .. " 可用")
        else
            health.warn("找不到 " .. command .. "，请安装并加入 PATH")
        end
    end
    health.start("语言服务和 Go 工具")
    for _, command in ipairs({
        "gopls",
        "clangd",
        "rust-analyzer",
        "lua-language-server",
        "golangci-lint-langserver",
        "golangci-lint",
    }) do
        if vim.fn.executable(command) == 1 then
            health.ok(command .. " 可用")
        else
            health.warn(command .. " 未安装；对应功能暂不可用")
        end
    end
    health.start("AI 自动续写")
    local available, message = require("config.ai").status()
    if available then
        health.ok(message .. "；密钥已设置，尚未检查接口连通性")
    else
        health.warn(message)
    end
end

return M
