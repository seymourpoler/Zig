//Source: https://www.xeg.io/shared-searches/creating-a-simple-http-server-with-zig-a-step-by-step-project-guide-664a0f85378582de81c7ff87

const std = @import("std");

pub fn main() !void {
    const allocator = std.heap.page_allocator;

    var listener = try std.net.tcpListen(std.AddressFamily.ipv4);
    defer listener.deinit();

    try listener.bind(.{
        .address = std.net.Address.ipv4(.{ .addr = 0, .port = 8080 }),
        .reuse_address = true,
    });

    while (true) {
        var server_socket = try listener.accept();
        handleConnection(allocator, server_socket) catch |err| {
            std.log.err("Failed to handle connection: {}", .{err});
        };
    }
}

fn handleConnection(allocator: *std.mem.Allocator, server_socket: std.net.StreamServerSocket) !void {
    const reader = server_socket.reader();
    const writer = server_socket.writer();

    var buffer: [1024]u8 = undefined;

    const size = try reader.readAll(buffer[0..]);
    const request = buffer[0..size];

    std.log.info("Received request: {}", .{request});

    if (std.mem.startsWith(u8, request, "GET / ")) {
        const response = "HTTP/1.1 200 OK\r\nContent-Type: text/html\r\n\r\n";
        try writer.writeAll(response);
        try sendFile(writer, "index.html");
    } else if (std.mem.startsWith(u8, request, "GET /about ")) {
        const response = "HTTP/1.1 200 OK\r\nContent-Type: text/html\r\n\r\n<h1>About Us</h1>";
        try writer.writeAll(response);
    } else {
        const response = "HTTP/1.1 404 Not Found\r\n\r\n<h1>404 - Not Found</h1>";
        try writer.writeAll(response);
    }

    server_socket.close() catch |err| {
        std.log.err("Failed to close connection: {}", .{err});
    };
}

fn sendFile(writer: std.io.Writer, filename: []const u8) !void {
    const file = try std.fs.cwd().openFile(filename, .{});
    defer file.close();

    var buffer: [1024]u8 = undefined;
    while (true) {
        const read_bytes = try file.read(buffer[0..]);
        if (read_bytes.len == 0) break;
        try writer.writeAll(read_bytes);
    }
}
