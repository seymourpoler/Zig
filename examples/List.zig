const std = @import("std");

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
            if (self.isEmpty()) {
                return error.isEmpty;
            }
            const node = self.head.?;
            self.head = node.next;
            const value = node.value;
            self.allocator.destroy(node);
            self.numberOfElements -= 1;
            return value;
        }

        pub fn removeAt(self: *@This(), position: usize) !T {
            if (self.isEmpty()) {
                return error.isEmpty;
            }
            if (position >= self.numberOfElements) {
                return error.isOutOfBound;
            }

            var current = self.head.?;
            var previous: ?*Node = null;
            for (0..position) |_| {
                previous = current;
                current = current.next.?;
            }
            if (previous == null) {
                self.head = current.next;
            } else {
                previous.?.next = current.next;
            }
            const value = current.value;
            self.allocator.destroy(current);
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

            var current = self.head.?;
            for (0..position) |_| {
                current = current.next.?;
            }
            return current.value;
        }

        pub fn getAt(self: @This(), position: usize) !T {
            if (self.isEmpty()) {
                return error.isEmpty;
            }

            if ((position > self.numberOfElements)) {
                return error.isOutOfBound;
            }

            var current = self.head.?;
            for (0..position) |_| {
                current = current.next.?;
            }
            return current.value;
        }

        pub fn toArray(self: @This()) ![]T {
            const result = try self.allocator.alloc(T, self.numberOfElements);
            var current = self.head;
            for (0..self.numberOfElements) |currentPosition| {
                result[currentPosition] = current.?.value;
                current = current.?.next;
            }

            return result;
        }

        pub fn size(self: @This()) usize {
            return self.numberOfElements;
        }

        pub fn isEmpty(self: @This()) bool {
            return self.numberOfElements == 0;
        }
    };
}
