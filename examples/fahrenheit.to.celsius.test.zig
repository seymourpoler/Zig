const testing = @import("std").testing;

fn to_celsius(value: f64) f64 {
    return (value - 32.0) * 5.0 / 9.0;
}

test "fahrenheit to celsius" {
    const fahrenheit: f64 = 212.0;

    const expected: f64 = 100.0;
    try testing.expectEqual(expected, to_celsius(fahrenheit));
}
