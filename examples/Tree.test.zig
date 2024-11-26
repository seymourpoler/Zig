const std = @import("std");
const testing = std.testing;
const Tree = @import("Tree.zig");

test "Tree contains" {
    var tree = Tree.create(u32).init(std.testing.allocator);
    defer tree.deinit();

    try testing.expect(!tree.contains(1));
}

//test "Tree insert" {
//    var tree = Tree.create(u32).init(std.testing.allocator);
//    defer tree.deinit();

//    try tree.add(1);

//    try testing.expect(tree.contains(1));
//}
