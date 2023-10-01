const std = @import("std");
const Cfg = @import("PlotConfig.zig");
const SubCfg = @import("SubPlotConfig.zig");

pub fn Plot(comptime nPlots: usize) type {
    return struct {
        const Self = @This();

        subplots: [nPlots] SubCfg.SubPlotConfig = undefined,
        config: Cfg.PlotConfig = undefined,

        pub fn GetExecuteString(self: *Self, allocator: std.mem.Allocator) ![]const u8 {

            var output = std.ArrayList(u8).init(allocator);
            
            const outMode = self.config.output_mode;

            if(outMode != Cfg.OutputMode.Default) {
                try output.appendSlice("set term ");
                const str: []const u8 = switch (outMode) {
                    .PNG => "png",
                    .PNG_CAIRO => "pngcairo",
                    .X11 => "x11",
                    .QT => "qt",
                    else => unreachable
                };
                try output.appendSlice(str);
                try output.append(';');
            }

            if((outMode == Cfg.OutputMode.PNG_CAIRO or 
                outMode == Cfg.OutputMode.PNG)) {
                    if(self.config.name) |name| {
                        try output.appendSlice("set output '");
                        try output.appendSlice(name);
                        try output.appendSlice("';");
                    } else {
                        return error.NoNameSetted;
                    }
                }

            if(self.config.grid) {
                try output.appendSlice("set grid;");
            }

            if(self.config.xLabel) |label| {
                try output.appendSlice("set xlabel ");
                try output.appendSlice(label);
                try output.append(';');
            }

            if(self.config.yLabel) |label| {
                try output.appendSlice("set ylabel ");
                try output.appendSlice(label);
                try output.append(';');
            }

            if(self.config.separator) |separator| {
                try output.appendSlice("set datafile separator '");
                try output.appendSlice(separator);
                try output.appendSlice("';");
            }

            //-----------------Per Plot Config----------------------

            var formatBuffer: [16]u8 = undefined;
            var fixedBufferAllocator = std.heap.FixedBufferAllocator.init(&formatBuffer);
            var buffAlloc = fixedBufferAllocator.allocator();

            try output.appendSlice("plot");
            for(self.subplots, 0..nPlots) |subplot, i| {
                try output.append(' ');
                if(subplot.source_type == .File) {
                    try output.append('\'');
                }
                try output.appendSlice(subplot.source);

                if(subplot.source_type == .File) {
                    try output.append('\'');
                }

                if(subplot.title) |title| {
                    try output.appendSlice(" title '");
                    try output.appendSlice(title);
                    try output.append('\'');
                }

                if(subplot.using) |using| {
                    try output.append(' ');
                    try output.appendSlice(using);
                }

                try output.appendSlice(" with ");
                const typeStr = switch (subplot.plot_type) {
                    .Lines => "lines",
                    .Points => "points",
                    .LinesAndPoints => "linespoints",
                    .Impulses => "impulses",
                    .Dots => "dots",
                    .Steps => "steps",
                };
                try output.appendSlice(typeStr);

                if(subplot.line_width) |lw| {
                    const lwStr = try std.fmt.allocPrint(buffAlloc, "{d}", .{lw});
                    try output.appendSlice(" lw ");
                    try output.appendSlice(lwStr);
                    fixedBufferAllocator.reset();
                }

                if(subplot.point_size) |ps| {
                    const psStr = try std.fmt.allocPrint(buffAlloc, "{d}", .{ps});
                    try output.appendSlice(" ps ");
                    try output.appendSlice(psStr);
                    fixedBufferAllocator.reset();
                }

                if(subplot.line_type) |lt| {
                    const ltStr = try std.fmt.allocPrint(buffAlloc, "{d}", .{@intFromEnum(lt)});
                    try output.appendSlice(" lt ");
                    try output.appendSlice(ltStr);
                    fixedBufferAllocator.reset();
                }

                if(subplot.line_color) |lc| {
                    const lcStr = try std.fmt.allocPrint(buffAlloc, "{d}", .{@intFromEnum(lc)});
                    try output.appendSlice(" lc ");
                    try output.appendSlice(lcStr);
                    fixedBufferAllocator.reset();
                }

                if(i != nPlots-1) {
                    try output.append(',');
                }
            }

            //try output.append('"');
            
            //return allocator.dupe(u8, output.items);
            return output.toOwnedSlice();
        }

    };
}