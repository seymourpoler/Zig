const List = @import("List.zig");
const testing = @import("std").testing;

test "List is empty" {
    var list = List.create(i32).init(testing.allocator);
    defer list.deinit();

    try testing.expect(list.isEmpty());
    try testing.expectEqual(@as(usize, 0), list.size());
}

test "List add several elements" {
    var aList = List.create(i32).init(testing.allocator);
    defer aList.deinit();

    try aList.add(1);
    try aList.add(2);
    try aList.add(3);

    try testing.expectEqual(@as(bool, false), aList.isEmpty());
    try testing.expectEqual(3, aList.size());
}

test "List add and array of elements" {
    var aList = List.create(i32).init(testing.allocator);
    defer aList.deinit();
    const elements = &[_]i32{ 1, 2, 3 };

    try aList.addRange(elements);

    try testing.expectEqual(@as(bool, false), aList.isEmpty());
    try testing.expectEqual(3, aList.size());
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

test "List access an element when there is no elements" {
    var list = List.create(i32).init(testing.allocator);
    defer list.deinit();

    try testing.expectError(error.isEmpty, list.getAt(5));
}

test "List access an element when the index is bigger than the number of elements" {
    var list = List.create(i32).init(testing.allocator);
    defer list.deinit();

    try list.add(1);

    try testing.expectError(error.isOutOfBound, list.getAt(5));
}

test "List access with one element" {
    var list = List.create(i32).init(testing.allocator);
    defer list.deinit();

    try list.add(8);

    try testing.expectEqual(@as(i32, 8), list.getAt(0));
}

test "List access with several elements" {
    var list = List.create(i32).init(testing.allocator);
    defer list.deinit();

    try list.add(8);
    try list.add(9);
    try list.add(10);
    try list.add(11);

    try testing.expectEqual(@as(i32, 9), list.getAt(2));
}

test "List remove element at any position when is empty" {
    var list = List.create(i32).init(testing.allocator);
    defer list.deinit();

    try testing.expectError(error.isEmpty, list.removeAt(5));
}

test "List remove an element at position bigger than the number of elements" {
    var list = List.create(i32).init(testing.allocator);
    defer list.deinit();

    try list.add(1);

    try testing.expectError(error.isOutOfBound, list.removeAt(5));
}

test "List remove an element at some position" {
    var list = List.create(i32).init(testing.allocator);
    defer list.deinit();

    try list.add(1);
    try list.add(2);
    try list.add(3);
    try list.add(4);
    try list.add(5);

    try testing.expectEqual(@as(i32, 3), list.removeAt(2));
    try testing.expectEqual(@as(i32, 4), list.removeAt(1));
    try testing.expectEqual(@as(i32, 3), list.size());
}

test "List convert all values into an array" {
    var list = List.create(i32).init(testing.allocator);
    defer list.deinit();

    try list.add(1);
    try list.add(2);
    try list.add(3);
    try list.add(4);

    const array = try list.toArray();
    defer testing.allocator.free(array);

    try testing.expectEqual(4, array.len);
    try testing.expectEqual(@as(i32, 4), array[0]);
    try testing.expectEqual(@as(i32, 3), array[1]);
    try testing.expectEqual(@as(i32, 2), array[2]);
    try testing.expectEqual(@as(i32, 1), array[3]);
}
