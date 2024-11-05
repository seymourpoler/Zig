const std = @import("std");

pub const HttpRequest = struct {
    url: []const u8,
    headers: []const std.http.Header,
    body: []const u8,
};

pub const HttpResponse = struct {
    status: std.http.Status,
    body: []const u8,
};

pub const HttpClient = struct {
    allocator: std.mem.Allocator,
    client: std.http.Client,
    body: std.ArrayList(u8),

    pub fn init(allocator: std.mem.Allocator) @This() {
        return @This(){
            .allocator = allocator,
            .client = std.http.Client{ .allocator = allocator },
            .body = std.ArrayList(u8).init(allocator),
        };
    }

    pub fn initWithClient(allocator: std.mem.Allocator, client: std.http.Client) @This() {
        return @This(){
            .allocator = allocator,
            .client = client,
            .body = std.ArrayList(u8).init(allocator),
        };
    }

    pub fn deinit(self: *HttpClient) void {
        self.client.deinit();
        self.body.deinit();
    }

    pub fn get(self: *HttpClient, url: []const u8, headers: []const std.http.Header) !HttpResponse {
        const options = std.http.Client.FetchOptions{
            .location = std.http.Client.FetchOptions.Location{ .url = url },
            .method = .GET,
            .extra_headers = headers,
            .response_storage = .{ .dynamic = &self.body },
        };

        const response = try self.client.fetch(options);
        return HttpResponse{
            .status = response.status,
            .body = self.body.items,
        };
    }

    pub fn post(self: *HttpClient, request: HttpRequest) !HttpResponse {
        const options = std.http.Client.FetchOptions{
            .location = std.http.Client.FetchOptions.Location{ .url = request.url },
            .extra_headers = request.headers,
            .payload = request.body,
            .method = .POST,
            .response_storage = .{ .dynamic = &self.body },
        };

        const response = try self.client.fetch(options);
        return HttpResponse{
            .status = response.status,
            .body = self.body.items,
        };
    }

    pub fn put(self: *HttpClient, request: HttpRequest) !HttpResponse {
        const options = std.http.Client.FetchOptions{
            .location = std.http.Client.FetchOptions.Location{ .url = request.url },
            .extra_headers = request.headers,
            .payload = request.body,
            .method = .PUT,
            .response_storage = .{ .dynamic = &self.body },
        };

        const response = try self.client.fetch(options);
        return HttpResponse{
            .status = response.status,
            .body = self.body.items,
        };
    }

    pub fn delete(self: *HttpClient, request: HttpRequest) !HttpResponse {
        const options = std.http.Client.FetchOptions{
            .location = std.http.Client.FetchOptions.Location{ .url = request.url },
            .extra_headers = request.headers,
            .method = .DELETE,
        };

        const response = try self.client.fetch(options);
        return HttpResponse{
            .status = response.status,
            .body = "",
        };
    }
};
