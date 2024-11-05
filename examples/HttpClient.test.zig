const std = @import("std");
const testing = @import("std").testing;
const HttpClient = @import("./HttpClient.zig").HttpClient;
const HttpRequest = @import("./HttpClient.zig").HttpRequest;

test "httpClient" {
    const allocator = std.testing.allocator;

    var httpClient = HttpClient.init(allocator);
    defer httpClient.deinit();

    try testing.expectEqual(@TypeOf(httpClient), HttpClient);
}

test "HTTP/GET" {
    const Todo = struct {
        userId: usize,
        id: usize,
        title: []const u8,
        completed: bool,
    };
    const url = "https://jsonplaceholder.typicode.com/todos/1";
    const allocator = std.testing.allocator;
    var httpClient = HttpClient.init(allocator);
    defer httpClient.deinit();
    //const headers = [_]std.http.Header{.{ .name = "content-type", .value = "application/json" }};
    var headers = [_]std.http.Header{};

    const response = try httpClient.get(url, &headers);

    const parsed = try std.json.parseFromSlice(Todo, allocator, response.body, .{});
    defer parsed.deinit();
    try testing.expectEqual(.ok, response.status);
    try testing.expectEqual(1, parsed.value.userId);
    try testing.expectEqual(1, parsed.value.id);
    try testing.expectEqualStrings("delectus aut autem", parsed.value.title);
    try testing.expectEqual(false, parsed.value.completed);
}

test "HTTP/POST" {
    const Post = struct {
        userId: usize,
        body: []const u8,
        title: []const u8,
    };
    const PostCreated = struct {
        id: usize,
        userId: usize,
        body: []const u8,
        title: []const u8,
    };
    const allocator = std.testing.allocator;
    var httpClient = HttpClient.init(allocator);
    defer httpClient.deinit();

    const newPost = Post{
        .userId = 1,
        .title = "foo",
        .body = "bar",
    };
    const headers = [_]std.http.Header{.{ .name = "content-type", .value = "application/json" }};
    const httpRequestContent = try std.json.stringifyAlloc(allocator, newPost, .{});
    defer allocator.free(httpRequestContent);
    const request = HttpRequest{
        .url = "https://jsonplaceholder.typicode.com/posts",
        .headers = &headers,
        .body = httpRequestContent,
    };

    const response = try httpClient.post(request);

    const parsed = try std.json.parseFromSlice(PostCreated, allocator, response.body, .{});
    defer parsed.deinit();
    try testing.expectEqual(.created, response.status);
    try testing.expectEqual(101, parsed.value.id);
    try testing.expectEqual(1, parsed.value.userId);
    try testing.expectEqualStrings("bar", parsed.value.body);
    try testing.expectEqualStrings("foo", parsed.value.title);
}

test "HTTP/PUT" {
    const Post = struct {
        id: usize,
        userId: usize,
        body: []const u8,
        title: []const u8,
    };
    const allocator = std.testing.allocator;
    var httpClient = HttpClient.init(allocator);
    defer httpClient.deinit();
    const post = Post{
        .id = 1,
        .userId = 1,
        .title = "alter-title",
        .body = "alter-body",
    };
    const httpRequestContent = try std.json.stringifyAlloc(allocator, post, .{});
    defer allocator.free(httpRequestContent);
    const request = HttpRequest{
        .url = "https://reqbin.com/echo/put/json",
        .headers = &[_]std.http.Header{
            .{ .name = "content-type", .value = "application/json" },
        },
        .body = httpRequestContent,
    };

    const response = try httpClient.put(request);

    try testing.expectEqual(.ok, response.status);
}

test "HTTP/DELETE" {
    var httpClient = HttpClient.init(std.testing.allocator);
    defer httpClient.deinit();
    const headers = [_]std.http.Header{
        .{ .name = "content-type", .value = "application/json" },
    };
    const request = HttpRequest{
        .url = "https://reqbin.com/echo/delete/json",
        .headers = &headers,
        .body = "",
    };

    const response = try httpClient.delete(request);

    try testing.expectEqual(.ok, response.status);
}
