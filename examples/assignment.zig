const expect = @import("std").testing.expect;

const constant: i32 = 42;

var variable: i32 = 42;

test "always succeeds" {
    try expect(constant == 42);
    try expect(variable == 42);
    variable = @as(i32, 53);
    try expect(variable == 53);
    variable = 48;
    try expect(variable == 48);
}
