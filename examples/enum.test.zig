const testing = @import("std").testing;

const Suit = enum {
    Spades,
    Hearts,
    Diamonds,
    Clubs,
    pub fn isClubs(self: Suit) bool {
        return (self == Suit.Clubs);
    }
};

test "enums" {
    const spades = Suit.Spades;
    const hearts = Suit.Hearts;
    const diamonds = Suit.Diamonds;
    const clubs = Suit.Clubs;

    try testing.expect(Suit.isClubs(clubs));
    try testing.expect(!Suit.isClubs(spades));
    try testing.expect(!Suit.isClubs(hearts));
    try testing.expect(!Suit.isClubs(diamonds));
}

const Values = enum(u8) {
    A = 'A',
    B = 'B',
    C = 'C',
    D = 'D',

    pub fn isA(self: Values) bool {
        return (self == Values.A);
    }
};

test "enums values" {
    const a = Values.A;
    const b = Values.B;
    const c = Values.C;
    const d = Values.D;

    try testing.expect(Values.isA(a));
    try testing.expect(!Values.isA(b));
    try testing.expect(!Values.isA(c));
    try testing.expect(!Values.isA(d));
}
