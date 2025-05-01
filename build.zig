const std = @import("std");

// Although this function looks imperative, note that its job is to
// declaratively construct a build graph that will be executed by an external
// runner.
pub fn build(b: *std.Build) void {
    // Standard target options allows the person running `zig build` to choose
    // what target to build for. Here we do not override the defaults, which
    // means any target is allowed, and the default is native. Other options
    // for restricting supported target set are available.
    const target = b.standardTargetOptions(.{});

    // Standard optimization options allow the person running `zig build` to select
    // between Debug, ReleaseSafe, ReleaseFast, and ReleaseSmall. Here we do not
    // set a preferred release mode, allowing the user to decide how to optimize.
    const optimize = b.standardOptimizeOption(.{});

    const shared = b.option(bool, "shared", "Build as a shared library") orelse false;

    const lib: *std.Build.Step.Compile = switch (shared) {
        inline else => |x| switch (x) {
            false => std.Build.addStaticLibrary,
            true => std.Build.addSharedLibrary,
        }(b, .{
            .name = "cglm",
            .target = target,
            .optimize = optimize,
        }),
    };

    lib.linkLibC();

    lib.addCSourceFiles(.{
		.files = &sources,
	});

    lib.installHeadersDirectory(b.path("include/cglm"), "cglm", .{});
    lib.addIncludePath(b.path("include/"));

    b.installArtifact(lib);
}


const sources = [_][]const u8{
	"src/euler.c",
	"src/affine.c",
	"src/io.c",
	"src/quat.c",
	"src/cam.c",
	"src/vec2.c",
	"src/ivec2.c",
	"src/vec3.c",
	"src/ivec3.c",
	"src/vec4.c",
	"src/ivec4.c",
	"src/mat2.c",
	"src/mat2x3.c",
	"src/mat2x4.c",
	"src/mat3.c",
	"src/mat3x2.c",
	"src/mat3x4.c",
	"src/mat4.c",
	"src/mat4x2.c",
	"src/mat4x3.c",
	"src/plane.c",
	"src/noise.c",
	"src/frustum.c",
	"src/box.c",
	"src/aabb2d.c",
	"src/project.c",
	"src/sphere.c",
	"src/ease.c",
	"src/curve.c",
	"src/bezier.c",
	"src/ray.c",
	"src/affine2d.c",
	"src/clipspace/ortho_lh_no.c",
	"src/clipspace/ortho_lh_zo.c",
	"src/clipspace/ortho_rh_no.c",
	"src/clipspace/ortho_rh_zo.c",
	"src/clipspace/persp_lh_no.c",
	"src/clipspace/persp_lh_zo.c",
	"src/clipspace/persp_rh_no.c",
	"src/clipspace/persp_rh_zo.c",
	"src/clipspace/view_lh_no.c",
	"src/clipspace/view_lh_zo.c",
	"src/clipspace/view_rh_no.c",
	"src/clipspace/view_rh_zo.c",
	"src/clipspace/project_no.c",
	"src/clipspace/project_zo.c",
};