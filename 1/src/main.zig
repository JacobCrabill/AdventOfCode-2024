const std = @import("std");
const Data = @import("data");
const utils = @import("utils");

const Allocator = std.mem.Allocator;
const ArrayList = std.ArrayList;
const GPA = std.heap.GeneralPurposeAllocator;
const ns2sec = utils.ns2sec;

const log = std.log.scoped(.AoC);
const print = std.debug.print;

pub fn main() !void {
    var gpa = GPA(.{}){};
    defer _ = gpa.deinit(); // Performs leak checking
    const alloc = gpa.allocator();

    var T = try std.time.Timer.start();

    const res1 = try part1(Data.input, alloc);
    log.info("Part 1 answer: << {d} >>", .{res1});
    log.info("Part 1 took {d:.6}s", .{ns2sec(T.lap())});

    const res2 = try part2(Data.input, alloc);
    log.info("Part 2 answer: << {d} >>", .{res2});
    log.info("Part 2 took {d:.6}s", .{ns2sec(T.lap())});
}

// ------------ Tests ------------

test "part1 test input" {
    log.warn(" -- Running Tests --", .{});

    const answer: usize = 11;

    const alloc = std.testing.allocator;
    const res = try part1(Data.test_input, alloc);
    log.warn("[Test] Part 1: {d}", .{res});
    try std.testing.expect(res == answer);
}

test "part2 test input" {
    const answer: usize = 31;

    const alloc = std.testing.allocator;
    const res = try part2(Data.test_input, alloc);
    log.warn("[Test] Part 2: {d}", .{res});
    try std.testing.expect(res == answer);
}

// ------------ Part 1 Solution ------------

pub fn part1(input: []const u8, alloc: Allocator) !usize {
    var col1 = ArrayList(usize).init(alloc);
    var col2 = ArrayList(usize).init(alloc);
    defer col1.deinit();
    defer col2.deinit();

    var lines = utils.lines(input);
    while (lines.next()) |line| {
        if (line.len == 0) break;
        var iter = std.mem.tokenize(u8, line, " ");
        const a = try std.fmt.parseInt(usize, iter.next().?, 10);
        const b = try std.fmt.parseInt(usize, iter.next().?, 10);
        try col1.append(a);
        try col2.append(b);
    }

    utils.heapSortAsc(usize, col1.items);
    utils.heapSortAsc(usize, col2.items);

    var sum: usize = 0;
    for (col1.items, 0..) |a, i| {
        const b = col2.items[i];
        sum += @max(a, b) - @min(a, b);
    }
    return sum;
}

// ------------ Part 2 Solution ------------

pub fn part2(input: []const u8, alloc: Allocator) !usize {
    var col1 = ArrayList(usize).init(alloc);
    var col2 = ArrayList(usize).init(alloc);
    defer col1.deinit();
    defer col2.deinit();

    var lines = utils.lines(input);
    while (lines.next()) |line| {
        if (line.len == 0) break;
        var iter = std.mem.tokenize(u8, line, " ");
        const a = try std.fmt.parseInt(usize, iter.next().?, 10);
        const b = try std.fmt.parseInt(usize, iter.next().?, 10);
        try col1.append(a);
        try col2.append(b);
    }

    utils.heapSortAsc(usize, col1.items);
    utils.heapSortAsc(usize, col2.items);

    var sum: usize = 0;
    for (col1.items) |a| {
        const count = utils.countScalar(usize, col2.items, a);
        sum += count * a;
    }
    return sum;
}

// ------------ Common Functions ------------
