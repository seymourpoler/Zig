const lifo = @import("Lifo.zig");
const std = @import("std");
const testing = @import("std").testing;

test "LIFO is empty" {
    var aLifo = lifo.createLifo(u8).init(testing.allocator);
    defer aLifo.deinit();

    try testing.expectEqual(@as(usize, 0), aLifo.len());
    try testing.expectEqual(true, aLifo.isEmpty());
}

test "LIFO push" {
    var aLifo = lifo.createLifo(u8).init(testing.allocator);
    defer aLifo.deinit();

    try aLifo.push(1);
    try aLifo.push(2);
    try aLifo.push(3);

    try testing.expectEqual(@as(usize, 3), aLifo.len());
    try testing.expectEqual(false, aLifo.isEmpty());
}

test "LIFO pop" {
    var aLifo = lifo.createLifo(u8).init(testing.allocator);
    defer aLifo.deinit();

    try aLifo.push(1);
    try aLifo.push(2);
    try aLifo.push(3);

    try testing.expectEqual(@as(usize, 3), aLifo.len());
    try testing.expectEqual(false, aLifo.isEmpty());

    try testing.expectEqual(3, aLifo.pop());
    try testing.expectEqual(2, aLifo.pop());
    try testing.expectEqual(1, aLifo.pop());
    try testing.expectEqual(@as(usize, 0), aLifo.len());
    try testing.expectEqual(true, aLifo.isEmpty());
}

test "LIFO pop empty" {
    var aLifo = lifo.createLifo(u8).init(testing.allocator);
    defer aLifo.deinit();

    try testing.expectEqual(@as(usize, 0), aLifo.len());
    try testing.expectEqual(true, aLifo.isEmpty());

    try testing.expectError(error.isEmpty, aLifo.pop());
}
