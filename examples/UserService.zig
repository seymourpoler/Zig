const User = @import("./User.zig");
const UserRepository = @import("./UserRepository.zig");

pub const UserService = struct {
    userRepository: *UserRepository.UserRepository,

    pub fn create(self: *UserService, user: User.User) void {
        self.userRepository.save(user);
    }

    pub fn findBy(self: *UserService, id: u32) User.User {
        return self.userRepository.findBy(id);
    }

    pub fn deinit(self: *UserService) void {
        self.userRepository.deinit();
    }
};

pub fn init(userRepository: *UserRepository.UserRepository) UserService {
    return UserService{
        .userRepository = userRepository,
    };
}
