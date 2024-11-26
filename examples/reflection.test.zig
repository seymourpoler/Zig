const std = @import("std");
const testing = std.testing;

const Person = struct {
    name: []const u8,
    age: u32,
};

test "simple reflection" {
    const person = Person{ .name = "Alice", .age = 30 };
    try testing.expectEqual(@TypeOf(person), Person);
}
