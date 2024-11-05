const testing = @import("std").testing;

test "run time safety" {
    @setRuntimeSafety(true);
    const elements = [_]u8{ 1, 2, 3, 4, 5 };
    const index: u8 = 5;
    const result = elements[index];

    try testing.expectEqual(u8, 0, result);
}
