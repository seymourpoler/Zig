const List = @import("List.zig");
const testing = @import("std").testing;

test "List is empty" {
    var aList = List.create(i32).init(testing.allocator);
    defer aList.deinit();

    try testing.expect(aList.isEmpty());
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
