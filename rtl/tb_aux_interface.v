`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:52:35 06/13/2026 
// Design Name: 
// Module Name:    tb_aux_interface 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
`timescale 1ns / 1ps

module tb_aux_interface;

reg clk;
reg rst;
reg [31:0] aux_in;
wire [31:0] aux_i;

// Instantiate DUT
aux_interface dut (
    .clk(clk),
    .rst(rst),
    .aux_in(aux_in),
    .aux_i(aux_i)
);

// Generate 100 MHz clock
always #5 clk = ~clk;

// Display signal values whenever they change
initial begin
    $monitor("T=%0t | rst=%b | aux_in=%h | aux_i=%h",
              $time, rst, aux_in, aux_i);
end

// Test sequence
initial begin

    // Initialize signals
    clk    = 0;
    rst    = 1;
    aux_in = 32'h00000000;

    // Keep reset active for a short duration
    #12;
    rst = 0;

    // Apply first test value
    aux_in = 32'h12345678;
    #20;

    // Change the auxiliary input
    aux_in = 32'hA5A5A5A5;
    #20;

    // Apply another pattern
    aux_in = 32'hFFFFFFFF;
    #20;

    // Verify reset operation
    rst = 1;
    #10;

    rst = 0;
    aux_in = 32'hDEADBEEF;
    #20;

    $finish;
end

endmodule
