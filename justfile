AICMD := "codex e"

fix-warnings:
    cargo clippy --fix --all --allow-dirty --allow-staged
    {{AICMD}} '你是一名资深 Rust 工程师。请在当前仓库中：
    - 修复所有编译器与 clippy 的 warning，不改变对外行为或 API
    - 通过合理重构（拆函数、调整逻辑、加必要属性）来解决警告
    - 不使用 allow(dead_code) 等方式掩盖问题
    - 最终应显著减少 warning，使 cargo clippy 基本干净'
    cargo fmt --all

fix-errors:
    {{AICMD}} '你是一名资深 Rust 工程师。请在当前仓库中：
    - 修复所有编译错误，使项目能通过 cargo build
    - 尽量保持现有 API 与语义稳定，必要更改需向后兼容
    - 无法立即实现的模块可暂用 todo!() 并在注释中标明理由'

update-tests:
    {{AICMD}} '你是一名 Rust 测试工程师。请在当前仓库中：
    - 为核心功能补充或优化单元测试 / 集成测试
    - 覆盖核心逻辑及边界情况，避免无意义或重复测试
    - 删除失效测试，更新因函数签名变化而报错的测试
    - 确保 cargo test 全部通过'

update-docs:
    {{AICMD}} '你是一名熟悉 Rust 文档规范的工程师。请：
    - 为所有 pub mod/struct/enum/trait/fn 添加或修复中文文档注释
    - 注释重点说明用途、参数、返回值、典型场景，不写废话
    - 保证 doc test 和示例代码可编译'

update-readme:
    {{AICMD}} '你是一名技术写作者兼 Rust 工程师。请生成或优化 README.md：
    - 使用中文，内容包含：项目简介、特性、安装/构建步骤、使用示例、注意事项
    - 示例命令必须基于当前项目真实信息，不可编造不存在的功能
    - 结构应清晰，信息最新、准确'
