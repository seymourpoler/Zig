const std = @import("std");

const Worker = struct {
    doWork: fn () usize,
};

const Collaborator = struct {
    fn doWork() usize {
        std.debug.print("Real collaborator doing work\n", .{});
        return 42;
    }
};

const MainStruct = struct {
    worker: Worker,

    fn init(worker: Worker) MainStruct {
        return MainStruct{ .worker = worker };
    }

    fn doWork(self: MainStruct) usize {
        return self.worker.doWork();
    }
};

const MockCollaborator = struct {
    fn doWork() usize {
        std.debug.print("Mock collaborator doing mock work\n", .{});
        return 0;
    }
};

fn doWork() usize {
    std.debug.print("Alternative collaborator doing work\n", .{});
    return 1;
}

test "MainStruct uses MockCollaborator in unit test" {
    //const dependent = MainStruct.init(Worker{ .doWork = MockCollaborator.doWork });
    const dependent = MainStruct.init(Worker{ .doWork = Collaborator.doWork });
    //const dependent = MainStruct.init(Worker{ .doWork = doWork });

    //const result = dependent.worker.doWork();
    const result = dependent.doWork();
    //try std.testing.expectEqual(result, 0);
    try std.testing.expectEqual(42, result);
    //try std.testing.expectEqual(1, result);
}
