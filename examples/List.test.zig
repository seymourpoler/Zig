const List = @import("./List.zig");
const testing = @import("std").testing;

test "List is empty" {
    var list = List.create(i32).init(testing.allocator);
    defer list.deinit();

    try testing.expect(list.isEmpty());
    try testing.expectEqual(@as(usize, 0), list.size());
}

test "List add several elements" {
    var list = List.create(i32).init(testing.allocator);
    defer list.deinit();

    try list.add(1);
    try list.add(2);
    try list.add(3);

    try testing.expectEqual(@as(bool, false), list.isEmpty());
    try testing.expectEqual(3, list.size());
}

test "List add and array of elements" {
    var list = List.create(i32).init(testing.allocator);
    defer list.deinit();
    const elements = &[_]i32{ 1, 2, 3 };

    try list.addRange(elements);

    try testing.expectEqual(@as(bool, false), list.isEmpty());
    try testing.expectEqual(3, list.size());
}

test "List remove several elements" {
    var list = List.create(i32).init(testing.allocator);
    defer list.deinit();

    try list.add(1);
    try list.add(2);
    try list.add(3);

    try testing.expectEqual(3, list.remove());
    try testing.expectEqual(2, list.remove());
    try testing.expectEqual(1, list.remove());
    try testing.expectError(error.isEmpty, list.remove());
}

test "List remove several elements from an array" {
    var list = List.create(i32).init(testing.allocator);
    defer list.deinit();

    const elements = &[_]i32{ 1, 2, 3 };
    try list.addRange(elements);

    try testing.expectEqual(3, list.remove());
    try testing.expectEqual(2, list.remove());
    try testing.expectEqual(1, list.remove());
    try testing.expectError(error.isEmpty, list.remove());
}

test "List access and element when there is no elements" {
    var list = List.create(i32).init(testing.allocator);
    defer list.deinit();

    try testing.expectError(error.isEmpty, list.get(5));
}

test "List access and element when the index is bigger to number of elements" {
    var list = List.create(i32).init(testing.allocator);
    defer list.deinit();

    try list.add(1);

    try testing.expectError(error.isOutOfBound, list.get(5));
}
