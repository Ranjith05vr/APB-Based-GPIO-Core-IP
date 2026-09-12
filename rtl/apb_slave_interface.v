`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:06:03 05/21/2026 
// Design Name: 
// Module Name:    apb_slave_interface 
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



module apb_slave_interface( input [31:0] PADDR , PWDATA, 
								input PCLK , PSEL , PENABLE , PWRITE , PRESET,
								output reg[31:0]PRDATA , 
								output PREADY,
								input gpio_inta_o,
								output IRQ , output reg gpio_we,
								output [31:0] gpio_addr,
								output reg [31:0] gpio_dat_i,
								input [31:0]gpio_dat_o,
								output sys_clk,
								output sys_rst);
	
	parameter IDLE=2'b00,
				SETUP=2'b01,
				ENABLE=2'b10;

	reg[1:0]STATE , NEXT_STATE;
	
	// Operating state of APB
	always@(posedge PCLK or posedge PRESET)
		begin
			if(PRESET)
				STATE <= IDLE;
			else
				STATE <= NEXT_STATE;
		end
		
	always@(*)
		begin
			case(STATE)
				IDLE:begin
						if(PSEL && !PENABLE)
							NEXT_STATE = SETUP;
						else 
							NEXT_STATE = IDLE;
						end
				
				SETUP:begin
						if(PSEL && PENABLE)
							NEXT_STATE = ENABLE;
						else if(PSEL && !PENABLE)
							NEXT_STATE = SETUP;
						else
							NEXT_STATE = IDLE;
						end
						
				ENABLE:begin
						if(PSEL)
							NEXT_STATE = SETUP;
						else
							NEXT_STATE = IDLE;
						end
				
				default: NEXT_STATE = IDLE;
				endcase
			end
	
	assign PREADY=(STATE==ENABLE)||(STATE==IDLE && PRESET)?1'b1:1'b0;
	
	//update the value of gpio_dat_i , prdata and gpio_we as per operating sates of apb
	always@(*)
		begin
			if(PWRITE && STATE==ENABLE)
				begin
					gpio_dat_i=PWDATA;
					gpio_we=1'b1;
					PRDATA=32'b0;
				end
			else if (!PWRITE && STATE==ENABLE)
				begin
					gpio_dat_i=32'b0;
					gpio_we=1'b0;
					PRDATA=gpio_dat_o;
				end
			else
				begin
					gpio_dat_i=32'b0;
					gpio_we=1'b0;
					PRDATA=32'b0;
				end
			end
			
		//we are making sys_clk equal to PCLK similarly sys_rst is equal to rst,\
		// gpio_addr is equal to PADDR and IRO is equal to gpio_inta_o
		assign IRQ=gpio_inta_o;
		assign sys_clk=PCLK;
		assign sys_rst=PRESET;
		assign gpio_addr=PADDR;
	
endmodule
