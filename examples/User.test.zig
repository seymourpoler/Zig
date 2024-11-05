const User = @import("./User.zig");
const testing = @import("std").testing;

test "User" {
    const aUser = User.User{ .name = "John", .id = 42 };

    try testing.expectEqualStrings("John", aUser.name);
    try testing.expectEqual(42, aUser.id);
}
