const testing = @import("std").testing;

fn copy_string(src: []const u8) []const u8 {
    const dst = src;
    return dst;
}

test "strings" {
    const src = "hello";

    const dst = copy_string(src);

    try testing.expectEqualStrings(src, dst);
}
