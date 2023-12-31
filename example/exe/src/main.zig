const std = @import("std");
const zlib = @import("zlib");
const testing = std.testing;

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const input = "Hello";
    var cmp = try zlib.Compressor.init(allocator, .{ .header = .none });
    defer cmp.deinit();
    const compressed = try cmp.compressAllAlloc(input);
    defer allocator.free(compressed);

    var dcp = try zlib.Decompressor.init(allocator, .{ .header = .none });
    defer dcp.deinit();
    const decompressed = try dcp.decompressAllAlloc(compressed);
    defer allocator.free(decompressed);

    try std.testing.expectEqualSlices(u8, input, decompressed);
    std.debug.print("decompressed: {s}\n", .{decompressed});
}

test "simple test" {
    var list = std.ArrayList(i32).init(std.testing.allocator);
    defer list.deinit(); // try commenting this out and see if zig detects the memory leak!
    try list.append(42);
    try std.testing.expectEqual(@as(i32, 42), list.pop());
}

test "zlib compress/decompress" {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();
    //const allocator = testing.allocator;
    const input = "Hello";

    var cmp = try zlib.Compressor.init(allocator, .{ .header = .none });
    defer cmp.deinit();

    const compressed = try cmp.compressAllAlloc(input);
    defer allocator.free(compressed);
    showBuf(compressed);

    var dcmp = try zlib.Decompressor.init(allocator, .{ .header = .none });
    defer dcmp.deinit();

    const decompressed = try dcmp.decompressAllAlloc(compressed);
    defer allocator.free(decompressed);
    try testing.expectEqualSlices(u8, input, decompressed);
}

// debug helper
fn showBuf(buf: []const u8) void {
    std.debug.print("\n", .{});
    for (buf) |b|
        std.debug.print("0x{x:0>2}, ", .{b});
    std.debug.print("\n", .{});
}
