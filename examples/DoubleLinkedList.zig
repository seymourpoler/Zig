const std = @import("std");

pub fn create(comptime T: type) type {
    return struct {
        const Node = struct {
            value: T,
            next: ?*Node = null,
            prev: ?*Node = null,
        };

        const Self = @This();
        allocator: std.mem.Allocator,
        head: ?*Node,
        tail: ?*Node,
        numberOfElements: usize,

        pub fn init(allocator: std.mem.Allocator) Self {
            return Self{
                .allocator = allocator,
                .head = null,
                .tail = null,
                .numberOfElements = 0,
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
            self.tail = null;
            self.numberOfElements = 0;
        }

        pub fn add_first(self: *Self, value: T) !void {
            const newNode = try self.allocator.create(Node);
            newNode.value = value;
            newNode.next = self.head;
            if (self.head) |firstNode| {
                firstNode.prev = newNode;
            } else {
                self.tail = newNode;
            }

            self.head = newNode;
            self.numberOfElements += 1;
        }

        pub fn len(self: Self) usize {
            return self.numberOfElements;
        }

        pub fn isEmpty(self: Self) bool {
            return self.numberOfElements == 0;
        }
    };
}
