/// 生成指定长度的斐波那契数列，长度为 0 返回空向量。
///
/// # 参数
/// - `length`: 期望的项数。
///
/// # 返回
/// 按顺序排列的斐波那契数列，元素类型为 `u64`。
///
/// # 示例
/// ```
/// use rust_new::fibonacci_sequence;
///
/// assert_eq!(fibonacci_sequence(5), vec![0, 1, 1, 2, 3]);
/// assert!(fibonacci_sequence(0).is_empty());
/// ```
pub fn fibonacci_sequence(length: usize) -> Vec<u64> {
    if length == 0 {
        return Vec::new();
    }

    let mut sequence = Vec::with_capacity(length);
    sequence.push(0);

    if length == 1 {
        return sequence;
    }

    sequence.push(1);

    for i in 2..length {
        let next = sequence[i - 1] + sequence[i - 2];
        sequence.push(next);
    }

    sequence
}

#[cfg(test)]
mod tests {
    use super::fibonacci_sequence;

    #[test]
    fn returns_empty_for_zero_length() {
        let result = fibonacci_sequence(0);
        assert!(result.is_empty());
    }

    #[test]
    fn returns_single_zero_for_length_one() {
        let result = fibonacci_sequence(1);
        assert_eq!(result, vec![0]);
    }

    #[test]
    fn builds_sequence_for_small_length() {
        let result = fibonacci_sequence(10);
        assert_eq!(result, vec![0, 1, 1, 2, 3, 5, 8, 13, 21, 34]);
    }

    #[test]
    fn maintains_fibonacci_property_for_longer_sequence() {
        let length = 25;
        let result = fibonacci_sequence(length);

        assert_eq!(result.len(), length);
        for i in 2..length {
            assert_eq!(result[i], result[i - 1] + result[i - 2]);
        }
        assert_eq!(result[length - 1], 46_368);
    }
}
