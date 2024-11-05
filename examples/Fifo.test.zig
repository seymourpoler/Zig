const fifo = @import("Fifo.zig");
const testing = @import("std").testing;

test "FIFO is empty" {
    var aFifo = fifo.createFifo(u8).init(testing.allocator);
    defer aFifo.deinit();

    try testing.expectEqual(@as(usize, 0), aFifo.len());
    try testing.expectEqual(true, aFifo.isEmpty());
}

test "FIFO enqueue" {
    var aFifo = fifo.createFifo(u8).init(testing.allocator);
    defer aFifo.deinit();

    try aFifo.enqueue(1);
    try aFifo.enqueue(2);
    try aFifo.enqueue(3);

    try testing.expectEqual(@as(usize, 3), aFifo.len());
    try testing.expectEqual(false, aFifo.isEmpty());
}

test "FIFO dequeue" {
    var aFifo = fifo.createFifo(u8).init(testing.allocator);
    defer aFifo.deinit();

    try aFifo.enqueue(1);
    try aFifo.enqueue(2);
    try aFifo.enqueue(3);

    try testing.expectEqual(@as(i32, 1), try aFifo.dequeue());
    try testing.expectEqual(@as(i32, 2), try aFifo.dequeue());
    try testing.expectEqual(@as(i32, 3), try aFifo.dequeue());

    try testing.expect(aFifo.isEmpty());
}

test "FIFO dequeue empty" {
    var aFifo = fifo.createFifo(i32).init(testing.allocator);
    defer aFifo.deinit();

    try testing.expectError(error.isEmpty, aFifo.dequeue());
}

test "FIFO clear" {
    var aFifo = fifo.createFifo(i32).init(testing.allocator);
    defer aFifo.deinit();

    try aFifo.enqueue(1);
    try aFifo.enqueue(2);
    try aFifo.enqueue(3);

    aFifo.clear();

    try testing.expect(aFifo.isEmpty());
    try testing.expectEqual(@as(usize, 0), aFifo.len());
}
