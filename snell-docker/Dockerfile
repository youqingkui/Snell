FROM debian:bookworm-slim

# 安装必要的依赖
RUN apt-get update && \
    apt-get install -y curl unzip file && \
    rm -rf /var/lib/apt/lists/*

# 设置工作目录
WORKDIR /app

# 下载并安装snell-server
ENV SNELL_VERSION=v4.1.1
RUN echo "Architecture: $(uname -m)" && \
    curl -L -H "Cache-Control: no-cache" -o snell.zip \
    https://raw.githubusercontent.com/Slotheve/Snell/main/snell-server-${SNELL_VERSION}-linux-arm64.zip && \
    echo "Listing directory contents:" && \
    ls -la && \
    unzip snell.zip && \
    echo "Listing directory after unzip:" && \
    ls -la && \
    file snell-server && \
    mv snell-server /usr/local/bin/snell && \
    chmod +x /usr/local/bin/snell && \
    echo "Verifying snell installation:" && \
    ls -l /usr/local/bin/snell && \
    ldd /usr/local/bin/snell 2>/dev/null || echo "Not a dynamic executable" && \
    rm snell.zip

# 下载并安装shadowtls 
RUN TAG_URL="https://api.github.com/repos/ihciah/shadow-tls/releases/latest" && \
    DOWN_VER=$(curl -s "${TAG_URL}" --connect-timeout 10| grep -Eo '\"tag_name\"(.*?)\",' | cut -d\" -f4) && \
    curl -L -o /usr/local/bin/shadowtls \
    https://github.com/ihciah/shadow-tls/releases/download/${DOWN_VER}/shadow-tls-aarch64-unknown-linux-musl && \
    chmod +x /usr/local/bin/shadowtls && \
    ls -l /usr/local/bin/shadowtls  # 验证文件是否存在和权限

# 复制启动脚本
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# 创建配置目录
RUN mkdir -p /etc/snell

EXPOSE 6666 9999

ENTRYPOINT ["/entrypoint.sh"] 