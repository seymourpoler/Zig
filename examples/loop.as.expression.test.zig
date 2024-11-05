const testing = @import("std").testing;

fn loop_as_expression(begin: usize, end: usize, number: usize) bool {
    var position = begin;

    return while (position < end) : (position += 1) {
        if (number == position) {
            return true;
        }
    } else {
        return false;
    };
}

test "loop as expression" {
    const result = loop_as_expression(0, 10, 5);

    try testing.expectEqual(true, result);
}
