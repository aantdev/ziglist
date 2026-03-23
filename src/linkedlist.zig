const std = @import("std");

pub fn LinkedList(comptime T: type) type {
    return struct {
        const Self = @This();
    
        const Node = struct {
            value: T,
            next: ?*Node
        };

        head: ?*Node,
        tail: ?*Node,
        length: u32, 
        allocator: std.mem.Allocator,

        pub fn new(allocator: std.mem.Allocator) Self {
            return .{.head=null, .tail=null, .length=0, .allocator=allocator};
        }

        pub fn append(self: *Self, value: T) !void {

            // construct the new node...
            // since newNode is expected to be new tail, next is always null.
            var newNode = try self.allocator.create(Node);
            newNode.value = value;
            newNode.next = null;
            
            // if a tail already exists (list not empty) assign it's next as current tail
            // otherwise the list is empty and the node is head and tail.
            if (self.tail) |tail| {
                tail.next = newNode;
            } else {
                self.head = newNode;
            }

            self.tail = newNode;
            self.length += 1;
        }

        pub fn insert(self: *Self, value: T) !void {
            
            var newNode = try self.allocator.create(Node);
            
            const currentHead = self.head;
            newNode.value = value;
            newNode.next = null;

            newNode.next = currentHead;
            self.head = newNode;

            if (self.tail == null) {
                self.tail = newNode;
            }

            self.length += 1;
        }

        pub fn popHead(self: *Self) ?T {
            if (self.head == null) {
                return null;
            }

            const value = self.head.?.value;
            
            const newHead = self.head.?.next;
            self.head = newHead;
            self.length -= 1;

            return value;
        }

        pub fn print(self: *Self) !void {
            if (self.head == null) {
                return;
            }

            var currentNode = self.head;

            while (currentNode != null) : (currentNode = currentNode.?.next) {
                std.log.info("Node value: {s}", .{currentNode.?.value});
            }

        }
    };
}

test "Empty list creation" {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer(arena.deinit());

    const allocator = arena.allocator();
    const strList = LinkedList([]u8).new(allocator);

    try std.testing.expect(strList.length == 0);
    try std.testing.expect(strList.head == null);
    try std.testing.expect(strList.tail == null);
}

test "Empty list append" {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer(arena.deinit());

    const allocator = arena.allocator();
    var strList = LinkedList([]const u8).new(allocator);

    try strList.append("Hello");
    try strList.append("World!");

    try std.testing.expect(strList.length == 2);
    try std.testing.expect(strList.head != null);
    try std.testing.expect(strList.tail != null);
}

test "Empty list insert" {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer(arena.deinit());

    const allocator = arena.allocator();
    var strList = LinkedList([]const u8).new(allocator);

    try strList.insert("World!");
    try strList.insert("Hello");

    try std.testing.expect(strList.length == 2);

    try std.testing.expectEqualStrings("Hello", strList.head.?.value);
    try std.testing.expectEqualStrings("World!", strList.tail.?.value);
}

test "Empty list insert then append" {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer(arena.deinit());

    const allocator = arena.allocator();
    var strList = LinkedList([]const u8).new(allocator);

    try strList.insert("Hello");
    try strList.append("World!");

    try std.testing.expect(strList.length == 2);
    try std.testing.expectEqualStrings("Hello", strList.head.?.value);
    try std.testing.expectEqualStrings("World!", strList.tail.?.value);
}

test "Empty list append then insert" {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer(arena.deinit());

    const allocator = arena.allocator();
    var strList = LinkedList([]const u8).new(allocator);

    try strList.append("World!");
    try strList.insert("Hello");

    try std.testing.expect(strList.length == 2);
    try std.testing.expectEqualStrings("Hello", strList.head.?.value);
    try std.testing.expectEqualStrings("World!", strList.tail.?.value);
}

test "Pop from list" {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer(arena.deinit());

    const allocator = arena.allocator();
    var strList = LinkedList([]const u8).new(allocator);

    try strList.append("World!");
    try strList.insert("Hello,");

    const poppedValue = strList.popHead();

    try std.testing.expect(strList.length == 1);
    try std.testing.expect(poppedValue != null);
    try std.testing.expectEqualStrings("World!", strList.head.?.value);
}