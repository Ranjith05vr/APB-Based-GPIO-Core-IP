`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:51:22 06/12/2026 
// Design Name: 
// Module Name:    gpio_core 
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
module gpio_core(input PCLK,PRESET,
                  output [31:0] PRDATA,
                  input [31:0] PADDR, PWDATA,
                  input PSEL,PENABLE,PWRITE,
                  input [31:0] aux_in,
                  output IRQ,PREADY,
                  inout [31:0] io_pad,
                  input ext_clk_pad_i);

    wire [31:0] in_pad_i;
    wire gpio_we;
    wire [31:0] gpio_adr;
    wire [31:0] gpio_dat_i;
    wire [31:0] gpio_dat_o;
    wire [31:0] out_pad_o,oen_padoe_o;
    wire gpio_inta_o;
    wire sys_clk,sys_rst;
    wire [31:0] aux_i;

apb_slave_interface APB_INTERFACE( PADDR , PWDATA, PCLK , PSEL , PENABLE , PWRITE , PRESET,
								PRDATA , 
								 PREADY,
								 gpio_inta_o,
								 IRQ ,  gpio_we,
								 gpio_adr,
								gpio_dat_i,
								gpio_dat_o,
								 sys_clk,
								 sys_rst);


aux_interface AUX_INTERFACE(  sys_clk , sys_rst,aux_in ,  aux_i);


gpio_register GPIO_REGISTER( sys_clk , sys_rst , gpio_adr , gpio_we , gpio_dat_i , gpio_dat_o,
							gpio_inta_o , in_pad_i , out_pad_o , oen_padoe_o , gpio_eclk , aux_i);


io_interface IO_INTERFACE( ext_clk_pad_i,
							out_pad_o , oen_padoe_o,
							in_pad_i,
							io_pad,
							 gpio_eclk);
							  
endmodule