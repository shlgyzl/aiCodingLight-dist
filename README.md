# aiCodingLight — 下载与使用

**AI 编码状态推送到手机 —— 别守着 AI 跑。**

给电脑上的 AI coding 工具装个 hook，扫码配对手机，之后 AI 在干活时 🟡、需要你确认时 🔴、干完时 🟢，状态直接推到手机。你可以去干别的，该回来的时候手机会叫你。

官网：<https://shlgyzl.github.io/aiCodingLight-dist/> · 源码：<https://github.com/shlgyzl/aiCodingLight>

> 这个仓库只放**分发物**（安装脚本、版本清单、官网页面）和 **Releases 里的安装包**。

---

## 一、电脑端

推荐一行命令装。命令行下载的文件不带隔离属性，绕过 Gatekeeper / SmartScreen，**不会弹"无法验证开发者"**。

```bash
# macOS
curl -fsSL https://shlgyzl.github.io/aiCodingLight-dist/install.sh | sh
```

```powershell
# Windows (PowerShell)
irm https://shlgyzl.github.io/aiCodingLight-dist/install.ps1 | iex
```

它会自动检测本机装了哪些 AI 工具、把 hook 写进各自配置（**改动前自动备份**），然后弹出网页让你注册并出二维码。

也可以从 [Releases](https://github.com/shlgyzl/aiCodingLight-dist/releases/latest) 直接下 `.dmg` / `.exe`，但因为没做 Apple 公证 / 代码签名，首次需要手动「仍要打开 / 仍要运行」。命令行安装没有这一步。

## 二、手机端（Android）

下载 [**Android APK**](https://github.com/shlgyzl/aiCodingLight-dist/releases/tag/android-v0.8.1)，直装即可（需允许「未知来源」）。

装好后打开 App → 点「📷 扫码配对」→ 对准电脑上的二维码 —— 完成。

**装完请顺手开这三项**，否则国产 ROM 会把后台长连接杀掉、消息就断了：

- 电池优化豁免（允许后台运行）
- 自启动
- 后台弹出界面

## 三、开始用

配对完就什么都不用管了。在电脑上照常使用 AI 编码工具，状态会自己推过来：

| 灯 | 含义 | 什么时候出现 |
|---|---|---|
| 🟡 黄 | AI 工作中 | 你提交了 prompt，它开始干活 |
| 🔴 红 | 需要你确认 | 它卡住了，在等你拍板 |
| 🟢 绿 | 完成 | 这一轮干完了，附带你问了什么、它答了什么、改了哪些文件 |

手机上还能：**远程点允许/拒绝**推进卡住的任务、**追加一句指令**让它接着干、**逐行看代码 diff**、**把新任务派回某台电脑**。

---

## 支持的 AI 工具

接入靠各工具自己的 hook 机制，能力如实标注：

| 工具 | 状态通知 | 远程确认 Yes/No |
|---|:---:|:---:|
| Claude Code | ✅ | ✅ |
| Gemini CLI | ✅ | — |
| 通义灵码（Qoder CN） | ✅ | — |
| Copilot CLI | ✅ | — |
| Cursor CLI | ✅ | — |
| Codex CLI | ✅ | — |
| Aider | ✅ | — |

**远程确认**（仅 Claude Code）：跟随 Claude 自己的判断，**不用改任何配置**——它会自动放行的操作不打扰你，只有它本来就要停下来问你的，才推到手机。你点允许就继续，点拒绝就拦下，**超时按拒绝处理**（安全优先）。

默认不开，按需开启：二维码页面上有开关，或命令行 `aicodinglight approve-on`。

## 隐私

- **代码不出本机**。外发的只有通知，且**端到端加密**（Curve25519），服务器只见密文。
- 配对码不出这台电脑——出码的网页只监听 `127.0.0.1`。
- 手机可随时在「我的设备」里撤销，撤销后立即收不到。

## 命令行

```
aicodinglight              装 hook + 出二维码
aicodinglight doctor       自检：一条命令查清为什么收不到消息
aicodinglight update       检查更新（平时会自动更新）
aicodinglight approve-on   开远程确认（approve-off 关）
aicodinglight uninstall    移除各工具里的 hook
```

## 收不到消息怎么办

**先在电脑上跑 `aicodinglight doctor`**。推送为了不拖慢 AI 工具，所有失败都是静默的，肉眼看不出断在哪；doctor 把整条链路摊开，第一个 ✗ 就是断点：

```
✓ 配置         账号模式 acct-xxx · topic aicl-xxx
✓ relay        可达（424ms）
✓ hook         Claude Code、通义灵码
✓ daemon       运行中
✓ 手机公钥     本地与服务器一致
✓ 消息         留存窗口内 10 条，最新 3 分钟前
```

按它的提示走即可。几种常见情况：

- **消息在服务端有，但手机没响** → App 的监听被系统杀了。检查上面说的三项权限，并打开 App 看首页的连接状态。
- **手机公钥对不上** → 手机重新配过对。跑 `aicodinglight sync-key`（0.8.1 起会自动对齐）。
- **hook 指向的程序不存在** → 二进制被挪走或删了，重跑一次 `aicodinglight`。

## 锁屏上那条常驻通知

那是 Android 对长连接服务的**硬性要求**——没有它，系统会把监听服务杀掉，你就收不到消息了，所以删不掉。

0.8.1 起它默认不在锁屏显示。如果你的 ROM 仍然显示，手动关：**设置 → 应用管理 → aiCodingLight → 通知管理 → 「后台服务」→ 锁屏通知 → 不显示**。

⚠️ 只关「后台服务」这一个渠道。别关「任务状态」——那才是 🔴🟢 的真正推送。

---

## 版本

- 电脑端最新版见 [Releases](https://github.com/shlgyzl/aiCodingLight-dist/releases/latest)，装过的会自动更新（每 24 小时检查一次）。
- 安卓端是**内测**版本，更新需要手动下新 APK 覆盖安装（同一签名，不必卸载，配对状态保留）。

问题反馈 → [提 issue](https://github.com/shlgyzl/aiCodingLight/issues)
