const std = @import("std");
const testing = @import("std").testing;
const DoubleLinkedList = @import("./DoubleLinkedList.zig");

test "When Double Linked List is created, it is empty and its length is zero" {
    var list = DoubleLinkedList.create(u32).init(testing.allocator);
    defer list.deinit();

    try testing.expectEqual(@as(usize, 0), list.len());
    try testing.expect(list.isEmpty());
}

test "When Double Linked List add several elements at first" {
    var list = DoubleLinkedList.create(u32).init(testing.allocator);
    defer list.deinit();

    try list.add_first(1);
    try list.add_first(2);
    try list.add_first(3);

    try testing.expectEqual(@as(bool, false), list.isEmpty());
    try testing.expectEqual(3, list.len());
}

test "When Double Linked List add several elements at last" {
    var list = DoubleLinkedList.create(u32).init(testing.allocator);
    defer list.deinit();

    try list.add_last(1);
    try list.add_last(2);
    try list.add_last(3);

    try testing.expectEqual(@as(bool, false), list.isEmpty());
    try testing.expectEqual(3, list.len());
}

test "When Double Linked List remove an element at first and it is empty" {
    var list = DoubleLinkedList.create(u32).init(testing.allocator);
    defer list.deinit();

    try testing.expectError(error.isEmpty, list.remove_first());
}
