local function open_and_close(view, context)
    if context.item then
        require("trouble.config.actions").jump_close(view, context)
    elseif context.node then
        -- 文件分组没有跳转目标，Enter 和 o 都只切换折叠。
        view:fold(context.node)
    end
end

return {
    focus = true,
    keys = {
        ["<cr>"] = { action = open_and_close, desc = "打开并关闭面板 / 切换分组" },
        o = { action = open_and_close, desc = "打开并关闭面板 / 切换分组" },
        h = "fold_close",
        l = "fold_open",
        P = "toggle_preview",
    },
    modes = {
        symbols = { win = { size = 50, wo = { wrap = true } }, format = "{kind_icon} {symbol.name}" },
    },
}
