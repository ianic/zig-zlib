const std = @import("std");
const zlib = @import("zlib");

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
