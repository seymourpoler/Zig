const std = @import("std");
const testing = std.testing;
const List = @import("./DoubleLinkedList.zig");

test "When List is created, it is empty and its length is zero" {
    var list = List.create(u32).init(testing.allocator);
    defer list.deinit();

    try testing.expectEqual(@as(usize, 0), list.size());
    try testing.expect(list.isEmpty());
}

test "When List add several elements at first" {
    var list = List.create(u32).init(testing.allocator);
    defer list.deinit();

    try list.add_first(1);
    try list.add_first(2);
    try list.add_first(3);

    try testing.expectEqual(@as(bool, false), list.isEmpty());
    try testing.expectEqual(@as(usize, 3), list.size());
}

test "When List add several elements at last" {
    var list = List.create(u32).init(testing.allocator);
    defer list.deinit();

    try list.add_last(1);
    try list.add_last(2);
    try list.add_last(3);

    try testing.expectEqual(@as(bool, false), list.isEmpty());
    try testing.expectEqual(@as(usize, 3), list.size());
}

test "When List remove an element at first and it is empty" {
    var list = List.create(u32).init(testing.allocator);
    defer list.deinit();

    try testing.expectError(error.isEmpty, list.remove_first());
}

test "When List removes several elements at first" {
    var list = List.create(u32).init(testing.allocator);
    defer list.deinit();

    try list.add_first(1);
    try list.add_first(2);
    try list.add_first(3);

    try testing.expectEqual(@as(usize, 3), list.size());
    try testing.expectEqual(@as(u32, 3), list.remove_first());
    try testing.expectEqual(@as(u32, 2), list.remove_first());
    try testing.expectEqual(@as(u32, 1), list.remove_first());
    try testing.expectEqual(@as(u32, 0), list.size());
}

test "When List remove an element at last and it is empty" {
    var list = List.create(u32).init(testing.allocator);
    defer list.deinit();

    try testing.expectError(error.isEmpty, list.remove_last());
}

test "When List removes several elements at last" {
    var list = List.create(u32).init(testing.allocator);
    defer list.deinit();

    try list.add_last(1);
    try list.add_last(2);
    try list.add_last(3);

    try testing.expectEqual(@as(usize, 3), list.size());
    try testing.expectEqual(@as(u32, 3), list.remove_last());
    try testing.expectEqual(@as(u32, 2), list.remove_last());
    try testing.expectEqual(@as(u32, 1), list.remove_last());
    try testing.expectEqual(@as(u32, 0), list.size());
}
