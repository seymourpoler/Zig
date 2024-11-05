const std = @import("std");

pub fn create(comptime T: type) type {
    return struct {
        const Node = struct {
            value: T,
            next: ?*Node = null,
        };
        const Self = @This();

        allocator: std.mem.Allocator,
        head: ?*Node,

        pub fn init(allocator: std.mem.Allocator) Self {
            return Self{
                .allocator = allocator,
                .head = null,
            };
        }

        pub fn deinit(self: *Self) void {
            var current = self.head;
            while (current) |node| {
                const nextNode = node.next;
                self.allocator.destroy(node);
                current = nextNode;
            }
            self.head = null;
        }

        pub fn add(self: *Self, value: T) !void {
            const node = try self.allocator.create(Node);
            node.value = value;
            node.next = self.head;
            self.head = node;
        }

        pub fn remove(self: *Self) !T {
            if (self.head == null) {
                return error.isEmpty;
            }
            const node = self.head.?;
            self.head = node.next;
            const value = node.value;
            self.allocator.destroy(node);
            return value;
        }

        pub fn len(self: Self) usize {
            var count: usize = 0;
            var current = self.head;
            while (current) |node| {
                count += 1;
                current = node.next;
            }
            return count;
        }

        pub fn isEmpty(self: Self) bool {
            return self.head == null;
        }
    };
}
