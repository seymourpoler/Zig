const std = @import("std");
const gtk = @cImport({
    @cInclude("gtk/gtk.h");
});

pub fn main() !void {
    // Initialize GTK
    gtk.gtk_init(0, null);

    // Create a new window
    var window = gtk.gtk_window_new(gtk.GTK_WINDOW_TOPLEVEL);
    gtk.gtk_window_set_title(window, "Hello, Zig!");
    gtk.gtk_window_set_default_size(window, 400, 300);

    // Create a button with a label
    var button = gtk.gtk_button_new_with_label("Click Me");
    gtk.g_signal_connect_data(
        button,
        "clicked",
        gtk.G_CALLBACK(@ptrCast(?*const anyopaque, on_button_clicked)),
        null,
        null,
        0,
    );

    // Add button to window and show everything
    gtk.gtk_container_add(window, button);
    gtk.gtk_widget_show_all(window);

    // Connect the window's close event
    gtk.g_signal_connect_data(
        window,
        "destroy",
        gtk.G_CALLBACK(@ptrCast(?*const anyopaque, gtk.gtk_main_quit)),
        null,
        null,
        0,
    );

    // Start GTK main loop
    gtk.gtk_main();
}

fn on_button_clicked(button: ?*gtk.GtkButton, user_data: ?*anyopaque) void {
    std.debug.print("Button clicked!\n", .{});
}
