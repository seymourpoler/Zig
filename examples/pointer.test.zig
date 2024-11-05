const testing = @import("std").testing;

fn increase(a: *u8) void {
    a.* += 1;
}

test "pointer" {
    var number: u8 = 9;

    increase(&number);

    const expected: u8 = 10;
    try testing.expectEqual(expected, number);
}
