const User = @import("./User.zig");
const std = @import("std");

pub const UserRepository = struct {
    users: std.ArrayList(User.User),

    pub fn save(self: *UserRepository, user: User.User) !void {
        try self.users.append(user);
    }

    pub fn findBy(self: *UserRepository, id: u32) !User.User {
        for (self.users.items) |user| {
            if (user.id == id) {
                return user;
            }
        }
        return null;
    }

    pub fn deinit(self: *UserRepository) void {
        self.users.deinit();
    }
};

pub fn init(allocator: std.mem.Allocator) UserRepository {
    return UserRepository{
        .users = std.ArrayList(User).init(allocator),
    };
}
