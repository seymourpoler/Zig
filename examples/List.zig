const std = @import("std");

pub const List = struct {};

pub fn create(comptime T: type) type {
    return struct {
        const Node = struct {
            value: T,
            next: ?*Node = null,
        };

        allocator: std.mem.Allocator,
        head: ?*Node,
        numberOfElements: usize,

        pub fn init(allocator: std.mem.Allocator) @This() {
            return @This(){
                .allocator = allocator,
                .head = null,
                .numberOfElements = 0,
            };
        }

        pub fn deinit(self: *@This()) void {
            var current = self.head;
            while (current) |node| {
                const nextNode = node.next;
                self.allocator.destroy(node);
                current = nextNode;
            }
            self.head = null;
            self.numberOfElements = 0;
        }

        pub fn add(self: *@This(), value: T) !void {
            const node = try self.allocator.create(Node);
            node.value = value;
            node.next = self.head;
            self.head = node;
            self.numberOfElements += 1;
        }

        pub fn addRange(self: *@This(), elements: []const T) !void {
            for (elements) |element| {
                try self.add(element);
            }
        }

        pub fn remove(self: *@This()) !T {
            if (self.head == null) {
                return error.isEmpty;
            }
            const node = self.head.?;
            self.head = node.next;
            const value = node.value;
            self.allocator.destroy(node);
            self.numberOfElements -= 1;
            return value;
        }

        pub fn get(self: @This(), position: usize) !T {
            if (self.head == null) {
                return error.isEmpty;
            }

            if ((position > self.numberOfElements)) {
                return error.isOutOfBound;
            }

            return error.notImplemented;
        }

        pub fn size(self: @This()) usize {
            return self.numberOfElements;
        }

        pub fn isEmpty(self: @This()) bool {
            return self.numberOfElements == 0;
        }
    };
}
