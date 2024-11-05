const std = @import("std");

const Circle = struct {
    const Self = @This();
    radius: f64,

    pub fn getArea(self: Self) f64 {
        return std.math.pi * (self.radius * self.radius);
    }

    pub fn setRadius(self: *Self, new_radius: f64) void {
        self.radius = new_radius;
    }

    pub fn create(radius: f64) Circle {
        return @This(){
            .radius = radius,
        };
    }
};

test "Simple OOP-like behavior with Circle" {
    //var circle = Circle{ .radius = 5.0 };
    var circle = Circle.create(5.0);
    try std.testing.expectEqual(7.853981633974483e1, circle.getArea());

    circle.setRadius(10.0);

    try std.testing.expectEqual(3.141592653589793e2, circle.getArea());
}
