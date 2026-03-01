# syntax=docker/dockerfile:1

########################################
# 1. 构建阶段：编译 + 检查
########################################
FROM rust:slim-bookworm AS builder

ENV CARGO_TERM_COLOR=always
WORKDIR /app

COPY . .

RUN set -eux; \
    BIN_NAME=$(sed -n 's/^name *= *"\(.*\)"/\1/p' Cargo.toml | head -n 1); \
    VERSION=$(sed -n 's/^version *= *"\(.*\)"/\1/p' Cargo.toml | head -n 1); \
    echo "检测到二进制名称：$BIN_NAME"; \
    echo "检测到版本：$VERSION"; \
    echo "$VERSION" > /app/version.txt; \
    cargo fmt --all -- --check; \
    cargo clippy --all -- -D warnings; \
    cargo build --release --bin "$BIN_NAME"; \
    cp "target/release/$BIN_NAME" /app/app

########################################
# 2. 运行阶段：运行时
########################################
FROM debian:bookworm-slim AS runtime

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY --from=builder /app/app /usr/local/bin/app
COPY --from=builder /app/version.txt /app/version.txt

RUN chmod +x /usr/local/bin/app

# ★ 关键：把 version 写入镜像 LABEL
ARG APP_VERSION
LABEL org.opencontainers.image.version=$APP_VERSION

CMD ["app"]
