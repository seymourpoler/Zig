const std = @import("std");
const c = @cImport({
    @cInclude("SDL2/SDL.h");
    @cInclude("microui.h");
});

pub fn main() !void {
    // Initialize SDL
    if (c.SDL_Init(c.SDL_INIT_VIDEO) < 0) return error.SDLInitializationFailed;
    defer c.SDL_Quit();

    // Create window
    const window = c.SDL_CreateWindow("Simple Window", c.SDL_WINDOWPOS_CENTERED, c.SDL_WINDOWPOS_CENTERED, 400, 300, c.SDL_WINDOW_SHOWN) orelse return error.WindowCreationFailed;
    defer c.SDL_DestroyWindow(window);

    // Initialize microui
    var ctx: c.mu_Context = undefined;
    c.mu_init(&ctx);

    var quit = false;
    while (!quit) {
        var event: c.SDL_Event = undefined;
        while (c.SDL_PollEvent(&event) != 0) {
            if (event.type == c.SDL_QUIT) quit = true;
        }

        // Begin frame
        c.mu_begin(&ctx);

        // Create window with button
        if (c.mu_begin_window(&ctx, "My Window", c.mu_rect(10, 10, 380, 280))) {
            if (c.mu_button(&ctx, "Click Me")) {
                std.debug.print("Button clicked!\n", .{});
            }
            c.mu_end_window(&ctx);
        }

        // End frame
        c.mu_end(&ctx);
    }
}
