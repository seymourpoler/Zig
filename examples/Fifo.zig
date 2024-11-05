const std = @import("std");

pub fn createFifo(comptime T: type) type {
    return struct {
        const Self = @This();
        items: std.ArrayList(T),

        pub fn init(allocator: std.mem.Allocator) Self {
            return Self{
                .items = std.ArrayList(T).init(allocator),
            };
        }

        pub fn deinit(self: *Self) void {
            self.items.deinit();
        }

        pub fn len(self: Self) usize {
            return self.items.items.len;
        }

        pub fn isEmpty(self: Self) bool {
            return self.items.items.len == 0;
        }

        pub fn enqueue(self: *Self, item: T) !void {
            try self.items.append(item);
        }

        pub fn dequeue(self: *Self) !T {
            if (self.isEmpty()) {
                return error.isEmpty;
            }
            const item = self.items.orderedRemove(0);
            return item;
        }

        pub fn clear(self: *Self) void {
            self.items.clearAndFree();
        }
    };
}
