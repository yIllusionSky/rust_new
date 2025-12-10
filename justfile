AICMD := "codex e"

fix-warnings:
    cargo clippy --all
    {{AICMD}} '你是一名资深 Rust 工程师。请在当前仓库中： \
    - 仅修复编译器与 clippy 的 warning，不做与消除 warning 无关的修改； \
    - 可以做少量必要的重构，但不得改变外部行为或 API； \
    - 禁止使用 allow 系列属性掩盖 warning； \
    - 禁止执行任何额外命令，仅依赖 cargo clippy； \
    - 目标是尽量减少 warning，使 clippy 基本干净。'
    cargo fmt --all

fix-errors:
    {{AICMD}} '你是一名资深 Rust 工程师。请在当前仓库中： \
    - 仅修复编译错误，使项目能通过 cargo build； \
    - 尽量保持 API 与行为稳定，必要变更需向后兼容； \
    - 无法立即实现的模块可用 todo!() 并注明原因； \
    - 禁止执行任何与修复错误无关的修改或命令。'

update-tests:
    {{AICMD}} '你是一名 Rust 测试工程师。请在当前仓库中： \
    - 为核心逻辑补充或优化单元测试/集成测试； \
    - 仅覆盖核心路径与边界情况，避免无意义或重复； \
    - 删除失效测试，更新因函数签名变化导致报错的测试； \
    - 确保 cargo test 全部通过； \
    - 禁止执行与测试无关的修改或额外命令。'

update-docs:
    {{AICMD}} '你是一名熟悉 Rust 文档规范的工程师。请在当前仓库中： \
    - 为所有 pub 的 mod/struct/enum/trait/fn 添加简洁中文文档； \
    - 注释重点说明用途、参数、返回值，不写废话； \
    - 示例代码必须可编译； \
    - 禁止执行与文档无关的修改或命令。'

update-readme:
    {{AICMD}} '你是一名专业的技术写作者。请在当前仓库中： \
    - 创建或更新 README.md（中文）； \
    - 内容包括：项目简介、特性、安装/构建步骤、示例、注意事项； \
    - 所有示例基于项目真实能力，不得虚构； \
    - 结构清晰、简洁； \
    - 禁止执行与 README 无关的修改或命令。'

commit:
    {{AICMD}} '你是一名专业的 Git 提交信息撰写者。请在当前仓库中： \
    - 根据当前 diff 生成精确、简洁、符合规范的 commit message； \
    - 包含变更类别（如 fix / feat / refactor / test / docs 等）与简要描述； \
    - 不生成与实际变更无关的内容； \
    - 不修改文件，仅输出提交信息文本； \
    - 确保提交信息可直接用于 git commit -m。'
