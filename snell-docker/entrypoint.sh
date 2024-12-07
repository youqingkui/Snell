#!/bin/sh

set -x  # 启用调试模式，显示执行的命令

# 检查二进制文件是否存在
file /usr/local/bin/snell
ls -l /usr/local/bin/snell
file /usr/local/bin/shadowtls
ls -l /usr/local/bin/shadowtls

# 检查系统架构
uname -a

# 默认配置
SNELL_PORT=${SNELL_PORT:-6666}
SNELL_PSK=${SNELL_PSK:-$(tr -dc A-Za-z0-9 </dev/urandom | head -c 31)}
SNELL_IPV6=${SNELL_IPV6:-false}
SNELL_OBFS=${SNELL_OBFS:-off}
SNELL_TFO=${SNELL_TFO:-false}

# 创建snell配置文件
cat > /etc/snell/snell-server.conf <<EOF
[snell-server]
listen = 0.0.0.0:${SNELL_PORT}
psk = ${SNELL_PSK}
ipv6 = ${SNELL_IPV6}
obfs = ${SNELL_OBFS}
tfo = ${SNELL_TFO}
EOF

# 显示配置文件内容
echo "=== Snell配置文件内容 ==="
cat /etc/snell/snell-server.conf
echo "========================="

# 启动shadowtls
STLS_LISTEN=${STLS_LISTEN:-0.0.0.0:9999}
TLS_DOMAIN=${TLS_DOMAIN:-gateway.icloud.com}
STLS_PASSWORD=${STLS_PASSWORD:-$(tr -dc A-Za-z0-9 </dev/urandom | head -c 8)}

echo "Starting shadowtls..."
/usr/local/bin/shadowtls --fastopen --v3 server \
    --listen ${STLS_LISTEN} \
    --server 127.0.0.1:${SNELL_PORT} \
    --tls ${TLS_DOMAIN} \
    --password ${STLS_PASSWORD} &

echo "Starting snell..."
exec /usr/local/bin/snell -c /etc/snell/snell-server.conf -l verbose