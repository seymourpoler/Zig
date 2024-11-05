const testing = @import("std").testing;

fn failMethod() error{Oops}!void {
    return error.Oops;
}

fn anotherFailMethod() error{Oops}!u32 {
    try failMethod();
    return 23;
}

test "error" {
    failMethod() catch |anError| {
        try testing.expectEqual(error.Oops, anError);
    };

    const result = anotherFailMethod() catch |anError| {
        try testing.expectEqual(error.Oops, anError);
    };
    try testing.expectEqual(23, result);
}
