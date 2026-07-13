#!/bin/sh
# aiCodingLight 一键安装（macOS）
#
#   curl -fsSL https://shlgyzl.github.io/aiCodingLight-dist/install.sh | sh
#
# 为什么免公证也能直接跑：Gatekeeper 只拦「带隔离属性(com.apple.quarantine)」的下载物，
# 而这个标记是浏览器打上的——curl 下载的文件不带它，所以 ad-hoc 签名的二进制直接可执行，
# 无需 Apple 公证（$99/年），也不用手动「右键→打开 / 仍要打开」。
set -eu

REPO="shlgyzl/aiCodingLight-dist"
BIN_URL="${AICL_BIN_URL:-https://github.com/$REPO/releases/latest/download/aicodinglight-macos}"
DEST="${AICL_DEST:-$HOME/.local/bin}"
BIN="$DEST/aicodinglight"

os="$(uname -s)"
if [ "$os" != "Darwin" ]; then
  echo "此脚本用于 macOS（你的系统：$os）。Windows 见官网 PowerShell 一键。" >&2
  exit 1
fi
command -v curl >/dev/null 2>&1 || { echo "需要 curl" >&2; exit 1; }

echo "→ 下载 aiCodingLight ..."
mkdir -p "$DEST"
curl -fsSL "$BIN_URL" -o "$BIN.tmp"
mv "$BIN.tmp" "$BIN"
chmod +x "$BIN"
# 双保险：即使经由带隔离属性的渠道拿到，也去掉它
xattr -d com.apple.quarantine "$BIN" 2>/dev/null || true

echo "✓ 已安装到 $BIN"

# 若 ~/.local/bin 不在 PATH，给出提示（不擅自改用户 shell 配置）
case ":$PATH:" in
  *":$DEST:"*) ;;
  *) echo "提示：$DEST 不在 PATH。永久生效可执行："
     echo "      echo 'export PATH=\"\$HOME/.local/bin:\$PATH\"' >> ~/.zshrc" ;;
esac

echo "→ 装 hook + 生成二维码页 ..."
exec "$BIN"
