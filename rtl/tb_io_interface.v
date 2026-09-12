`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:14:05 06/12/2026 
// Design Name: 
// Module Name:    tb_io_interface 
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
module tb_io_interface;

reg ext_clk_pad_i;
reg [31:0] out_pad_o , oen_padoe_o;
wire [31:0] in_pad_i;
wire  [31:0]io_pad;
wire  gpio_eclk;


io_interface dut( ext_clk_pad_i,
							out_pad_o , oen_padoe_o,
							in_pad_i,
							io_pad,
							 gpio_eclk);

initial 
begin
	ext_clk_pad_i = 1'b0;
	forever 
	#40 ext_clk_pad_i = ~ext_clk_pad_i;
end


reg [31:0] io_pad_temp;

initial 
begin
	io_pad_temp = 32'h0000BBBB;
	out_pad_o = 32'hEEEE0000;
	oen_padoe_o = 32'hFFFF0000;
end

	assign io_pad[0] = ~oen_padoe_o[0]?io_pad_temp[0]:1'bz;
	assign io_pad[1] = ~oen_padoe_o[1]?io_pad_temp[1]:1'bz;
	assign io_pad[2] = ~oen_padoe_o[2]?io_pad_temp[2]:1'bz;
	assign io_pad[3] = ~oen_padoe_o[3]?io_pad_temp[3]:1'bz;
	assign io_pad[4] = ~oen_padoe_o[4]?io_pad_temp[4]:1'bz;
	assign io_pad[5] = ~oen_padoe_o[5]?io_pad_temp[5]:1'bz;
	assign io_pad[6] = ~oen_padoe_o[6]?io_pad_temp[6]:1'bz;
	assign io_pad[7] = ~oen_padoe_o[7]?io_pad_temp[7]:1'bz;
	assign io_pad[8] = ~oen_padoe_o[8]?io_pad_temp[8]:1'bz;
	assign io_pad[9] = ~oen_padoe_o[9]?io_pad_temp[9]:1'bz;
	assign io_pad[10] = ~oen_padoe_o[10]?io_pad_temp[10]:1'bz;
	assign io_pad[11] = ~oen_padoe_o[11]?io_pad_temp[11]:1'bz;
	assign io_pad[12] = ~oen_padoe_o[12]?io_pad_temp[12]:1'bz;
	assign io_pad[13] = ~oen_padoe_o[13]?io_pad_temp[13]:1'bz;
	assign io_pad[14] = ~oen_padoe_o[14]?io_pad_temp[14]:1'bz;
	assign io_pad[15] = ~oen_padoe_o[15]?io_pad_temp[15]:1'bz;
	assign io_pad[16] = ~oen_padoe_o[16]?io_pad_temp[16]:1'bz;
	assign io_pad[17] = ~oen_padoe_o[17]?io_pad_temp[17]:1'bz;
	assign io_pad[18] = ~oen_padoe_o[18]?io_pad_temp[18]:1'bz;
	assign io_pad[19] = ~oen_padoe_o[19]?io_pad_temp[19]:1'bz;
	assign io_pad[20] = ~oen_padoe_o[20]?io_pad_temp[20]:1'bz;
	assign io_pad[21] = ~oen_padoe_o[21]?io_pad_temp[21]:1'bz;
	assign io_pad[22] = ~oen_padoe_o[22]?io_pad_temp[22]:1'bz;
	assign io_pad[23] = ~oen_padoe_o[23]?io_pad_temp[23]:1'bz;
	assign io_pad[24] = ~oen_padoe_o[24]?io_pad_temp[24]:1'bz;
	assign io_pad[25] = ~oen_padoe_o[25]?io_pad_temp[25]:1'bz;
	assign io_pad[26] = ~oen_padoe_o[26]?io_pad_temp[26]:1'bz;
	assign io_pad[27] = ~oen_padoe_o[27]?io_pad_temp[27]:1'bz;
	assign io_pad[28] = ~oen_padoe_o[28]?io_pad_temp[28]:1'bz;
	assign io_pad[29] = ~oen_padoe_o[29]?io_pad_temp[29]:1'bz;
	assign io_pad[30] = ~oen_padoe_o[30]?io_pad_temp[30]:1'bz;
	assign io_pad[31] = ~oen_padoe_o[31]?io_pad_temp[31]:1'bz;
	
	
	
	




endmodule
