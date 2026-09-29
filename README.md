# Neovim 配置

面向 Go、Rust、C/C++ 和 Lua 开发的个人配置，需要 Neovim 0.12 或更新版本。文件侧栏用 Neo-tree，搜索用 Telescope，普通补全用 Blink；Minuet 提供 AI 行内续写和下一处编辑预测。

先运行 `:checkhealth config` 检查本机依赖。查按键用 `:Keymaps`，配置模型和密钥看 [AI 服务设置](docs/ai.md)。

## 开始使用

1. 准备 Neovim 0.12+、Git、ripgrep、curl、make 和 C 编译器。终端字体选 Nerd Font；`fd` 或 `fdfind` 可选，未安装时用 ripgrep 查找文件。
2. 在这套配置已放入 Neovim 配置目录的机器上运行 `nvim`，等待 lazy.nvim 安装插件。Blink Pairs 首次安装需要下载原生库。
3. 执行 `:Lazy restore`，将插件版本对齐到仓库的 `lazy-lock.json`。
4. 执行 `:checkhealth config`，按提示安装所需语言工具并加入 `PATH`，然后重启 Neovim。
5. 打开代码文件，按 `Space ff` 查找文件、`Space fg` 搜索项目文本，或按 `Space ?` 查看快捷键。

`Space` 是 Leader。例如 `Space ff` 要依次按空格、f、f。编辑仍按 Normal、Insert、Visual 模式操作，完整按键见 [快捷键](docs/keymaps.md)。

## AI 自动续写

已在终端设置 `DEEPSEEK_API_KEY` 时，用下面的命令启动：

```sh
NVIM_AI_PROVIDER=deepseek nvim
```

默认预设是 DeepSeek 官方接口和 `deepseek-flash`，开启思考模式，推理强度为 `low`。配置也提供 SiliconFlow、OpenCode Zen/Go、OpenAI 预设，并支持自定义 Chat Completions 接口。服务、模型和参数以 [AI 服务设置](docs/ai.md) 为准。

在代码文件中进入 Insert 模式，紫色行内文字就是 AI 建议。按 `Tab` 接受全部，`Ctrl-y` 接受一行，`Ctrl-e` 取消；手动请求用 `Ctrl-g n`，先按 Ctrl-g，松开后再按 n。Blink 菜单中的 `[LSP]`、`[路径]`、`[片段]` 和 `[缓冲区]` 标注普通补全来源，未设置 AI 密钥时仍可使用。

Tab 优先接受可见的 AI 建议，再处理 Blink 菜单、snippet 占位符和缩进。没有活动 snippet 时，它会选择并接受菜单项；处于 snippet 中时，只接受已选中的菜单项，否则跳到下一占位符。Enter 接受手动选中的菜单项，没有选中项就换行。

下一处编辑预测默认手动触发：Normal 模式下按 `Space ap` 请求，出现增删预览后按 `Space aa` 接受，或 `Space ad` 取消。初次使用和排错步骤见 [续写与编辑预测](docs/ai.md#续写与编辑预测)。

## 语言工具

语言服务从 `PATH` 查找，配置不会代为安装。按实际使用的语言准备工具即可。

| 语言 | 所需工具 | 配置行为 |
| --- | --- | --- |
| Go | `gopls` | 保存时整理 imports 并格式化；启用 gofumpt、staticcheck 和类型提示相关设置；`Space tt` 为当前函数生成测试 |
| Go lint | `golangci-lint-langserver`、`golangci-lint` v2 | 使用项目的 lint 配置，通过语言服务显示诊断 |
| Rust | `rust-analyzer`、Rust 工具链和 Clippy | 保存格式化，使用 Clippy 检查，启用过程宏与类型提示相关设置 |
| C/C++ | `clangd`、项目编译数据库 | 启用后台索引和 clang-tidy，编译数据库目录设为 `build` |
| Lua | `lua-language-server` | 识别 Neovim runtime 和 `vim` 全局变量 |

语言服务连接后，`gd` 跳到定义，`gr` 查看引用，`K` 查看文档。`Space cf` 手动格式化；支持类型提示的服务可用 `Space ch` 切换显示。

要增加语言服务，在 `lsp/` 新建返回配置表的 Lua 文件，再把服务名和文件类型加入 [lua/config/lsp.lua](lua/config/lsp.lua)。配置通过 Neovim 原生的 `vim.lsp.config` 和 `vim.lsp.enable` 加载，规则见 [Neovim LSP 文档](https://neovim.io/doc/user/lsp/)。

## 看代码结构

`Space cn` 打开 Trouble 符号树，`Space cs` 搜索当前文档的符号。将光标放在函数声明的名称上，按 `Space ci` 查看谁调用它，`Space co` 查看它调用谁。调用树默认展开三层，可用 `l/h` 继续展开或收起；其余操作见 [递归调用树](docs/keymaps.md#递归调用树)。

折叠优先使用 LSP 提供的范围，没有可用服务时按缩进计算。文件初始全部展开。`za` 切换当前折叠，`zR/zM` 展开或收起全部；`zK` 预览已收起的内容，再按一次进入浮窗。光标处没有收起的折叠时，`zK` 显示 LSP 文档。

注释使用 Neovim 原生操作：`gcc` 注释当前行，Visual 模式下 `gc` 注释所选行，`gcip` 注释当前段落。Go 文件中的 `Space tt` 调用 gopls 的 `source.addTest` 生成当前函数测试，需要 gopls 支持该操作。

## 修改与维护

| 路径 | 内容 |
| --- | --- |
| [init.lua](init.lua) | 版本检查与启动入口 |
| [lua/config/](lua/config/) | 编辑选项、按键、LSP、AI 和插件设置 |
| [lua/plugins/](lua/plugins/) | 按补全、编辑、Git、导航、界面分组的插件声明 |
| [lsp/](lsp/) | 各语言服务的启动参数与设置 |
| [lazy-lock.json](lazy-lock.json) | 22 个插件仓库的锁定版本，包含管理器和依赖 |

换机器时一并复制 `lazy-lock.json`。`:Lazy restore` 恢复锁定版本；用 `:Lazy` 更新插件后，把锁文件的变化一起纳入版本管理。具体行为见 [lazy.nvim 锁文件说明](https://lazy.folke.io/usage/lockfile)。

安装 StyLua 后，在配置根目录检查 Lua 格式：

```sh
stylua --check init.lua lua/config lua/plugins lsp
```

从旧配置迁移后，先重启 Neovim，在 `:Lazy` 中核对不再使用的插件，再按需执行 `:Lazy clean`。注释和折叠已改用原生功能，原来的 `gb/gbc` 块注释、`gco/gcO/gcA` 插入注释和 `Space ta` 整文件测试生成入口已移除。Flash 文本跳转可直接使用，语法树选择需要对应语言的 Tree-sitter parser。

全局按键以 Space 为前缀，Normal 模式保留 `Ctrl-v`、`s/S`、`f/F/t/T` 和 `Ctrl-i` 的原有行为。若某个按键无效，先用 `Space fk` 查映射，再检查终端或桌面环境是否拦截了输入。
