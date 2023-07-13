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
    //try std.testing.expectEqualSlices(u8, &[_]u8{ 0xf2, 0x48, 0xcd, 0xc9, 0xc9, 0x07, 0x04, 0x00, 0x00, 0xff, 0xff }, compressed);

    var dcp = try zlib.Decompressor.init(allocator, .{ .header = .none });
    defer dcp.deinit();
    const decompressed = try dcp.decompressAllAlloc(compressed);
    defer allocator.free(decompressed);

    try std.testing.expectEqualSlices(u8, input, decompressed);

    std.debug.print("decompressed: {s}\n", .{decompressed});
}

test "Hello from example1" {
    const allocator = std.testing.allocator;
    const input = "Hello";

    var cmp = try zlib.Compressor.init(allocator, .{ .header = .none });
    defer cmp.deinit();
    const compressed = try cmp.compressAllAlloc(input);
    defer allocator.free(compressed);
    //try std.testing.expectEqualSlices(u8, &[_]u8{ 0xf2, 0x48, 0xcd, 0xc9, 0xc9, 0x07, 0x04, 0x00, 0x00, 0xff, 0xff }, compressed);

    var dcp = try zlib.Decompressor.init(allocator, .{ .header = .none });
    defer dcp.deinit();
    const decompressed = try dcp.decompressAllAlloc(compressed);
    defer allocator.free(decompressed);

    try std.testing.expectEqualSlices(u8, input, decompressed);
}

// test with:
// $ zig test -l z  --main-pkg-path . --deps zlib=zlib --mod zlib::src/main.zig example/example1.zig

// build/run with:
// zig build && zig-out/bin/example1
