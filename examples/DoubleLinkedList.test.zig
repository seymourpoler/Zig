const std = @import("std");
const testing = @import("std").testing;
const DoubleLinkedList = @import("DoubleLinkedList.zig");

test "when Double linked list is created, it is empty and its length is zero" {
    var list = DoubleLinkedList.create(u32).init(testing.allocator);
    defer list.deinit();

    try testing.expectEqual(0, list.len());
    try testing.expect(list.isEmpty());
}
