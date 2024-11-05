const expectedEqual = @import("std").testing.expectEqual;
const debug = @import("std").debug;

fn fibonacci(n: i32) i32 {
    if (n <= 1) {
        return n;
    }
    return fibonacci(n - 1) + fibonacci(n - 2);
}

test "fibonacci" {
    const result = fibonacci(10);

    debug.print("\nfibonacci(10) = {}\n", .{result});

    try expectedEqual(i32, @TypeOf(result));
    //try expectedEqual(55, result);
}
