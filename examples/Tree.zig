const std = @import("std");

pub fn create(comptime T: type) type {
    return struct {
        const Self = @This();

        const Node = struct {
            value: T,
            left: ?*Node = null,
            right: ?*Node = null,
        };

        allocator: std.mem.Allocator,
        head: ?*Node,
        numberOfElements: usize,

        pub fn init(allocator: std.mem.Allocator) Self {
            return Self{
                .allocator = allocator,
                .head = null,
                .numberOfElements = 0,
            };
        }

        pub fn deinit(self: *@This()) void {
            if (self.head == null) {
                return;
            }

            const currentHead = self.head;
            if (currentHead.left != null) |left| {
                self.deinit(left);
                self.allocator.destroy(left);
            }
            if (self.head.right) |right| {
                self.deinit(right);
                self.allocator.destroy(right);
            }
            self.allocator.destroy(self.head);
            self.head = null;
            self.numberOfElements = 0;
        }

        //pub fn add(self: *@This(), value: T) !void {
        //    return error.Unimplemented;
        //const node = try self.allocator.create(Node);
        //node.value = value;
        //self.head = node;
        //self.numberOfElements += 1;
        //}

        pub fn contains(self: *@This(), value: T) bool {
            var current = self.head;
            while (current) |node| {
                if (node.value == value) {
                    return true;
                }
                if (value < node.value) {
                    current = node.left;
                } else {
                    current = node.right;
                }
            }
            return false;
        }
    };
}
