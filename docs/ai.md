# AI 服务设置

在启动 Neovim 的终端设置服务和密钥，再运行 `nvim`。以默认的 DeepSeek 预设为例：

```sh
export NVIM_AI_PROVIDER=deepseek
export DEEPSEEK_API_KEY='替换为你的 API 密钥'
nvim
```

进入 Neovim 后执行 `:checkhealth config`，检查服务、模型和密钥变量是否配置。健康检查只读本地配置，不会发送模型请求。密钥保存在本机环境变量中，不写进 Lua 文件。

## 选择服务

行内续写与 Duet 编辑预测共用所选服务和模型。下表列出 [ai_provider.lua](../lua/config/ai_provider.lua) 中的预设，模型名按服务商各自的 API 填写。

| `NVIM_AI_PROVIDER` | 服务 | 密钥环境变量 | 预设模型 |
| --- | --- | --- | --- |
| `deepseek`（默认） | [DeepSeek](https://api-docs.deepseek.com/api/create-chat-completion/) | `DEEPSEEK_API_KEY` | `deepseek-flash` |
| `siliconflow` | [SiliconFlow](https://docs.siliconflow.cn/docs/api/chat-completions-post) | `SILICONFLOW_API_KEY` | `deepseek-ai/DeepSeek-V4-Flash` |
| `opencode` | [OpenCode Zen](https://opencode.ai/docs/zen/) | `OPENCODE_API_KEY` | `deepseek-v4.1-flash` |
| `opencode_go` | [OpenCode Go](https://opencode.ai/docs/go/) | `OPENCODE_GO_API_KEY` | `deepseek-v4.1-flash` |
| `openai` | [OpenAI](https://developers.openai.com/api/docs/models/gpt-5.6-luna) | `OPENAI_API_KEY` | `gpt-5.6-luna` |

Minuet 是客户端，API 密钥、模型权限和额度由服务商提供。OpenCode 预设连接 Zen/Go 模型接口，密钥也从上表的环境变量读取。填写模型名时用 `deepseek-v4.1-flash` 这样的 API 名称，不加 `opencode/` 前缀。

其他服务的密钥已设置时，可以直接切换启动参数。下面每行都是一次独立的启动：

```sh
NVIM_AI_PROVIDER=siliconflow nvim
NVIM_AI_PROVIDER=opencode nvim
NVIM_AI_PROVIDER=opencode_go nvim
NVIM_AI_PROVIDER=openai nvim
```

## 续写与编辑预测

先试一次手动续写，便于确认请求有没有发出：

1. 打开可编辑的代码文件，按 `i` 进入 Insert 模式。
2. 输入代码或描述需求的注释，再按 `Ctrl-g n` 请求续写。先按 Ctrl-g，松开后按 n。
3. 状态栏显示 `AI 续写中…` 后，保持光标和文本不变，等待紫色建议出现。
4. 按 `Tab` 接受全部建议，或按 `Ctrl-y` 接受一行；`Ctrl-e` 取消建议。

受支持的文件类型会自动请求续写。进入 Insert 模式或输入后停顿 400 毫秒会安排请求，同时受 1500 毫秒节流限制；模型还需要时间返回结果。自动触发的文件类型见 [ai.lua](../lua/config/ai.lua) 的 `filetypes`。

Blink 菜单出现时，Minuet 会隐藏行内建议并跳过自动续写。按 `Ctrl-g n` 会先收起菜单，再请求或显示 AI 候选。菜单里的 `[LSP]`、`[路径]`、`[片段]`、`[缓冲区]` 都是普通补全来源，AI 续写显示在代码旁边。

Duet 用增删预览展示下一处编辑，默认手动触发。在 Normal 模式按 `Space ap` 请求，等待预览出现后按 `Space aa` 接受，或按 `Space ad` 取消。等待期间继续编辑会使旧预测失效；模型返回空结果、格式不符或与原文相同的内容时，也可能没有可见预览。

| Normal 模式按键 | 操作 |
| --- | --- |
| `Space at` | 切换当前文件的自动续写 |
| `Space ap` | 请求下一处编辑预测 |
| `Space aa` | 接受已有的编辑预览 |
| `Space ad` | 取消当前 AI 建议 |
| `Space an` | 切换当前文件的自动编辑预测 |

建议先确认手动请求能返回结果，再开启自动编辑预测。`Space at` 和 `Space an` 只切换当前缓冲区的开关，不会立即生成建议；自动编辑预测在后续文本变化时触发。Insert 模式的完整按键和 Tab 接受顺序见 [快捷键](keymaps.md#插入模式)。

### 读状态栏

| 显示 | 含义 |
| --- | --- |
| `AI 未配置` / `AI 待加载` | 服务或密钥缺失；或配置已就绪，但 Minuet 尚未加载 |
| `AI 自动` / `AI 手动` | 当前文件至少开启了一种自动触发；或只响应手动请求 |
| `AI 续写中…` / `AI 编辑预测中…` | 请求已发出，正在等待结束 |
| `AI 建议 · Tab` / `AI 编辑建议 · …` | 有可接受的建议；编辑预览在 Normal 模式提示 `Space aa`，Insert 模式提示 `Tab` |
| `AI 本文件停用` | 当前缓冲区不满足请求条件，例如 `.env`、特殊缓冲区或大文件 |

`AI 自动` 只表示触发开关已开启。接口是否可用，要看一次实际请求的结果；错误通知可用 `:messages` 查看。

请求会发送代码上下文，Duet 还会使用近期编辑记录。配置跳过 `.env`、`.env.*`、不可编辑或特殊缓冲区，以及大小达到 1,000,000 字节的文件。这些规则按文件名、类型和大小判断，不会扫描代码中的敏感内容。

## 修改模型或接口

`NVIM_AI_MODEL` 覆盖模型名，`NVIM_AI_ENDPOINT` 覆盖完整请求地址，`NVIM_AI_API_KEY_ENV` 指定密钥变量的名称。覆盖项优先于服务预设；切换服务前，若要恢复预设值，先清除旧设置：

```sh
unset NVIM_AI_MODEL NVIM_AI_ENDPOINT NVIM_AI_API_KEY_ENV
NVIM_AI_PROVIDER=openai nvim
```

| 服务 | 预设请求地址 |
| --- | --- |
| DeepSeek | `https://api.deepseek.com/chat/completions` |
| SiliconFlow | `https://api.siliconflow.cn/v1/chat/completions` |
| OpenCode Zen | `https://opencode.ai/zen/v1/chat/completions` |
| OpenCode Go | `https://opencode.ai/zen/go/v1/chat/completions` |
| OpenAI | `https://api.openai.com/v1/chat/completions` |

其他兼容 Chat Completions 的接口使用 `custom`，把下面的占位内容换成服务商给出的地址、模型名和密钥：

```sh
export NVIM_AI_PROVIDER=custom
export NVIM_AI_ENDPOINT='https://你的服务域名/v1/chat/completions'
export NVIM_AI_MODEL='服务商提供的模型名'
export NVIM_AI_API_KEY='替换为你的 API 密钥'
nvim
```

已有其他名称的密钥变量时，例如 `MY_MODEL_API_KEY`，设置 `NVIM_AI_API_KEY_ENV=MY_MODEL_API_KEY` 即可复用。这里填变量名，密钥本身仍放在该变量中。

模型要支持所选地址的 Chat Completions 流式协议和下节的思考参数。OpenCode 部分模型使用 Responses 或 Messages 接口，更换模型前要核对其 [端点说明](https://opencode.ai/docs/zen/#endpoints)。模型专用参数写在 `ai_provider.lua` 的 `optional` 表中；`custom` 默认发送 DeepSeek 风格字段，接入其他服务时需按其协议调整。

## 思考参数与等待时间

所有预设都发送开启思考的参数。DeepSeek 使用 `low` 推理强度，其余预设使用 `high`。这些是本仓库的请求设置，换模型后应核对服务商是否接受。

| 服务 | 思考参数 | `reasoning_effort` |
| --- | --- | --- |
| DeepSeek | `thinking = { type = "enabled" }` | `low` |
| OpenCode Zen/Go | `thinking = { type = "enabled" }` | `high` |
| SiliconFlow | `enable_thinking = true`，`thinking_budget = 8192` | `high` |
| OpenAI | 由 `reasoning_effort` 控制，不发送 `thinking` | `high` |
| 自定义接口 | `thinking = { type = "enabled" }` | `high` |

参数定义见 [DeepSeek](https://api-docs.deepseek.com/api/create-chat-completion/)、[SiliconFlow](https://docs.siliconflow.cn/docs/api/chat-completions-post) 和 [OpenAI 推理说明](https://developers.openai.com/api/docs/guides/reasoning)。

行内续写和 Duet 的超时都设为 120 秒。这个数是等待上限，实际耗时取决于接口和模型；提高推理强度可能增加等待与 token 消耗。需要调整时，修改 [ai.lua](../lua/config/ai.lua) 中两处 `request_timeout`。

SiliconFlow 将思考预算单独设为 8192 token，续写和 Duet 的文本上限分别为 256、2048 token。其余预设在这两个上限上各增加 8192，得到 8448、10240 token；OpenAI 使用 `max_completion_tokens`，其他预设使用 `max_tokens`。合计预算不代表模型会恰好使用 8192 个思考 token。

配置保留 `stream = true`。按锁定的 Minuet 版本，续写在请求结束后解析已收到的 SSE 数据，再显示建议；超时前若已收到代码，仍可尝试保留部分结果。Duet 后端固定使用 SSE。流式请求不会让行内建议逐字刷新，也不会显示思考文本。实现见 [续写后端](https://github.com/milanglacier/minuet-ai.nvim/blob/3b0a4c5f97b7124d94302c608fbe01c0270d4fbe/lua/minuet/backends/openai_base.lua) 与 [Duet 后端](https://github.com/milanglacier/minuet-ai.nvim/blob/3b0a4c5f97b7124d94302c608fbe01c0270d4fbe/lua/minuet/duet/backends/openai_base.lua)。

## 没有出现建议时

1. 运行 `:checkhealth config`，处理缺失的密钥或无效的服务配置。
2. 在可编辑代码文件中进入 Insert 模式，按 `Ctrl-g n`，检查状态栏是否出现 `AI 续写中…`。
3. 保持光标和文本不变，等待请求结束，最长 120 秒。
4. 运行 `:messages` 查看错误，再按下表处理。

| 消息或现象 | 检查与处理 |
| --- | --- |
| 401 / 403 | 检查密钥和账号权限，以服务端错误说明为准 |
| 404 | 核对模型名和完整请求地址，确认模型使用 Chat Completions 协议 |
| 429 | 检查额度和限流信息，按服务商提示重试 |
| 请求超时 / 达到 token 上限 | 检查思考与输出预算；按需调整推理强度或 `request_timeout` |
| 只有思考内容 / 没有补全文本 | 请求没有产生可插入的代码；修改上下文或模型设置后再试 |

`:checkhealth config` 通过后仍需实际请求验证接口。AI 接口失败时，Blink 的语言服务、路径和缓冲区补全仍可使用。

### 出现 `returns error on streaming`

锁定的 Minuet `3b0a4c5` 在没有提取到补全文本时，会搜索响应中的 `error` 单词。思考文本里出现这个词也可能误报，并打印整段原始响应。

[ai_stream.lua](../lua/config/ai_stream.lua) 替换了续写和 Duet 使用的流式解析函数：只把 JSON 的 `error` 字段当作接口错误，跳过思考内容和空块，保留补全文本。提示会区分接口错误、超时、token 上限和空结果；超时或预算耗尽仍可能没有建议。

更新 Minuet 后，检查上游解析器是否已修复同一问题，再决定是否移除兼容层。
