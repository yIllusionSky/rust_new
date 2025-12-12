# syntax=docker/dockerfile:1

# -----------------------------
# 1) Chef base: musl toolchain + cargo-chef
# -----------------------------
FROM clux/muslrust:stable AS chef
USER root

# cargo-chef 用于依赖缓存
RUN cargo install cargo-chef

WORKDIR /app

# -----------------------------
# 2) Planner: 生成 recipe.json
# -----------------------------
FROM chef AS planner
COPY . .
RUN cargo chef prepare --recipe-path recipe.json

# -----------------------------
# 3) Builder: cook + build (musl target) + 记录 bin/version
# -----------------------------
FROM chef AS builder
COPY --from=planner /app/recipe.json recipe.json

# 依赖缓存层（注意 --target）
RUN cargo chef cook --release --target x86_64-unknown-linux-musl --recipe-path recipe.json

# 复制源码开始真正构建
COPY . .

RUN set -eux; \
    BIN_NAME=$(sed -n 's/^name *= *"\(.*\)"/\1/p' Cargo.toml | head -n 1); \
    VERSION=$(sed -n 's/^version *= *"\(.*\)"/\1/p' Cargo.toml | head -n 1); \
    echo "检测到二进制名称：$BIN_NAME"; \
    echo "检测到版本：$VERSION"; \
    echo "$VERSION" > /app/version.txt; \
    echo "$BIN_NAME" > /app/bin_name.txt; \
    cargo build --release --target x86_64-unknown-linux-musl --bin "$BIN_NAME"; \
    cp "target/x86_64-unknown-linux-musl/release/$BIN_NAME" "/app/$BIN_NAME"

# -----------------------------
# 4) Runtime: alpine (适合静态二进制) + 非 root 用户 + 统一入口 app
# -----------------------------
FROM alpine AS runtime
WORKDIR /app

RUN addgroup -S myuser && adduser -S myuser -G myuser \
    && apk add --no-cache ca-certificates

# 拷贝元信息
COPY --from=builder /app/bin_name.txt /app/bin_name.txt
COPY --from=builder /app/version.txt /app/version.txt

# 拷贝最终二进制到 /usr/local/bin，并建立 /usr/local/bin/app 的软链
RUN set -eux; \
    BIN_NAME="$(cat /app/bin_name.txt)"; \
    echo "复制二进制文件：$BIN_NAME"

COPY --from=builder /app/* /usr/local/bin/

RUN set -eux; \
    BIN_NAME="$(cat /app/bin_name.txt)"; \
    chmod +x "/usr/local/bin/$BIN_NAME"; \
    ln -sf "/usr/local/bin/$BIN_NAME" /usr/local/bin/app

# 镜像元数据（兼容你原来的用法：build 时传 --build-arg APP_VERSION=...）
ARG APP_VERSION
LABEL org.opencontainers.image.version=$APP_VERSION

USER myuser
ENTRYPOINT ["/usr/local/bin/app"]
