const std = @import("std");
const PlotLib = @import("Plot");
const Cfg = PlotLib.PlotConfig;
const SubCfg = PlotLib.SubPlotConfig;
const Plot = PlotLib.Plot.Plot;


pub fn main() !void {
    
    var subconfig1 = SubCfg.SubPlotConfig {
        .plot_type = .Lines,
        .source = "2*x+11",
        .source_type = .Function,
        .line_width = 7,
        .line_color = .Red,
    };

    var subconfig2 = SubCfg.SubPlotConfig {
        .plot_type = .Dots,
        .source = "3*x+11",
        .source_type = .Function,
        .line_width = 5,
        .line_color = .Blue,
    };

    var config = Cfg.PlotConfig {
        .output_mode = .Default,
        .grid = true,
        //.name = "Pipo",
    };

    var plot = Plot(2){};

    plot.subplots[0] = subconfig1;
    plot.subplots[1] = subconfig2;
    plot.config = config;

    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();

    var allocator = gpa.allocator();

    const s = std.time.nanoTimestamp();
    
    var str = try plot.GetExecuteString(allocator);
    defer allocator.free(str);

    const print = std.io.getStdOut().writer();

    try print.print("{s}\n", .{str});

    const gnuplot = "gnuplot";
    const flag1 = "-p";
    const flag2 = "-e";

    var process = std.ChildProcess.init(&[_][]const u8{gnuplot, flag1, flag2, str}, allocator);

    const data = process.spawnAndWait() catch |err| {
        try print.print("ERROR: {}\n", .{err});
        return;
    };

    try print.print("Status: {s}\n", .{@tagName(data)});
    try print.print("Code: {}\n", .{@intFromEnum(data)});
    const e = std.time.nanoTimestamp();
    try print.print("Time: {}\n", .{std.fmt.fmtDurationSigned(@truncate(e-s))});


    //try print("{d}\n", .{str.len});
}



//ejecutar gnuplot sin script
//gnuplot -p -e "plot 2*x+1 with lines lw 3 lc 5"