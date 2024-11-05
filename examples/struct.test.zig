const testing = @import("std").testing;

const Stuff = struct {
    //const Self = @This();
    a: i32 = 1,
    b: i32 = 2,

    pub fn init(a: i32, b: i32) @This() {
        return @This(){
            .a = a,
            .b = b,
        };
    }

    pub fn get_a(self: *const Stuff) i32 {
        return self.a;
    }

    pub fn get_b(self: *const Stuff) i32 {
        return self.b;
    }

    pub fn swap(self: *const Stuff) @This() {
        return @This().init(self.b, self.a);
    }
};

test "struct" {
    const aStuff = Stuff.init(3, 2);
    try testing.expectEqual(3, aStuff.a);

    const otherStuff = aStuff.swap();
    try testing.expectEqual(3, otherStuff.get_b());
    try testing.expectEqual(2, otherStuff.get_a());
}
