# syntax=docker/dockerfile:1

########################################
# 1. 构建阶段：编译 + 检查
########################################
FROM rust:slim-bookworm AS builder

# 让 cargo 输出彩色日志（和你的 workflow 一致）
ENV CARGO_TERM_COLOR=always

WORKDIR /app

# 先拷贝项目文件（简单粗暴版，如果你想利用缓存可以拆成 Cargo.toml / src 分开 COPY）
COPY . .

# 自动从 Cargo.toml 读取二进制名字（和 GitHub Actions 里的 sed 一样）
# 然后依次执行：cargo fmt --check -> cargo clippy -> cargo build --release
RUN set -eux; \
    BIN_NAME=$(sed -n 's/^name *= *"\(.*\)"/\1/p' Cargo.toml | head -n 1); \
    echo "Detected binary name: $BIN_NAME"; \
    cargo fmt --all -- --check; \
    cargo clippy --all -- -D warnings; \
    cargo build --release --bin "$BIN_NAME"; \
    # 统一拷贝成固定名字 app，方便后面运行时镜像 COPY
    cp "target/release/$BIN_NAME" /app/app

########################################
# 2. 运行阶段：仅包含编译好的二进制
########################################
FROM debian:bookworm-slim AS runtime

# 可选：装一下 ca-certificates（如果你的程序要发 HTTPS 请求）
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# 只把编译好的单个二进制复制进来
COPY --from=builder /app/app /usr/local/bin/app
RUN chmod +x /usr/local/bin/app

# 默认启动命令
CMD ["app"]
