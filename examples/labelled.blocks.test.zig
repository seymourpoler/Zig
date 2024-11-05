const testing = @import("std").testing;

const count = blk: {
    var i: i32 = 0;
    var result: i32 = 0;
    while (i < 10) {
        result += 1;
        i += 1;
    }
    //while (i < 10) : (i = i + 1) result += i;
    break :blk result;
};

test "labelled blocs" {
    try testing.expectEqual(10, count);
}
