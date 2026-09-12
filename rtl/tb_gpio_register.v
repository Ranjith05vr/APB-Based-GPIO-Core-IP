`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:40:50 05/28/2026 
// Design Name: 
// Module Name:    tb_gpio_register 
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
module tb_gpio_register;

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


   reg sys_clk , sys_rst , gpio_we;
	reg [31:0] gpio_adr;
	reg [31:0] gpio_dat_i;
	wire [31:0] gpio_dat_o;
	wire gpio_inta_o;
	reg [31:0] aux_i;  // auxillary input
	reg [31:0] in_pad_i; // GPIO inputs
	reg gpio_eclk;     // GPIO Eclk
	wire [31:0] out_pad_o;  // GPIO output
	wire [31:0] oen_padoe_o; // Gpio output drivers enable


gpio_register dut( sys_clk , sys_rst , gpio_adr , gpio_we , gpio_dat_i , gpio_dat_o,
							gpio_inta_o , in_pad_i , out_pad_o , oen_padoe_o , gpio_eclk , aux_i);



always #5 sys_clk=~sys_clk;
always #10 gpio_eclk = ~gpio_eclk;


task write_reg;
input [31:0] addr;
input [31:0] data;
begin
    @(negedge sys_clk);
    gpio_adr   = addr;
    gpio_dat_i = data;
    gpio_we    = 1'b1;

    @(posedge sys_clk);

    @(negedge sys_clk);
    gpio_we    = 1'b0;
end
endtask


initial begin
{sys_clk , sys_rst , gpio_we,gpio_eclk} = 4'b0;
gpio_adr=32'b0;
gpio_dat_i =32'b0;
aux_i =32'b0;
in_pad_i =32'b0;

end


initial begin

$monitor(
"T=%0t | gpio_adr=%h | gpio_we=%b | gpio_dat_i=%h | rgpio_out=%h | dat_reg=%h | gpio_dat_o=%h",
 $time,
 gpio_adr,
 gpio_we,
 gpio_dat_i,
 dut.rgpio_out,
 dut.dat_reg,
 gpio_dat_o
);
sys_rst=1'b1;
#10
sys_rst=1'b0;
	
	 in_pad_i=32'h12345678;
	 write_reg(`GPIO_RGPIO_IN, 32'hA5A5A5A5);
	 in_pad_i=32'h00000000;	
	 write_reg(`GPIO_RGPIO_OUT, 32'hB5B5B5B5);


	 gpio_dat_i=0;
	 aux_i=32'h0000BCBC;
	 write_reg(`GPIO_RGPIO_AUX, 32'hFFFFFFFF);
	 

	 write_reg(`GPIO_RGPIO_OE, 32'hC5C5C5C5);

	 write_reg(`GPIO_RGPIO_INTS, 32'h00000001);
    write_reg(`GPIO_RGPIO_INTE, 32'h00000001);
    write_reg(`GPIO_RGPIO_PTRIG, 32'h00000001);
    write_reg(`GPIO_RGPIO_CTRL, 32'h00000001);
	 in_pad_i = 0;
	 #20;
	 in_pad_i = 1;
	 
	 
	 #20;
	 in_pad_i = 32'hAAAAAAAA;
	 write_reg(`GPIO_RGPIO_ECLK , 32'h00000000);
	$display("TIME=%0t in_pad_i=%h in_muxed=%h pextc=%h nextc=%h extc_in=%h",
          $time,
          in_pad_i,
          dut.in_muxed,
          dut.pextc_sampled,
          dut.nextc_sampled,
          dut.extc_in);
			 
	 
	 write_reg(`GPIO_RGPIO_ECLK , 32'hFFFFFFFF);
	 write_reg(`GPIO_RGPIO_NEC  , 32'h00000000);
		in_pad_i = 32'hBBBBBBBB;	
		@(posedge gpio_eclk);
		#1;
	 $display("TIME=%0t in_pad_i=%h in_muxed=%h pextc=%h nextc=%h extc_in=%h",
          $time,
          in_pad_i,
          dut.in_muxed,
          dut.pextc_sampled,
          dut.nextc_sampled,
          dut.extc_in);

	in_pad_i = 32'h87654321;
	@(negedge gpio_eclk);
		#1;
	 $display("TIME=%0t in_pad_i=%h in_muxed=%h pextc=%h nextc=%h extc_in=%h",
          $time,
          in_pad_i,
          dut.in_muxed,
          dut.pextc_sampled,
          dut.nextc_sampled,
          dut.extc_in);

	 write_reg(`GPIO_RGPIO_ECLK , 32'hFFFFFFFF);
	 write_reg(`GPIO_RGPIO_NEC  , 32'hFFFFFFFF);  
	 $display("TIME=%0t in_pad_i=%h in_muxed=%h pextc=%h nextc=%h extc_in=%h",
          $time,
          in_pad_i,
          dut.in_muxed,
          dut.pextc_sampled,
          dut.nextc_sampled,
          dut.extc_in);
			 
			 
	 
	 #50 $finish;
end




endmodule
