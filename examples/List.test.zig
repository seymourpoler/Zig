const List = @import("List.zig");
const testing = @import("std").testing;

test "List is empty" {
    var aList = List.create(i32).init(testing.allocator);
    defer aList.deinit();

    try testing.expect(aList.isEmpty());
    try testing.expectEqual(@as(usize, 0), aList.len());
}

test "List add several elements" {
    var aList = List.create(i32).init(testing.allocator);
    defer aList.deinit();

    try aList.add(1);
    try aList.add(2);
    try aList.add(3);

    try testing.expectEqual(@as(bool, false), aList.isEmpty());
    try testing.expectEqual(3, aList.len());
}

test "List add and array of elements" {
    var aList = List.create(i32).init(testing.allocator);
    defer aList.deinit();
    const elements = &[_]i32{ 1, 2, 3 };

    try aList.addRange(elements);

    try testing.expectEqual(@as(bool, false), aList.isEmpty());
    try testing.expectEqual(3, aList.len());
}

test "List remove several elements" {
    var aList = List.create(i32).init(testing.allocator);
    defer aList.deinit();

    try aList.add(1);
    try aList.add(2);
    try aList.add(3);

    try testing.expectEqual(3, aList.remove());
    try testing.expectEqual(2, aList.remove());
    try testing.expectEqual(1, aList.remove());
    try testing.expectError(error.isEmpty, aList.remove());
}

test "List remove several elements from an array" {
    var aList = List.create(i32).init(testing.allocator);
    defer aList.deinit();

    const elements = &[_]i32{ 1, 2, 3 };
    try aList.addRange(elements);

    try testing.expectEqual(3, aList.remove());
    try testing.expectEqual(2, aList.remove());
    try testing.expectEqual(1, aList.remove());
    try testing.expectError(error.isEmpty, aList.remove());
}

test "List access and element when there is no elements" {
    var list = List.create(i32).init(testing.allocator);
    defer list.deinit();

    try testing.expectError(error.isEmpty, list.get(5));
}
