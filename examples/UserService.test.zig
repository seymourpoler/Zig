const std = @import("std");
const User = @import("./User.zig");
const UserService = @import("./UserService.zig");
const UserRepository = @import("./UserRepository.zig");

test "User Service creates a user" {
    //var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    //defer _ = gpa.deinit();

    //const allocator = gpa.allocator();
    const allocator = std.testing.allocator;
    //const allocator = std.mem.Allocator;
    var userRepository = UserRepository.init(allocator);
    defer userRepository.deinit();

    var userService = UserService.init(&userRepository);
    defer userService.deinit();

    const name: []const u8 = "Alice";
    const id: u32 = 1;
    const user = User.User{ .id = id, .name = name };

    try userService.create(user);

    const expectedUser = userService.findBy(1);
    try std.testing.expectEqual(1, expectedUser.id);
    try std.testing.expectEqualStrings(name, expectedUser.name);
}
