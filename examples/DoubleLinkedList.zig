const std = @import("std");

pub fn create(comptime T: type) type {
    return struct {
        const Self = @This();

        const Node = struct {
            value: T,
            next: ?*Node = null,
            prev: ?*Node = null,
        };

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
            newNode.prev = null;
            if (self.head) |newHead| {
                newHead.prev = newNode;
            } else {
                self.tail = newNode;
            }

            self.head = newNode;
            self.numberOfElements += 1;
        }

        pub fn add_range_first(self: *Self, values: []const T) !void {
            for (values) |value| {
                try self.add_first(value);
            }
        }

        pub fn remove_first(self: *Self) !T {
            if (self.head == null) {
                return error.isEmpty;
            }

            const firstNode = self.head.?;
            const value = firstNode.value;

            if (firstNode.next) |newHead| {
                newHead.prev = null;
            } else {
                self.tail = null;
            }

            self.head = firstNode.next;
            self.allocator.destroy(firstNode);
            self.numberOfElements -= 1;
            return value;
        }

        pub fn add_last(self: *Self, value: T) !void {
            const newNode = try self.allocator.create(Node);
            newNode.value = value;
            newNode.prev = self.tail;
            newNode.next = null;
            if (self.tail) |newTail| {
                newTail.next = newNode;
            } else {
                self.head = newNode;
            }

            self.tail = newNode;
            self.numberOfElements += 1;
        }

        pub fn remove_last(self: *Self) !T {
            if (self.tail == null) {
                return error.isEmpty;
            }

            const lastNode = self.tail.?;
            const value = lastNode.value;

            if (lastNode.prev) |newTail| {
                newTail.next = null;
            } else {
                self.head = null;
            }

            self.tail = lastNode.prev;
            self.allocator.destroy(lastNode);
            self.numberOfElements -= 1;
            return value;
        }

        pub fn size(self: Self) usize {
            return self.numberOfElements;
        }

        pub fn isEmpty(self: Self) bool {
            return self.numberOfElements == 0;
        }
    };
}
