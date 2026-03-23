const std = @import("std");

pub fn build(b: *std.Build) void {
    const exe = b.addExecutable(.{
        .name = "out",
        .root_module = b.createModule(.{
            .root_source_file = b.path("./src/main.zig"),
            .target = b.graph.host,
        }),
    });

    b.installArtifact(exe);

    const run_exe = b.addRunArtifact(exe);
    const run_step = b.step("run", "run the application");
    run_step.dependOn(&run_exe.step);

    const main_tests = b.addTest(.{
        .name = "main-tests",
        .root_module = b.createModule(.{
            .root_source_file = b.path("./src/linkedlist.zig"),
            .target = b.graph.host,
        })
    });

    const run_main_tests = b.addRunArtifact(main_tests);

    const test_step = b.step("test", "Run lib tests");
    test_step.dependOn(&run_main_tests.step);
    
}
