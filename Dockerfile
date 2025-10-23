# użyj wersji Alpine, która istnieje
FROM n8nio/n8n:1.116.0-alpine

USER root
# ffmpeg z repo Alpine (szybko i lekko)
RUN apk add --no-cache ffmpeg bash
USER node
