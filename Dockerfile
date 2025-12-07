# Etap 1: pobierz statyczne ffmpeg/ffprobe (curl + xz w Alpine)
FROM alpine:3.20 AS ffmpeg-get
RUN apk add --no-cache curl xz tar
ARG TARGETARCH
RUN set -eux; \
    case "$TARGETARCH" in \
      amd64) url="https://johnvansickle.com/ffmpeg/releases/ffmpeg-release-amd64-static.tar.xz" ;; \
      arm64) url="https://johnvansickle.com/ffmpeg/releases/ffmpeg-release-arm64-static.tar.xz" ;; \
      *) echo "Unsupported arch: $TARGETARCH" && exit 1 ;; \
    esac; \
    curl -fsSL "$url" -o /tmp/ffmpeg.tar.xz; \
    mkdir -p /ffmpeg && tar -xJf /tmp/ffmpeg.tar.xz -C /ffmpeg --strip-components=1; \
    test -x /ffmpeg/ffmpeg && test -x /ffmpeg/ffprobe

# Etap 2: właściwy obraz n8n (TAKIEJ wersji, jakiej używasz produkcyjnie)
FROM n8nio/n8n:1.122.5
USER root
COPY --from=ffmpeg-get /ffmpeg/ffmpeg  /usr/local/bin/ffmpeg
COPY --from=ffmpeg-get /ffmpeg/ffprobe /usr/local/bin/ffprobe
RUN chmod +x /usr/local/bin/ffmpeg /usr/local/bin/ffprobe
USER node
