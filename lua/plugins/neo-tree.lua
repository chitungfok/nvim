-- ============================================================================
-- Neo-tree 配置 - 现代化文件管理器
-- ============================================================================
-- 特性：
-- 1. 多源支持：文件系统、Buffers、Git 状态
-- 2. 深度 Git 集成和 LSP 诊断集成
-- 3. 异步架构，大型项目性能优异
-- ============================================================================

return {
    -- ========================================================================
    -- 默认配置说明
    -- ========================================================================
    close_if_last_window = false, -- 最后一个窗口时不自动关闭
    popup_border_style = "rounded", -- 弹窗边框样式
    enable_git_status = true, -- 启用 Git 状态
    enable_diagnostics = true, -- 启用 LSP 诊断

    -- ========================================================================
    -- 默认组件样式
    -- ========================================================================
    default_component_configs = {
        -- 容器配置
        container = {
            enable_character_fade = true,
        },
        -- 缩进配置
        indent = {
            indent_size = 2,
            padding = 1, -- 左侧额外填充
            -- 缩进线配置
            with_markers = true,
            indent_marker = "│",
            last_indent_marker = "└",
            highlight = "NeoTreeIndentMarker",
            -- 展开/折叠箭头配置（显示在文件夹图标左侧）
            with_expanders = true,
            expander_collapsed = "", -- 折叠状态：右箭头
            expander_expanded = "", -- 展开状态：下箭头
            expander_highlight = "NeoTreeExpander",
        },
        -- 图标配置
        icon = {
            folder_closed = "",
            folder_open = "",
            folder_empty = "󰜌",
            -- 文件默认图标
            default = "󰈙",
            highlight = "NeoTreeFileIcon",
            -- 使用 nvim-web-devicons 提供特定文件类型的图标
            provider = function(icon, node, state)
                if node.type == "file" or node.type == "terminal" then
                    local success, web_devicons = pcall(require, "nvim-web-devicons")
                    local name = node.type == "terminal" and "terminal" or node.name
                    if success then
                        local devicon, hl = web_devicons.get_icon(name)
                        icon.text = devicon or icon.text
                        icon.highlight = hl or icon.highlight
                    end
                -- 文件夹图标使用蓝色高亮
                elseif node.type == "directory" then
                    icon.highlight = "NeoTreeDirectoryIcon"
                end
            end,
        },
        -- 修改标记
        modified = {
            symbol = "●",
            highlight = "NeoTreeModified",
        },
        -- 文件名配置
        name = {
            trailing_slash = false,
            use_git_status_colors = true,
            highlight = "NeoTreeFileName",
        },
        -- Git 状态符号（VSCode 风格 Nerd Font 图标）
        git_status = {
            symbols = {
                -- Change type
                added = "✚",
                modified = "",
                deleted = "✖", -- this can only be used in the git_status source
                renamed = "󰁕", -- this can only be used in the git_status source
                -- Status type
                untracked = "",
                ignored = "",
                unstaged = "󰄱",
                staged = "",
                conflict = "",
            },
        },
        -- 诊断符号
        diagnostics = {
            symbols = {
                hint = "󰌵",
                info = "",
                warn = "",
                error = "",
            },
            highlights = {
                hint = "DiagnosticSignHint",
                info = "DiagnosticSignInfo",
                warn = "DiagnosticSignWarn",
                error = "DiagnosticSignError",
            },
        },
    },

    -- ========================================================================
    -- 窗口配置
    -- ========================================================================
    window = {
        -- position = "left",  -- 侧边栏模式
        -- width = 40,
        position = "float", -- 浮动窗口模式
        popup = {
            size = { width = "40%", height = "60%" },
            position = "50%", -- 居中
        },
        mappings = {
            -- 基础操作
            ["<space>"] = {
                "toggle_node",
                nowait = false, -- 允许二级键位
            },
            ["<cr>"] = "open", -- 智能打开：文件打开，文件夹展开/折叠
            ["<esc>"] = "cancel",
            ["<2-LeftMouse>"] = "open", -- 鼠标双击打开
            ["l"] = "open", -- Vim 风格：l 向右进入
            ["h"] = "close_node", -- Vim 风格：h 向左退出

            -- 预览
            ["P"] = { "toggle_preview", config = { use_float = true } },

            -- 分屏打开
            ["s"] = "open_split",
            ["v"] = "open_vsplit",
            ["t"] = "open_tabnew",
            ["w"] = "open_with_window_picker",

            -- 节点操作
            ["C"] = "close_node",
            ["z"] = "close_all_nodes",
            ["Z"] = "expand_all_nodes",

            -- 文件操作
            ["a"] = { "add", config = { show_path = "none" } },
            ["A"] = "add_directory",
            ["d"] = "delete",
            ["r"] = "rename",
            ["y"] = "copy_to_clipboard",
            ["x"] = "cut_to_clipboard",
            ["p"] = "paste_from_clipboard",
            ["c"] = "copy", -- 复制（需要确认目标位置）
            ["m"] = "move", -- 移动（需要确认目标位置）

            -- 刷新和帮助
            ["R"] = "refresh",
            ["?"] = "show_help",
            ["q"] = "close_window",
            ["i"] = "show_file_details", -- 显示文件详情

            -- 源切换
            ["<"] = "prev_source",
            [">"] = "next_source",
        },
    },

    -- ========================================================================
    -- 文件系统源配置
    -- ========================================================================
    filesystem = {
        -- 过滤配置
        filtered_items = {
            visible = false, -- 不灰显隐藏文件，直接隐藏
            hide_dotfiles = false, -- 显示隐藏文件（与 nvim-tree 一致）
            hide_gitignored = false,
            hide_by_name = {
                ".git",
            },
            never_show = {
                ".DS_Store",
                "thumbs.db",
            },
        },

        -- 跟随当前文件
        follow_current_file = {
            enabled = true, -- 自动跟随当前 buffer 所在文件
            leave_dirs_open = true, -- 保持父目录展开
        },

        -- 其他选项
        group_empty_dirs = false, -- 禁用合并空目录（启用会导致 fuzzy_finder 后打开文件夹报错）
        hijack_netrw_behavior = "open_default",
        use_libuv_file_watcher = false, -- 文件监视（可能影响性能）

        -- 文件系统特定映射
        window = {
            mappings = {
                ["<bs>"] = "navigate_up",
                ["."] = "set_root",
                ["-"] = "navigate_up", -- 额外的返回上级映射
                ["H"] = "toggle_hidden",
                ["/"] = "fuzzy_finder",
                ["D"] = "fuzzy_finder_directory", -- 仅搜索目录
                ["#"] = "fuzzy_sorter", -- 模糊排序
                ["f"] = "filter_on_submit",
                ["<c-x>"] = "clear_filter",

                -- Git 导航
                ["[g"] = "prev_git_modified",
                ["]g"] = "next_git_modified",

                -- 排序
                ["oc"] = { "order_by_created", nowait = false },
                ["od"] = { "order_by_diagnostics", nowait = false },
                ["og"] = { "order_by_git_status", nowait = false },
                ["om"] = { "order_by_modified", nowait = false },
                ["on"] = { "order_by_name", nowait = false },
                ["os"] = { "order_by_size", nowait = false },
                ["ot"] = { "order_by_type", nowait = false },
            },
        },
    },

    -- ========================================================================
    -- Buffers 源配置
    -- ========================================================================
    buffers = {
        follow_current_file = {
            enabled = true,
            leave_dirs_open = false,
        },
        group_empty_dirs = false, -- 禁用合并空目录（与 filesystem 保持一致）
        show_unloaded = true,
        window = {
            mappings = {
                ["bd"] = "buffer_delete",
                ["<bs>"] = "navigate_up",
                ["."] = "set_root",
            },
        },
    },

    -- ========================================================================
    -- Git 状态源配置
    -- ========================================================================
    git_status = {
        window = {
            position = "float",
            mappings = {
                ["A"] = "git_add_all",
                ["gu"] = "git_unstage_file",
                ["ga"] = "git_add_file",
                ["gr"] = "git_revert_file",
                ["gc"] = "git_commit",
                ["gp"] = "git_push",
                ["gg"] = "git_commit_and_push",
            },
        },
    },
}
