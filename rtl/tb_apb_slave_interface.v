`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:02:26 05/28/2026 
// Design Name: 
// Module Name:    tb_apb_slave_interface 
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
module tb_apb_slave_interface;

reg [31:0] PADDR , PWDATA;
reg PCLK , PSEL , PENABLE , PWRITE , PRESET;
wire [31:0]PRDATA ;
wire PREADY;
reg gpio_inta_o;
wire IRQ , gpio_we;
wire [31:0] gpio_addr;
wire [31:0] gpio_dat_i;
reg [31:0]gpio_dat_o;
wire sys_clk;
wire sys_rst;
integer i;
apb_slave_interface dut( PADDR , PWDATA, PCLK , PSEL , PENABLE , PWRITE , PRESET,
								PRDATA , 
								 PREADY,
								 gpio_inta_o,
								 IRQ ,  gpio_we,
								 gpio_addr,
								gpio_dat_i,
								gpio_dat_o,
								 sys_clk,
								 sys_rst);


initial begin
PCLK=1'b0;
forever #10 PCLK=~PCLK;
end

initial begin
PADDR  = 32'b0; 
PWDATA = 32'b0;
{PCLK , PSEL , PENABLE , PWRITE , PRESET , gpio_inta_o , gpio_dat_o}= 38'b0;
end

task addr_change;
PADDR ={$random};
endtask

task transfer_enable;
	begin
	PSEL=1'b1;
	#20 PENABLE=1'b1;
	end
endtask

task transfer_disable;
	begin
	PSEL=1'b0;
	#20 PENABLE=1'b0;
	end
endtask


task read_data;
begin
PWRITE =1'b0;
gpio_dat_o={$random};
end
endtask

task write_data;
begin
PWRITE =1'b1;
PWDATA={$random};
end
endtask



initial begin
PRESET =1'b1;
#5
PRESET =1'b0;
for (i=0;i<5;i=i+1)
begin
addr_change;
#10;
end

transfer_enable;

read_data;

#50 transfer_disable;
addr_change;

#50 transfer_enable;

write_data;

#50 transfer_disable;
addr_change;


#50 transfer_enable;

read_data;

#50 transfer_disable;
addr_change;


#50 transfer_enable;

write_data;

#50 transfer_disable;
addr_change;



#10 gpio_inta_o=1'b1;
#15  gpio_inta_o=1'b0;
#30 $finish;
end




endmodule
