const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const upstream = b.dependency("bz7enc_rdo", .{});

    const lib = b.addStaticLibrary(.{
        .name = "bz7enc",
        .target = target,
        .optimize = optimize,
    });
    lib.addIncludePath(upstream.path(""));
    lib.addCSourceFiles(.{
        .root = upstream.path(""),
        .files = &.{
            "bc7enc.cpp",
            "bc7decomp.cpp",
            "bc7decomp_ref.cpp",
            "lodepng.cpp",
            "rgbcx.cpp",
            "utils.cpp",
            "ert.cpp",
            "rdo_bc_encoder.cpp",
        },
    });
    lib.linkLibCpp();
    lib.installHeadersDirectory(upstream.path("."), "bc7enc", .{});
    b.installArtifact(lib);

    const exe = b.addExecutable(.{
        .name = "bz7enc",
        .target = target,
        .optimize = optimize,
    });

    exe.addIncludePath(upstream.path(""));
    exe.addCSourceFiles(.{
        .root = upstream.path(""),
        .files = &.{
            "test.cpp",
        },
    });
    exe.linkLibrary(lib);
    b.installArtifact(exe);

    const run_cmd = b.addRunArtifact(exe);
    run_cmd.step.dependOn(b.getInstallStep());
    if (b.args) |args| {
        run_cmd.addArgs(args);
    }
    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);
}
