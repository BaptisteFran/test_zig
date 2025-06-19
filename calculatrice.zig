const std = @import("std");
const stdin = std.io.getStdIn().reader();
const stdout = std.io.getStdOut().writer();

pub fn main() !void {
    const zig_text = "Zig";
    try stdout.print("C'est une calculatrice en mode console pour test le langage {s}\n", .{zig_text});

    // Need buffer to store values
    var buffer: [100]u8 = undefined;

    // Reads first number
    try stdout.print("Choose the first number : ", .{});
    const line1 = try stdin.readUntilDelimiterOrEof(&buffer, '\n');
    const num1 = try parseInt(line1 orelse return error.InvalidInput); // if cannot read line1, return error.InvalidInput

    // Reads operator
    try stdout.print("Enter the operator (+, -, *, /) : ", .{});
    const op_line = try stdin.readUntilDelimiterOrEof(&buffer, '\n');
    const op_trimmed = std.mem.trim(u8, op_line orelse return error.InvalidInput, " \r\n");

    if (op_trimmed.len != 1) return error.InvalidOperator;
    const op_char = op_trimmed[0];

    // Reads second number
    try stdout.print("Choose the second number : ", .{});
    const line2 = try stdin.readUntilDelimiterOrEof(&buffer, '\n');
    const num2 = try parseInt(line2 orelse return error.InvalidInput);

    // Calcul & display
    const result = switch(op_char) {
        '+' => num1 + num2,
        '-' => num1 - num2,
        '*' => num1 * num2,
        '/' => if (num2 != 0 and num1 != 0) @divTrunc(num1,num2) else return error.DivideByZero,
        else => return std.log.err("Error while trying to calculate operation : {}", .{error.InvalidOperator}),
    };

    try stdout.print("Result : {}\n", .{result});
}

fn parseInt(input: []const u8) !i32 {
    return std.fmt.parseInt(i32, std.mem.trim(u8, input, " \r\n"), 10);
}
