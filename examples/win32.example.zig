const std = @import("std");
const windows = std.os.windows;
const WINAPI = windows.WINAPI;
const HWND = windows.HWND;
const UINT = windows.UINT;
const WPARAM = windows.WPARAM;
const LPARAM = windows.LPARAM;
const LRESULT = windows.LRESULT;
const HINSTANCE = windows.HINSTANCE;
const L = std.unicode.utf8ToUtf16LeStringLiteral;
const USER32 = windows.user32;
const KERNEL32 = windows.kernel32;

pub export fn WinMain(
    hInstance: HINSTANCE,
    _: ?HINSTANCE,
    _: [*:0]u8,
    _: c_int,
) callconv(WINAPI) c_int {
    const className = L("ZigWindowClass");
    const buttonClassName = L("BUTTON");

    const wc = windows.user32.WNDCLASSEXW{
        .style = 0,
        .lpfnWndProc = windowProc,
        .cbClsExtra = 0,
        .cbWndExtra = 0,
        .hInstance = hInstance,
        .hIcon = null,
        .hCursor = null,
        .hbrBackground = @ptrFromInt(6), // COLOR_WINDOW + 1
        .lpszMenuName = null,
        .lpszClassName = className,
        .hIconSm = null,
        .cbSize = @sizeOf(windows.user32.WNDCLASSEXW),
    };

    _ = USER32.RegisterClassExW(&wc);

    const hwnd = USER32.CreateWindowExW(
        0,
        className,
        L("My Zig Window"),
        windows.user32.WS_OVERLAPPEDWINDOW | windows.user32.WS_VISIBLE,
        windows.user32.CW_USEDEFAULT,
        windows.user32.CW_USEDEFAULT,
        800,
        600,
        null,
        null,
        hInstance,
        null,
    );

    // Create button
    _ = USER32.CreateWindowExW(
        0,
        buttonClassName,
        L("Click Me!"),
        windows.user32.WS_CHILD | windows.user32.WS_VISIBLE,
        350, // x position
        250, // y position
        100, // width
        30, // height
        hwnd,
        @ptrFromInt(1), // button ID
        hInstance,
        null,
    );

    var msg: windows.user32.MSG = undefined;
    while (USER32.GetMessageW(&msg, null, 0, 0) != 0) {
        _ = USER32.TranslateMessage(&msg);
        _ = USER32.DispatchMessageW(&msg);
    }

    return @intCast(msg.wParam);
}

fn windowProc(
    hwnd: HWND,
    uMsg: UINT,
    wParam: WPARAM,
    lParam: LPARAM,
) callconv(WINAPI) LRESULT {
    switch (uMsg) {
        windows.user32.WM_DESTROY => {
            USER32.PostQuitMessage(0);
            return 0;
        },
        windows.user32.WM_COMMAND => {
            const buttonId = @as(u16, @truncate(@as(c_int, @bitCast(wParam))));
            if (buttonId == 1) {
                _ = USER32.MessageBoxW(
                    hwnd,
                    L("Button clicked!"),
                    L("Notice"),
                    windows.user32.MB_OK,
                );
            }
            return 0;
        },
        else => return USER32.DefWindowProcW(hwnd, uMsg, wParam, lParam),
    }
}
