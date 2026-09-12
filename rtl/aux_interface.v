`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:37:33 05/27/2026 
// Design Name: 
// Module Name:    aux_interface 
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
// parellel in parallel out
module aux_interface( input clk , rst,
 input [31:0]aux_in ,  
 output reg [31:0]aux_i);

// To store the auxillary inputs
	always @(posedge clk or posedge rst)
		begin
			if(rst)
				aux_i <= 32'b0;
			else
				aux_i<= aux_in;
		end 
		
		
endmodule
