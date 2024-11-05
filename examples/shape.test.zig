const std = @import("std");
const Shape = @import("shape.zig");

test "Circle calculates correct area" {
    var circle = Shape.Circle.create(5.0);

    const expected_area = std.math.pi * 25.0;
    try std.testing.expectEqual(expected_area, circle.calculateArea());
}

test "Rectangle calculates correct area" {
    var rectangle = Shape.Rectangle.create(5.0, 10.0);

    const expected_area = 50.0;
    try std.testing.expectEqual(expected_area, rectangle.calculateArea());
}
