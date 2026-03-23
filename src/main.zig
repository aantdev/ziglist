const std = @import("std");

const linkedList = @import("./linkedlist.zig").LinkedList;

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer(arena.deinit());

    const allocator = arena.allocator();
    var strList = linkedList([]const u8).new(allocator);

    try strList.insert("Hello,");
    try strList.append("World!");

    try strList.print();
}