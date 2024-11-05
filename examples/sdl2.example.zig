const std = @import("std");
const c = @cImport({
    @cInclude("SDL2/SDL.h");
});

pub fn main() !void {
    // Initialize SDL
    if (c.SDL_Init(c.SDL_INIT_VIDEO) < 0) return error.SDLInitializationFailed;
    defer c.SDL_Quit();

    // Create window
    const window = c.SDL_CreateWindow(
        "Simple SDL Window",
        c.SDL_WINDOWPOS_CENTERED,
        c.SDL_WINDOWPOS_CENTERED,
        400,
        300,
        c.SDL_WINDOW_SHOWN,
    ) orelse return error.WindowCreationFailed;
    defer c.SDL_DestroyWindow(window);

    // Create renderer
    const renderer = c.SDL_CreateRenderer(window, -1, c.SDL_RENDERER_ACCELERATED) orelse return error.RendererCreationFailed;
    defer c.SDL_DestroyRenderer(renderer);

    // Main loop
    var quit = false;
    while (!quit) {
        var event: c.SDL_Event = undefined;
        while (c.SDL_PollEvent(&event) != 0) {
            switch (event.type) {
                c.SDL_QUIT => quit = true,
                c.SDL_MOUSEBUTTONDOWN => {
                    const mouse_x = event.button.x;
                    const mouse_y = event.button.y;
                    // Check if click is in button area (center of window)
                    if (mouse_x > 150 and mouse_x < 250 and mouse_y > 120 and mouse_y < 180) {
                        std.debug.print("Button clicked!\n", .{});
                    }
                },
                else => {},
            }
        }

        // Clear screen
        _ = c.SDL_SetRenderDrawColor(renderer, 240, 240, 240, 255);
        _ = c.SDL_RenderClear(renderer);

        // Draw button (gray rectangle)
        var button_rect = c.SDL_Rect{ .x = 150, .y = 120, .w = 100, .h = 60 };
        _ = c.SDL_SetRenderDrawColor(renderer, 200, 200, 200, 255);
        _ = c.SDL_RenderFillRect(renderer, &button_rect);

        // Update screen
        c.SDL_RenderPresent(renderer);
    }
}
