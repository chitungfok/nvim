local group = vim.api.nvim_create_augroup("UserEditing", { clear = true })

vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
    group = group,
    callback = function()
        if vim.fn.mode() ~= "c" and vim.fn.getcmdwintype() == "" then
            vim.cmd.checktime()
        end
    end,
    desc = "检查外部文件修改",
})

vim.api.nvim_create_autocmd("FileChangedShellPost", {
    group = group,
    callback = function()
        vim.notify("已重新读取外部修改的文件")
    end,
    desc = "提示文件已重载",
})

vim.api.nvim_create_autocmd("TextYankPost", {
    group = group,
    callback = function()
        vim.hl.on_yank({ timeout = 150 })
    end,
    desc = "短暂标出复制的范围",
})

vim.api.nvim_create_autocmd("FileType", {
    group = group,
    pattern = "lua",
    callback = function()
        vim.bo.shiftwidth = 4
        vim.bo.softtabstop = 4
    end,
    desc = "Lua 缩进与 StyLua 保持一致",
})
