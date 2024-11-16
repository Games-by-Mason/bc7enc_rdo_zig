const std = @import("std");

const flags = &.{};

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});

    // Debug mode builds trip safety checks, so only release builds are supported for now
    const optimize: std.builtin.OptimizeMode = switch (b.standardOptimizeOption(.{})) {
        .ReleaseSmall => .ReleaseSmall,
        else => .ReleaseFast,
    };

    const upstream = b.dependency("bc7enc_rdo", .{});

    const lib = b.addStaticLibrary(.{
        .name = "bc7enc_rdo",
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
        .flags = flags,
    });
    lib.linkLibCpp();
    lib.installHeadersDirectory(upstream.path("."), "bc7enc", .{});
    b.installArtifact(lib);

    const exe = b.addExecutable(.{
        .name = "bc7enc",
        .target = target,
        .optimize = optimize,
    });

    exe.addIncludePath(upstream.path(""));
    exe.addCSourceFiles(.{
        .root = upstream.path(""),
        .files = &.{
            "test.cpp",
        },
        .flags = flags,
    });
    exe.linkLibrary(lib);
    b.installArtifact(exe);

    const exe_zig = b.addExecutable(.{
        .name = "bc7enc-zig",
        .target = target,
        .optimize = optimize,
    });

    exe_zig.addIncludePath(upstream.path(""));
    exe_zig.addCSourceFiles(.{
        .root = b.path("src"),
        .files = &.{
            "main.cpp",
        },
        .flags = flags,
    });
    exe_zig.linkLibrary(lib);
    b.installArtifact(exe_zig);

    const run_cmd = b.addRunArtifact(exe_zig);
    run_cmd.step.dependOn(b.getInstallStep());
    if (b.args) |args| {
        run_cmd.addArgs(args);
    }
    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);
}
