const std = @import("std");

pub const Circle = struct {
    radius: f64,

    pub fn calculateArea(self: *const Circle) f64 {
        return std.math.pi * (self.radius * self.radius);
    }

    pub fn create(radius: f64) Circle {
        return Circle{ .radius = radius };
    }
};

pub const Rectangle = struct {
    width: f64,
    height: f64,

    pub fn calculateArea(self: *const Rectangle) f64 {
        return self.height * self.width;
    }

    pub fn create(width: f64, height: f64) Rectangle {
        return Rectangle{ .width = width, .height = height };
    }
};
