const std = @import("std");

/// Combination Build Module and name
const Module = struct {
    name: []const u8,
    module: *std.Build.Module,
};

pub fn build(b: *std.Build) void {
    // Standard release options allow the person running `zig build` to select
    // between Debug, ReleaseSafe, ReleaseFast, and ReleaseSmall.
    const optimize = b.standardOptimizeOption(.{});
    const target = b.standardTargetOptions(.{});

    // Create Modules for our boilerplate code for easier import
    const data = createModule(b, "data", "data/data.zig");
    const utils = createModule(b, "utils", "../common/utils.zig");

    const exe = b.addExecutable(.{
        .name = "day1",
        .root_source_file = b.path("src/main.zig"),
        .optimize = .ReleaseSafe, // Just set ReleaseSafe; not much use in Debug
        .target = target,
    });
    exe.root_module.addImport(data.name, data.module);
    exe.root_module.addImport(utils.name, utils.module);
    b.installArtifact(exe);

    const run_cmd = b.addRunArtifact(exe);
    run_cmd.step.dependOn(b.getInstallStep());
    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);

    var modules: [2]Module = [_]Module{ data, utils };
    addTest(b, "test", "Run unit tests", "src/main.zig", optimize, &modules);
}

/// Create a new ModuleDependency
fn createModule(b: *std.Build, name: []const u8, source_file: []const u8) Module {
    return Module{
        .name = name,
        .module = b.createModule(.{ .root_source_file = b.path(source_file) }),
    };
}

/// Add a unit test step using the given file
///
/// @param[inout] b: Mutable pointer to the Build object
/// @param[in] cmd: The build step name ('zig build cmd')
/// @param[in] description: The description for 'zig build -l'
/// @param[in] path: The zig file to test
/// @param[in] optimize: Build optimization settings
fn addTest(b: *std.Build, cmd: []const u8, description: []const u8, path: []const u8, optimize: std.builtin.Mode, modules: []const Module) void {
    const test_exe = b.addTest(.{
        .root_source_file = b.path(path),
        .optimize = optimize,
    });
    for (modules) |mod| {
        test_exe.root_module.addImport(mod.name, mod.module);
    }

    const run_step = b.addRunArtifact(test_exe);
    run_step.has_side_effects = true; // Force the test to always be run on command
    const step = b.step(cmd, description);
    step.dependOn(&run_step.step);
}
