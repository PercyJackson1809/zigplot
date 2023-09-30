const std = @import("std");

pub const SourceType = enum {
    File,
    Function
};

pub const PlotType = enum {
    Lines,
    Points,
    LinesAndPoints,
    Impulses,
    Dots,
    Steps,
};

pub const LineType = enum(u4) {
    Dot,
    Sum,
    X,
    Asterisk,
    Square,
    Square_Filled,
    Circle,
    Circle_Filled,
    Triangle,
    Triangle_Filled,
    Reverse_Triangle,
    Reverse_Triangle_Filled,
    Diamond,
    Diamond_Filled,
    Pentagon,
    Pentagon_Filled,
};

pub const LineColor = enum(u4) {
    Gray,
    Purple,
    Green1,
    Cyan,
    Orange_Yellow,
    Yellow,
    Blue,
    Red,
    Black,
};

pub const SubPlotConfig = struct {
    
    source_type: SourceType,
    source: []const u8,

    title: ?[]const u8 = null,

    using: ?[]const u8 = null,

    plot_type: PlotType,

    line_width: ?u8 = null,
    line_color: ?LineColor = null,
    line_type: ?LineType = null,
    point_size: ?u8 = null,
};