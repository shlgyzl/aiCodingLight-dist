# aiCodingLight 一键安装（Windows）
#
#   irm https://shlgyzl.github.io/aiCodingLight-dist/install.ps1 | iex
#
# 免签名也能直接跑：irm/Invoke-WebRequest 下载的 exe 通常不带「网络来源标记(MOTW)」，
# 不会触发 SmartScreen；脚本再 Unblock-File 双保险。对应 macOS 上「curl 下载不带隔离属性」。
$ErrorActionPreference = 'Stop'
try { [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12 } catch {}

$repo   = 'shlgyzl/aiCodingLight-dist'
$binUrl = if ($env:AICL_BIN_URL) { $env:AICL_BIN_URL } else { "https://github.com/$repo/releases/latest/download/aiCodingLight.exe" }
$dest   = if ($env:AICL_DEST)    { $env:AICL_DEST }    else { Join-Path $env:LOCALAPPDATA 'aiCodingLight' }
$bin    = Join-Path $dest 'aiCodingLight.exe'

Write-Host '→ 下载 aiCodingLight ...'
New-Item -ItemType Directory -Force -Path $dest | Out-Null
Invoke-WebRequest -Uri $binUrl -OutFile $bin -UseBasicParsing
# 双保险：去掉可能的网络来源标记，避免 SmartScreen
Unblock-File -Path $bin -ErrorAction SilentlyContinue

Write-Host "OK 已安装到 $bin"
Write-Host '→ 装 hook + 生成二维码页 ...'
& $bin
