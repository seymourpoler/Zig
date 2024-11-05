const testing = @import("std").testing;

fn swtich(value: i32) i32 {
    switch (value) {
        0 => {
            return 1;
        },
        1 => {
            return 2;
        },
        10, 100 => {
            return @divExact(value, 2);
        },
        else => {
            return 0;
        },
    }
    return 0;
}

fn otherSwith(value: i32) i32 {
    const result = switch (value) {
        0 => 1,
        1 => 2,
        10, 100 => @divExact(value, 2),
        else => 0,
    };
    return result;
}

test "switch statement" {
    const x = swtich(0);

    const expected: i32 = 1;
    try testing.expectEqual(expected, x);
}

test "another swith" {
    const y = otherSwith(100);

    const expected: i32 = 50;
    try testing.expectEqual(expected, y);
}
