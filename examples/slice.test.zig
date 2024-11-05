const testing = @import("std").testing;

fn sum(slice: []const u8) usize {
    var result: usize = 0;
    for (slice) |value| {
        result += value;
    }
    return result;
}

test "slice" {
    const values = [_]u8{ 1, 2, 3, 4, 5 };

    const slice = values[1..4];
    try testing.expectEqual(3, slice.len);
    const result = sum(slice);
    try testing.expect(9 == result);
    try testing.expectEqual(9, result);
}
