# 快捷键

按 `Space ?` 查看分组，按 `Space fk` 搜索映射，执行 `:Keymaps` 打开本页。除特别标注外，按键都在 Normal 模式使用。

`Space ff` 表示依次按空格、f、f；`Ctrl-g n` 表示先按 Ctrl-g，松开后再按 n。表中的 `/` 用来分隔不同按键。which-key 标注的“原生”是 Neovim 自带操作，“原生 API”是本配置调用 Neovim API 实现的组合操作。

## 导航面板的共同操作

Telescope 搜索和调用树、Trouble 诊断与符号面板使用同一套打开规则：

| 按键 | 操作 |
| --- | --- |
| `Enter` / `o` | 打开目标，焦点回到代码，并关闭当前导航面板 |
| 分组上的 `Enter` / `o` | 展开或收起节点，保留面板 |
| `P` | 切换预览，保留面板 |
| 树形面板中的 `h/l` | 收起 / 展开节点，不打开文件 |

`o`、`P` 和 `h/l` 用于 Normal 模式。Telescope 搜索框中输入字母仍会修改搜索内容，按 `Esc` 回到 Normal 模式后再用这些键。调用树里的函数节点有代码位置，`Enter/o` 用于跳转，展开子调用用 `l`。

Neo-tree 保留原有操作：`Enter/l` 打开文件，侧栏保持显示；`o` 是排序菜单前缀。详见 [文件树与搜索窗口](#文件树与搜索窗口)。

## 常用操作

| 按键 | 操作 |
| --- | --- |
| `Space w` / `Space q` / `Space d` | 保存文件 / 关闭窗口 / 保存并关闭当前文件 |
| `Space e` / `Space l` | 打开或关闭文件侧栏 |
| `Space ff` / `Space fg` / `Space fb` / `Space ft` | 查找文件 / 搜索项目文本 / 查找已打开文件 / 查找 Tags |
| `Space /` / `Space fc` / `Space fk` | 搜索当前文件 / 查找命令 / 查找快捷键 |
| `Space y` / `Space p` | 复制到系统剪贴板 / 从系统剪贴板粘贴 |

Normal 模式下，`Space y` 是复制操作符，需要接动作，例如 `Space y y` 复制整行；Visual 模式下直接复制选区。`Space p` 两种模式都可用。`Space q` 不会自动保存，未保存的修改可能阻止窗口关闭。

## 文件标签与窗口

| 按键 | 操作 |
| --- | --- |
| `Space 1` … `Space 9` | 跳到指定文件标签 |
| `Space bp` / `Space bn` / `Space bh` / `Space bl` | 上一个文件 / 下一个文件 / 标签左移 / 标签右移 |
| `Space vh` / `Space vj` / `Space vk` / `Space vl` | 焦点左移 / 下移 / 上移 / 右移，也可用原生 `Ctrl-w h/j/k/l` |
| `Space vs` / `Space vv` / `Space v=` | 上下分屏 / 左右分屏 / 均分窗口 |
| `Space ve`，终端内 `Esc Esc` | 新建终端分屏；离开终端输入模式 |

## LSP 与诊断

定义跳转、重命名等按键在语言服务连接后可用。`Space ch` 还需要服务支持类型提示。

| 按键 | 操作 |
| --- | --- |
| `gd` / `gD` / `gr` / `gi` / `K` | 定义 / 声明 / 引用 / 实现 / 悬浮文档 |
| `Space cr` / `Space ca` / `Space cf` / `Space cs` / `Space ch` | 重命名 / 代码操作 / 格式化 / 搜索文档符号 / 切换类型提示 |
| `Space cn` / `Space cD` / `Space cR` / `Space cd` | 符号树 / 定义列表 / 声明列表 / 光标处诊断详情 |
| `Space ci` / `Space co` | 查看谁调用当前函数 / 当前函数调用谁 |
| `[d` / `]d`，`Space xx` / `Space xs` / `Space xq` / `Space xl` | 上一个 / 下一个诊断；诊断 / 符号 / Quickfix / Location 面板 |

`Space ca` 也可在 Visual 模式对选区执行代码操作。

## 递归调用树

把光标放在函数声明的名称上，按 `Space ci` 或 `Space co`。左侧显示调用关系，右侧预览代码，默认展开三层。更深的分支可以手动展开；同一条路径里重复出现的函数会标记为循环，该节点停止展开。

调用树默认进入 Normal 模式：

| 按键 | 操作 |
| --- | --- |
| `j/k` 或 `↓/↑` | 选择节点 |
| `l/→`，`h/←` | 展开一层；收起当前节点 |
| `E` / `t` | 从当前节点展开三层 / 切换展开状态 |
| `Enter/o` / `d` | 跳到调用位置 / 函数定义，并关闭调用树 |
| `s`，`q/Esc` | 以选中节点为根切换调用方向；关闭窗口 |

例如，查看 `Root` 调用的函数时，逐层展开后会保留父子关系：

```text
Root
├─ Middle
│  └─ Deep
│     └─ Leaf
└─ Leaf
```

这需要语言服务支持 LSP Call Hierarchy。Go 使用 gopls，其结果是[静态调用关系](https://go.dev/gopls/features/navigation#call-hierarchy)，可能缺少动态调用，也不表示运行时的执行顺序。查看文件本身的符号结构用 `Space cn`。

## 折叠

| 按键 | 操作 |
| --- | --- |
| `za` / `zA` | 切换当前折叠 / 递归切换当前折叠 |
| `zo` / `zO` | 展开当前折叠一层 / 递归展开 |
| `zc` / `zC` | 收起当前折叠一层 / 递归收起 |
| `zr` / `zm`，`zR` / `zM` | 逐级展开 / 收起；全部展开 / 收起 |
| `zK` | 预览光标处已收起的折叠；没有收起的折叠时显示 LSP 文档 |

`zr/zm` 调整整个窗口的 `foldlevel`，`zo/zc` 只处理光标处。要保留前两层展开，先按 `zM`，再按 `2zr`；`2zm` 则是在当前层级上减 2。文件初始全部展开，继续按 `zr` 可能看不出变化。

`zK` 预览浮窗最多高 20 行，再按一次进入浮窗，可滚动查看其余内容，按 `q` 关闭。折叠范围优先使用 LSP，没有支持的服务时按缩进计算。折叠行显示 Neovim 默认文字与行数。

## 编辑与 Git

| 按键 | 操作 |
| --- | --- |
| `Space jj` / `Space jt` | Flash 文本跳转 / 语法树选择；也可用于 Visual 模式和操作符后 |
| 操作符后 `Space jr` | Flash 远程操作，例如 `d Space jr` |
| `gcc`，Visual 模式 `gc`，`gc{motion}` | 原生注释当前行、选区或动作覆盖的行，例如 `gcip` 注释当前段落 |
| `[h` / `]h`，`Space gd` / `Space gn` / `Space gp` / `Space gr` / `Space gs` | 上一处 / 下一处 Git 修改；diff / 下一处修改 / 预览 / 重置 / 暂存修改块 |
| Go 文件 `Space tt` | 调用 gopls 的 `source.addTest`，为光标所在函数生成测试 |

`Space gr` 会丢弃当前修改块的改动，使用前可按 `Space gp` 预览。Flash 语法树选择需要对应语言的 Tree-sitter parser。

注释符号由文件类型决定。旧的 `gb/gbc` 块注释和 `gco/gcO/gcA` 插入注释按键已移除。Go 测试生成需要 gopls 连接并支持 `source.addTest`；生成后检查并保存测试文件。原来的 `Space ta` 整文件生成入口已移除。

## 插入模式

| 按键 | 操作 |
| --- | --- |
| `Tab` / `Shift-Tab` | 按优先级接受建议或前进 / 返回 snippet 占位符，或选择上一个菜单项 |
| `Enter` | 接受已选中的补全项，没有选中项时换行 |
| `↑/↓`、`Ctrl-p/n` 或 `Ctrl-k/j` | 选择上一个 / 下一个补全项；`Ctrl-n` 也可打开菜单 |
| `Ctrl-y`，`Ctrl-g n` / `Ctrl-g p` | 接受一行 AI 续写；请求或切换 AI 候选 |
| `Ctrl-e`，`PageUp/PageDown` | 取消 AI 建议和补全菜单；滚动补全文档 |

Tab 按下面的顺序处理，成功一步就停止：

1. 接受可见的 AI 行内建议或 Duet 编辑预览。
2. 处理 Blink 菜单：处于 snippet 中时只接受已选项，否则选择并接受菜单项。
3. 跳到下一个 snippet 占位符。
4. 执行普通 Tab 输入。

Shift-Tab 先回到上一个 snippet 占位符，再选择上一个菜单项。普通 `j/k` 仍用于输入字符，选择候选时按住 Ctrl。

AI 续写显示为紫色行内文字，状态栏提示 `AI 建议 · Tab`。Blink 菜单会标出普通补全来源。菜单打开时，`Ctrl-g n/p` 会先收起菜单，再请求或切换 AI 建议；密钥、模型和自动触发设置见 [AI 服务设置](ai.md)。

命令行补全也支持方向键、`Ctrl-j/k` 和 `Ctrl-n/p`。菜单关闭时，方向键继续浏览命令历史。Normal 模式没有重绑 Tab，与它同码的 `Ctrl-i` 仍用于跳转历史前进。

## 文件树与搜索窗口

Neo-tree 侧栏用 `Space e` 打开，浮动文件树用 `Space fe`。在树中按 `?` 查看完整按键。

| Neo-tree 按键 | 操作 |
| --- | --- |
| `Enter/l`，`h`，`P` | 打开节点；收起节点；切换预览 |
| `s/v/t` | 在上下分屏 / 左右分屏 / 新标签页打开文件 |
| `a/A`，`r` | 新建文件 / 目录；重命名 |
| `y/x/p`，`d` | 复制 / 剪切 / 粘贴；删除时确认 |
| `<` / `>` | 切换文件系统、已打开文件、Git 状态等数据源 |

文件树用 `o` 打开排序菜单：`on` 按名称、`om` 按修改时间、`os` 按大小排序。文件系统、已打开文件和 Git 状态视图都保留这组按键。

Telescope 搜索窗口默认进入 Insert 模式。Enter 打开结果并关闭窗口；按 `Esc` 切到 Normal 模式后，`o` 与 Enter 相同，`P` 切换右侧预览。

| Telescope Insert 模式按键 | 操作 |
| --- | --- |
| `Ctrl-j/k` 或 `↓/↑` | 选择结果 |
| `Enter`，`Ctrl-x`，`Ctrl-w` | 打开；上下分屏打开；左右分屏打开 |
| `Ctrl-g` | 将结果送到 Trouble |
| `PageUp/PageDown` | 滚动预览 |
| `Ctrl-/` | 打开按键帮助 |
