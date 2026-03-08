FROM alpine:latest AS extra-tools
ARG TARGETARCH
ARG COMPOSE_VERSION=v2.40.3

RUN apk add --no-cache curl
# 下载对应架构的 docker-compose V2 二进制文件
RUN if [ "$TARGETARCH" = "amd64" ]; then ARCH="x86_64"; \
    elif [ "$TARGETARCH" = "arm64" ]; then ARCH="aarch64"; fi \
    && curl -fLo /docker-compose "https://github.com/docker/compose/releases/download/${COMPOSE_VERSION}/docker-compose-linux-${ARCH}" \
    && chmod +x /docker-compose
FROM ghcr.io/actions/actions-runner:latest

USER root

RUN apt-get update && apt-get install -y --no-install-recommends \
    rsync \
    jq \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /usr/local/lib/docker/cli-plugins/
COPY --from=extra-tools /docker-compose /usr/local/lib/docker/cli-plugins/docker-compose

# ARG DOCKER_GID=123
# RUN groupmod -g ${DOCKER_GID} docker || true && \
# usermod -aG docker runner

USER runner