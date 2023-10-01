const std = @import("std");

pub const OutputMode = enum { 
    PNG,
    PNG_CAIRO,
    QT,
    X11,
    Default
};

pub const PlotConfig = struct {


    output_mode: OutputMode,
    name: ?[]const u8 = null,
    sepatator: ?[]const u8 = null,

    grid: bool = false,

    xLabel: ?[]const u8 = null,
    yLabel: ?[]const u8 = null,
};