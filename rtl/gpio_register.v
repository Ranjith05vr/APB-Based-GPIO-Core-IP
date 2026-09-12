`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:39:32 05/26/2026 
// Design Name: 
// Module Name:    gpio_register 
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


// gpio register module
	`define GPIO_RGPIO_IN  			32'h00  //Address 0x00 
	`define GPIO_RGPIO_OUT 			32'h04  //Address 0x04
	`define GPIO_RGPIO_OE  			32'h08  //Address 0x08
	`define GPIO_RGPIO_INTE 			32'h0c  //Address 0x0c
	`define GPIO_RGPIO_PTRIG 		32'h10  //Address 0x10
	`define GPIO_RGPIO_AUX 			32'h14  //Address 0x14
	`define GPIO_RGPIO_CTRL 			32'h18  //Address 0x18
	`define GPIO_RGPIO_INTS 			32'h1c  //Address 0x1c
	`define GPIO_RGPIO_ECLK 			32'h20  //Address 0x20
	`define GPIO_RGPIO_NEC 			32'h24  //Address 0x24
	`define GPIO_RGPIO_CTRL_INTE 	0
	`define GPIO_RGPIO_CTRL_INTS 	1
	

module gpio_register( sys_clk , sys_rst ,gpio_adr , gpio_we , gpio_dat_i , gpio_dat_o,
							gpio_inta_o , in_pad_i , out_pad_o , oen_padoe_o , gpio_eclk , aux_i);

   input sys_clk , sys_rst , gpio_we;
	input [31:0] gpio_adr;
	input [31:0] gpio_dat_i;
	output reg[31:0] gpio_dat_o;
	output gpio_inta_o;
	input [31:0] aux_i;  // auxillary input
	input [31:0] in_pad_i; // GPIO inputs
	input gpio_eclk;     // GPIO Eclk
	output [31:0] out_pad_o;  // GPIO output
	output [31:0] oen_padoe_o; // Gpio output drivers enable
	
	
	reg [31:0] rgpio_in;  // Registers
	reg [31:0] rgpio_out;	
	reg [31:0] rgpio_oe;	
	reg [31:0] rgpio_inte;
	reg [31:0] rgpio_ptrig;
	reg [31:0] rgpio_aux;
	reg [1:0]  rgpio_ctrl;
	reg [31:0] rgpio_ints;
	reg [31:0] rgpio_eclk;

	// GPIO Active Neg edge resgister
	reg [31:0] rgpio_nec;  // register
	reg [31:0] dat_reg;
	

	wire [31:0] extc_in;   // muxed input sampled by external clk
	reg  [31:0] pextc_sampled; // posedge external clock sampled inputs
	reg  [31:0] nextc_sampled; // negedge external clock sampled inputs


	// Write to RGPIO_CTRL or update of RGPIO_CTRL[INT] bit
	always @(posedge sys_clk or posedge sys_rst)
		if (sys_rst)
			rgpio_ctrl <= 2'b0;
		else if ((gpio_adr == `GPIO_RGPIO_CTRL) && gpio_we)
			rgpio_ctrl <= gpio_dat_i[1:0];
		else if (rgpio_ctrl[`GPIO_RGPIO_CTRL_INTE])
			rgpio_ctrl[`GPIO_RGPIO_CTRL_INTS] <= rgpio_ctrl[`GPIO_RGPIO_CTRL_INTS] | gpio_inta_o;
	
	// Write to RGPIO_OUT
	always @(posedge sys_clk or posedge sys_rst)
		if (sys_rst)
			rgpio_out <= 32'b0;
		else if ((gpio_adr == `GPIO_RGPIO_OUT) && gpio_we)
			rgpio_out <= gpio_dat_i[31:0];
		else
			rgpio_out <= rgpio_out;

	// Write to RGPIO_OE
	always @(posedge sys_clk or posedge sys_rst)
		if (sys_rst)
			rgpio_oe <= 32'b0;
		else if ((gpio_adr == `GPIO_RGPIO_OE) && gpio_we)
			rgpio_oe <= gpio_dat_i[31:0];

	// Write to RGPIO_INTE
	always @(posedge sys_clk or posedge sys_rst)
		if (sys_rst)
			rgpio_inte <= 32'b0;
		else if ((gpio_adr == `GPIO_RGPIO_INTE) && gpio_we)
			rgpio_inte <= gpio_dat_i[31:0];		

	// Write to RGPIO_PTRIG
	always @(posedge sys_clk or posedge sys_rst)
		if (sys_rst)
			rgpio_ptrig <= 32'b0;
		else if ((gpio_adr == `GPIO_RGPIO_PTRIG) && gpio_we)
			rgpio_ptrig <= gpio_dat_i[31:0];	


	// Write to RGPIO_AUX
	always @(posedge sys_clk or posedge sys_rst)
		if (sys_rst)
			rgpio_aux <= 32'b0;
		else if ((gpio_adr == `GPIO_RGPIO_AUX) && gpio_we)
			rgpio_aux <= gpio_dat_i[31:0];	
			

	// Write to RGPIO_ECLK
	always @(posedge sys_clk or posedge sys_rst)
		if (sys_rst)
			rgpio_eclk <= 32'b0;
		else if ((gpio_adr == `GPIO_RGPIO_ECLK) && gpio_we)
			rgpio_eclk <= gpio_dat_i[31:0];		


	// Write to RGPIO_NEC
	always @(posedge sys_clk or posedge sys_rst)
		if (sys_rst)
			rgpio_nec<= 32'b0;
		else if ((gpio_adr == `GPIO_RGPIO_NEC) && gpio_we)
			rgpio_nec  <= gpio_dat_i[31:0];	
			
	//latch into RGPIO_IN
		wire [31:0]in_muxed;
		
	always @(posedge sys_clk or posedge sys_rst)
		if (sys_rst)
			rgpio_in<= 32'b0;
		else
			rgpio_in <= in_muxed;
	

	assign in_muxed =(rgpio_eclk & extc_in) | (~rgpio_eclk & in_pad_i);
	
	assign extc_in = (~rgpio_nec & pextc_sampled) | (rgpio_nec & nextc_sampled) ;
	
	//posedge external clk samplked units
	always @(posedge gpio_eclk or posedge sys_rst)
		if (sys_rst)
				pextc_sampled <=32'b0;
		else
				pextc_sampled <=in_pad_i;





	//negedge external clk samplked units
	always @(negedge gpio_eclk or posedge sys_rst)
		if (sys_rst)
				nextc_sampled <=32'b0;
		else
				nextc_sampled <=in_pad_i;





	always @(*)
		case (gpio_adr)
			`GPIO_RGPIO_IN:begin
					dat_reg = rgpio_in;
								end
			`GPIO_RGPIO_OUT:begin
					dat_reg = rgpio_out;
								end	
			`GPIO_RGPIO_OE:begin
					dat_reg = rgpio_oe;
								end	
			`GPIO_RGPIO_INTE:begin
					dat_reg = rgpio_inte;
								end								
			`GPIO_RGPIO_PTRIG:begin
					dat_reg = rgpio_ptrig;
								end	
			`GPIO_RGPIO_NEC:begin
					dat_reg = rgpio_nec;
								end	
			`GPIO_RGPIO_ECLK:begin
					dat_reg = rgpio_eclk;
								end	
			`GPIO_RGPIO_AUX:begin
					dat_reg = rgpio_aux;
								end	
			`GPIO_RGPIO_CTRL:begin
					dat_reg[1:0] = rgpio_ctrl;
					dat_reg[31:2] = 30'b0;
								end			
			`GPIO_RGPIO_INTS:begin
					dat_reg = rgpio_ints;
								end			
			default:begin
					dat_reg = rgpio_in;
								end		
			endcase
			
	// Data output
	always @(posedge sys_clk or posedge sys_rst)
		if (sys_rst)
			gpio_dat_o <= 32'b0;
		else	
			gpio_dat_o <= dat_reg;
	
	
	// RGPIO_INTS write and read register
	
	always @(posedge sys_clk or posedge sys_rst)
		if(sys_rst)
			rgpio_ints <= 32'b0;
		else if ((gpio_adr == `GPIO_RGPIO_INTS) && gpio_we)
			rgpio_ints <= gpio_dat_i;
		else if (rgpio_ctrl[`GPIO_RGPIO_CTRL_INTE])
			rgpio_ints <= (rgpio_ints | ((in_muxed^rgpio_in)& ~(in_muxed^rgpio_ptrig)) & rgpio_inte);
	
	// Generate interrupt request
	assign gpio_inta_o = |rgpio_ints ? rgpio_ctrl[`GPIO_RGPIO_CTRL_INTE] : 1'b0;
	// output enables as RGPIO_OE bits
	assign oen_padoe_o = rgpio_oe;
	// generate GPIO outputs
	assign out_pad_o = (rgpio_out & ~rgpio_aux) | (aux_i & rgpio_aux);
	
	

	
endmodule
