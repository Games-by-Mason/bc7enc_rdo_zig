# bc7enc_rdo_zig
[bc7enc_rdo](https://github.com/richgel999/bc7enc_rdo) ported to the Zig build system. Builds the C++ executable and library, does not support the ISPC build.

## Safety Checks

Upstream does not currently pass Zig's debug mode safety checks, so it's always built in release fast or release small mode.

I may make an attempt to resolve this, but it isn't high priority as this is a build time dependency for me. Contributions welcome.

## Build Artifacts

### bc7enc (executable)

The `bc7enc` command line tool as would be produced by the original project.

### bc7enc-zig (executable)

Same as `bc7enc`, but patched to allow supplying an output argument with `-O`. This makes it easier to use with Zig's build system. I may eventually replace this with a command line tool implemented in Zig using [structopt](https://github.com/Games-by-Mason/structopt/), but this isn't high priority for me.

### bc7enc_rdo (library)

The library code without the command line tool.

## How to change versions
Update the version found in `build.zig.zon`.