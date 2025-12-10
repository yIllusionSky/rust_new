use rust_new::fibonacci_sequence;

fn main() {
    let count = 10;
    let fibs = fibonacci_sequence(count);

    println!("Fibonacci sequence ({} terms): {:?}", count, fibs);
}
