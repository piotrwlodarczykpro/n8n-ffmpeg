# Zostań przy swoim tagu, np. 1.116.0 (ten, którego używasz)
FROM n8nio/n8n:1.116.0

USER root
# Pobieramy statyczny ffmpeg/ffprobe dopasowany do architektury
RUN set -eux; \
    arch="$(uname -m)"; \
    if [ "$arch" = "x86_64" ] || [ "$arch" = "amd64" ]; then \
      url="https://johnvansickle.com/ffmpeg/releases/ffmpeg-release-amd64-static.tar.xz"; \
    elif [ "$arch" = "aarch64" ] || [ "$arch" = "arm64" ]; then \
      url="https://johnvansickle.com/ffmpeg/releases/ffmpeg-release-arm64-static.tar.xz"; \
    else \
      echo "Unsupported arch: $arch"; exit 1; \
    fi; \
    curl -fsSL "$url" -o /tmp/ffmpeg.tar.xz; \
    mkdir -p /opt/ffmpeg; \
    tar -xJf /tmp/ffmpeg.tar.xz -C /opt/ffmpeg --strip-components=1; \
    mv /opt/ffmpeg/ffmpeg /usr/local/bin/ffmpeg; \
    mv /opt/ffmpeg/ffprobe /usr/local/bin/ffprobe; \
    chmod +x /usr/local/bin/ffmpeg /usr/local/bin/ffprobe; \
    rm -rf /tmp/ffmpeg.tar.xz /opt/ffmpeg

USER node
