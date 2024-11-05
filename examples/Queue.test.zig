const std = @import("std");
const Queue = @import("./Queue.zig");

test "A queue" {
    var aQueue = Queue.Queue(i32).init(std.testing.allocator);

    try aQueue.enqueue(1);
    try aQueue.enqueue(2);
    try aQueue.enqueue(3);

    try std.testing.expectEqual(1, aQueue.dequeue());
    try std.testing.expectEqual(2, aQueue.dequeue());
    try std.testing.expectEqual(3, aQueue.dequeue());
}
