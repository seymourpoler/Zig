const std = @import("std");

pub fn create(comptime T: type) type {
    return struct {
        const Node = struct {
            value: T,
            next: ?*Node = null,
            prev: ?*Node = null,
        };

        allocator: std.mem.Allocator,
        head: ?*Node,
        tail: ?*Node,
        numberOfElements: usize,

        pub fn init(allocator: std.mem.Allocator) @This() {
            return @This(){
                .allocator = allocator,
                .head = null,
                .tail = null,
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
            self.tail = null;
            self.numberOfElements = 0;
        }

        pub fn getAt(self: @This(), position: usize) !T {
            if (self.isEmpty()) {
                return error.isEmpty;
            }

            if (position >= self.numberOfElements) {
                return error.isOutOfBound;
            }

            var currentElement = self.head.?;
            for (0..position) |_| {
                currentElement = currentElement.next.?;
            }
            return currentElement.value;
        }

        pub fn add_first(self: *@This(), value: T) !void {
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

        pub fn add_range_first(self: *@This(), values: []const T) !void {
            for (values) |value| {
                try self.add_first(value);
            }
        }

        pub fn add_range_last(self: *@This(), values: []const T) !void {
            for (values) |value| {
                try self.add_last(value);
            }
        }

        pub fn remove_first(self: *@This()) !T {
            if (self.isEmpty()) {
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

        pub fn add_last(self: *@This(), value: T) !void {
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

        pub fn remove_last(self: *@This()) !T {
            if (self.isEmpty()) {
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

        pub fn remove_at(self: *@This(), position: usize) !T {
            if (self.isEmpty()) {
                return error.isEmpty;
            }

            if (position >= self.numberOfElements) {
                return error.isOutOfBound;
            }

            const currentElement = self.findElementAt(position);
            self.updateElementBefore(currentElement);
            self.updateElementNext(currentElement);

            const value = currentElement.value;
            self.allocator.destroy(currentElement);
            self.numberOfElements -= 1;
            return value;
        }

        fn findElementAt(self: *@This(), position: usize) *Node {
            var currentElement = self.head.?;
            for (0..position) |_| {
                currentElement = currentElement.next.?;
            }
            return currentElement;
        }

        fn updateElementNext(self: *@This(), currentElement: *Node) void {
            if (currentElement.next) |next| {
                next.prev = currentElement.prev;
            } else {
                self.tail = currentElement.prev;
            }
        }

        fn updateElementBefore(self: *@This(), currentElement: *Node) void {
            if (currentElement.prev) |previous| {
                previous.next = currentElement.next;
            } else {
                self.head = currentElement.next;
            }
        }

        pub fn to_array(self: *@This()) ![]T {
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
