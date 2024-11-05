const std = @import("std");
const testing = std.testing;

fn fizzBuzz(number: u32) []const u8 {
    if (number % 3 == 0) {
        return "Fizz";
    }
    if (number % 5 == 0) {
        return "Buzz";
    }

    return convert_to_string(number);
}

fn convert_to_string(value: u32) []const u8 {
    var buffer: [4096]u8 = undefined;
    const result = std.fmt.bufPrintZ(buffer[0..], "{d}", .{value}) catch unreachable;
    return @as([]const u8, result);
}

test "simple number" {
    const expected: []const u8 = "1";
    try testing.expectEqualStrings(expected, fizzBuzz(1));
}

test "dividible by 3" {
    const expected: []const u8 = "Fizz";
    try testing.expectEqualStrings(expected, fizzBuzz(6));
}

test "dividible by 5" {
    const expected: []const u8 = "Buzz";
    try testing.expectEqualStrings(expected, fizzBuzz(125));
}
