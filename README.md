# Neovim Configuration

基于 Lua 的个人 Neovim 配置，适用于 **Neovim 0.11+**，采用原生 LSP API 和延迟加载策略。

## 目录

- [特性](#特性)
- [系统要求](#系统要求)
- [安装](#安装)
- [目录结构](#目录结构)
- [按键映射](#按键映射)
- [插件列表](#插件列表)
- [LSP 配置](#lsp-配置)
- [自定义配置](#自定义配置)

## 特性

| 特性 | 说明 |
|------|------|
| **延迟加载** | 基于 lazy.nvim，所有插件默认延迟加载 |
| **原生 LSP** | 使用 Neovim 0.11 内置 `vim.lsp.config` / `vim.lsp.enable` API |
| **高性能补全** | blink.cmp 补全引擎，Rust 编写的模糊匹配算法 |
| **人体工学键位** | 以 `<Space>` 为 Leader，分组清晰的快捷键布局 |
| **现代化文件管理** | Neo-tree 文件树，支持 Git 状态、LSP 诊断、多源切换 |
| **代码折叠增强** | nvim-ufo 提供基于 LSP 的智能折叠 |

## 系统要求

### 必需

| 组件 | 版本/说明 |
|------|----------|
| Neovim | >= 0.11 |
| Git | 用于插件管理 |
| [Nerd Font](https://www.nerdfonts.com/) | 终端字体，用于图标显示 |
| ripgrep | Telescope 文本搜索后端 |
| fd | Telescope 文件查找后端 |
| cmake | 编译 telescope-fzf-native |

### 可选

| 组件 | 用途 |
|------|------|
| Rust/Cargo | 编译 blink.cmp（通常自动完成） |

### 依赖安装

**macOS (Homebrew)**

```bash
brew install neovim ripgrep fd cmake

# Nerd Font
brew tap homebrew/cask-fonts
brew install --cask font-hack-nerd-font
```

**Ubuntu/Debian**

```bash
# Neovim 0.11+ 需从 PPA 或源码安装
sudo apt install ripgrep fd-find cmake

# fd-find 在 Debian/Ubuntu 中命令为 fdfind，需创建符号链接
ln -s $(which fdfind) ~/.local/bin/fd
```

**Arch Linux**

```bash
sudo pacman -S neovim ripgrep fd cmake
```

## 安装

### 步骤 1: 备份现有配置

```bash
mv ~/.config/nvim ~/.config/nvim.bak
mv ~/.local/share/nvim ~/.local/share/nvim.bak
```

### 步骤 2: 克隆配置

```bash
git clone <repository-url> ~/.config/nvim
```

### 步骤 3: 启动 Neovim

首次启动时，lazy.nvim 将自动安装所有插件。

```bash
nvim
```

### 步骤 4: 安装 LSP 服务器

根据开发语言安装对应的 LSP 服务器：

**Go**

```bash
go install golang.org/x/tools/gopls@latest
go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest
go install github.com/nametake/golangci-lint-langserver@latest
```

**Rust**

```bash
rustup component add rust-analyzer
```

**C/C++**

```bash
# Ubuntu/Debian
sudo apt install clangd

# Arch Linux
sudo pacman -S clang

# macOS
brew install llvm
```

### 故障排除

**blink.cmp 下载失败**

若预编译二进制文件下载失败，手动编译：

```bash
cd ~/.local/share/nvim/lazy/blink.cmp
cargo build --release
cp target/release/libblink_cmp_fuzzy.so lua/
```

## 目录结构

```
~/.config/nvim/
├── init.lua                    # 入口文件
├── README.md                   # 本文档
└── lua/
    ├── basic.lua               # 基础设置 (编码、缩进、搜索等)
    ├── mapping.lua             # 全局按键映射
    ├── plugin.lua              # lazy.nvim 插件定义
    ├── colorscheme.lua         # 主题配置
    ├── keymaps-reference.lua   # 按键映射参考文档
    ├── plugins/                # 插件专属配置
    │   ├── cmp.lua             # blink.cmp 补全配置
    │   ├── neo-tree.lua        # Neo-tree 文件管理器配置
    │   └── lualine.lua         # 状态栏配置
    └── lsp/                    # LSP 配置 (Neovim 0.11 API)
        ├── init.lua            # LSP 加载入口
        ├── common.lua          # 公共配置 + LspAttach + 诊断
        ├── clangd.lua          # C/C++
        ├── gopls.lua           # Go
        ├── golangci-lint.lua   # Go Lint
        └── rust.lua            # Rust
```

## 按键映射

**Leader 键**: `<Space>`

### 查看帮助

| 方式 | 说明 |
|------|------|
| `<leader>?` | 显示 which-key 全局帮助 |
| `:Keymaps` | 打开按键映射参考文档 |
| `?` | Neo-tree / Trouble 窗口内显示帮助 |
| `<C-/>` | Telescope 窗口内显示帮助 (Insert 模式) |

### 按键分组概览

| 前缀 | 功能组 |
|------|--------|
| `<leader>w/q/d` | 基础操作 (保存/退出/关闭) |
| `<leader>l` | 文件树 |
| `<leader>f*` | 搜索 (Find) |
| `<leader>b*` | Buffer 管理 |
| `<leader>c*` | 代码操作 (Code/LSP) |
| `<leader>g*` | Git 操作 |
| `<leader>x*` | 诊断面板 (Trouble) |
| `<leader>t*` | 测试 (Test) |
| `<leader>1-9` | Buffer 快速跳转 |
| `z*` | 代码折叠 |
| `g*` | LSP 跳转 |

### 基础操作

| 按键 | 模式 | 功能 |
|------|------|------|
| `<leader>w` | Normal | 保存文件 |
| `<leader>q` | Normal | 退出 |
| `<leader>d` | Normal | 关闭当前 Buffer (自动保存) |
| `<C-c>` | Visual | 复制到系统剪贴板 |
| `<C-v>` | Visual | 从系统剪贴板粘贴 |

### 窗口导航

| 按键 | 功能 |
|------|------|
| `<C-h>` | 跳转到左侧窗口 |
| `<C-j>` | 跳转到下方窗口 |
| `<C-k>` | 跳转到上方窗口 |
| `<C-l>` | 跳转到右侧窗口 |

### 搜索 (Telescope)

| 按键 | 功能 |
|------|------|
| `<leader>ff` | 搜索文件 |
| `<leader>fg` | 全局文本搜索 (ripgrep) |
| `<leader>fb` | 搜索 Buffer |
| `<leader>ft` | 搜索 Tags |
| `<leader>/` | 当前 Buffer 内搜索 |

### Buffer 管理

| 按键 | 功能 |
|------|------|
| `<leader>1-9` | 跳转到第 1-9 个 Buffer |
| `<leader>bp` | 上一个 Buffer |
| `<leader>bn` | 下一个 Buffer |
| `<leader>bh` | 将当前 Buffer 左移 |
| `<leader>bl` | 将当前 Buffer 右移 |

### Git 操作

| 按键 | 功能 |
|------|------|
| `]h` / `[h` | 下一个/上一个 Git hunk |
| `<leader>gd` | 查看 diff |
| `<leader>gp` | 预览 hunk |
| `<leader>gr` | 重置 hunk |
| `<leader>gs` | 暂存 hunk |

### LSP 操作

| 按键 | 功能 |
|------|------|
| `K` | 显示悬浮文档 |
| `gd` | 跳转到定义 |
| `gD` | 跳转到声明 |
| `gr` | 查看引用 |
| `gi` | 查看实现 |
| `]d` / `[d` | 下一个/上一个诊断 |
| `<leader>cr` | 重命名符号 |
| `<leader>ca` | 代码操作 |
| `<leader>cf` | 格式化代码 |
| `<leader>cs` | 文档符号列表 |
| `<leader>ch` | 切换 Inlay Hints |
| `<leader>cn` | 打开 Navbuddy 代码导航 |

### 诊断面板 (Trouble)

| 按键 | 功能 |
|------|------|
| `<leader>xx` | 切换诊断面板 |
| `<leader>xs` | 符号面板 |
| `<leader>xq` | Quickfix 列表 |
| `<leader>xl` | Location 列表 |

### 代码折叠

| 按键 | 功能 |
|------|------|
| `zR` | 打开所有折叠 |
| `zM` | 关闭所有折叠 |
| `zr` | 减少折叠级别 |
| `zm` | 增加折叠级别 |
| `zK` | 预览折叠内容 |

### 测试 (Go)

| 按键 | 功能 |
|------|------|
| `<leader>tt` | 为当前函数生成测试 |
| `<leader>ta` | 为所有函数生成测试 |

### 注释

| 按键 | 模式 | 功能 |
|------|------|------|
| `gcc` | Normal | 切换行注释 |
| `gbc` | Normal | 切换块注释 |
| `gc` | Visual | 切换选中行注释 |
| `gb` | Visual | 切换选中块注释 |

## 插件列表

### 核心依赖

| 插件 | 功能 |
|------|------|
| [lazy.nvim](https://github.com/folke/lazy.nvim) | 插件管理器 |
| [plenary.nvim](https://github.com/nvim-lua/plenary.nvim) | Lua 工具库 |
| [nvim-web-devicons](https://github.com/nvim-tree/nvim-web-devicons) | 文件图标 |
| [mini.icons](https://github.com/echasnovski/mini.icons) | 图标支持 |
| [which-key.nvim](https://github.com/folke/which-key.nvim) | 按键提示 |

### 文件导航与搜索

| 插件 | 功能 |
|------|------|
| [neo-tree.nvim](https://github.com/nvim-neo-tree/neo-tree.nvim) | 文件树 (多源支持) |
| [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) | 模糊搜索 |
| [telescope-fzf-native.nvim](https://github.com/nvim-telescope/telescope-fzf-native.nvim) | FZF 排序算法 |
| [telescope-live-grep-args.nvim](https://github.com/nvim-telescope/telescope-live-grep-args.nvim) | 增强文本搜索 |
| [nvim-navbuddy](https://github.com/SmiteshP/nvim-navbuddy) | 代码符号导航 |
| [snacks.nvim](https://github.com/folke/snacks.nvim) | 智能重命名 |

### 编辑增强

| 插件 | 功能 |
|------|------|
| [Comment.nvim](https://github.com/numToStr/Comment.nvim) | 快速注释 |
| [indent-blankline.nvim](https://github.com/lukas-reineke/indent-blankline.nvim) | 缩进可视化 |
| [nvim-ufo](https://github.com/kevinhwang91/nvim-ufo) | 代码折叠增强 |

### UI 增强

| 插件 | 功能 |
|------|------|
| [lualine.nvim](https://github.com/nvim-lualine/lualine.nvim) | 状态栏 |
| [bufferline.nvim](https://github.com/akinsho/bufferline.nvim) | Buffer 标签栏 |
| [trouble.nvim](https://github.com/folke/trouble.nvim) | 诊断面板 |

### Git 集成

| 插件 | 功能 |
|------|------|
| [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim) | Git 状态标记、行内 Blame |

### 补全

| 插件 | 功能 |
|------|------|
| [blink.cmp](https://github.com/saghen/blink.cmp) | 高性能补全 (内置 LSP/Path/Buffer 源) |

### 语言支持

| 插件 | 功能 |
|------|------|
| [gotests.nvim](https://github.com/yanskun/gotests.nvim) | Go 测试生成 |

### 主题

| 插件 | 状态 |
|------|------|
| [onedarkpro.nvim](https://github.com/olimorris/onedarkpro.nvim) | 当前使用 (onedark_vivid) |

## LSP 配置

本配置使用 **Neovim 0.11 原生 LSP API**，无需 mason.nvim 或 nvim-lspconfig。

### 配置方式

```lua
-- 全局默认配置 (lua/lsp/common.lua)
vim.lsp.config('*', {
    root_markers = { '.git' },
    capabilities = { ... },
})

-- 语言特定配置 (lua/lsp/gopls.lua)
vim.lsp.config('gopls', {
    cmd = { "gopls", "serve" },
    filetypes = { "go", "gomod", "gowork", "gotmpl" },
    root_markers = { "go.work", "go.mod", ".git" },
    settings = { ... },
})
vim.lsp.enable('gopls')
```

### 支持的语言

| 语言 | LSP 服务器 | 特性 |
|------|-----------|------|
| Go | gopls | gofumpt 格式化、语义 token、staticcheck、自动 organize imports |
| Go (Lint) | golangci-lint-langserver | 读取项目 .golangci.yml 配置 |
| C/C++ | clangd | clang-tidy、后台索引 |
| Rust | rust-analyzer | Clippy 诊断、过程宏支持 |

### LSP 特性

- **统一事件处理**: 所有 LSP 按键映射在 `LspAttach` 事件中集中配置
- **Inlay Hints**: 默认关闭，使用 `<leader>ch` 切换
- **保存时格式化**: Go 文件保存时自动整理 imports 并格式化
- **Navbuddy 集成**: 仅附加到支持 `documentSymbol` 的服务器

### 诊断显示

```
 Error   Warning   Info  󰌵 Hint
```

诊断信息显示在行尾虚拟文本中，使用 `●` 前缀标识。

## 自定义配置

### 添加新的 LSP 服务器

在 `lua/lsp/` 目录下创建新文件，例如 `lua/lsp/pyright.lua`：

```lua
vim.lsp.config('pyright', {
    cmd = { "pyright-langserver", "--stdio" },
    filetypes = { "python" },
    root_markers = { "pyproject.toml", "setup.py", ".git" },
    settings = {
        python = {
            analysis = {
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
            },
        },
    },
})
vim.lsp.enable('pyright')
```

然后在 `lua/lsp/init.lua` 中引入：

```lua
require("lsp.pyright")
```

### 修改主题

编辑 `lua/colorscheme.lua`：

```lua
vim.cmd.colorscheme("onedark_vivid")  -- 当前主题
-- vim.cmd.colorscheme("tokyonight-storm")
-- vim.cmd.colorscheme("catppuccin-macchiato")
```

### 调整按键映射

全局按键映射位于 `lua/mapping.lua`。LSP 相关按键映射位于 `lua/lsp/common.lua` 的 `LspAttach` 回调中。

## 许可证

MIT License
