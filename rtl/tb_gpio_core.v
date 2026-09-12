`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:19:47 06/12/2026 
// Design Name: 
// Module Name:    tb_gpio_core 
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


`include "gpio_defines.v"



module gpio_core_tb();

    reg PCLK,PRESET;
    wire [31:0] PRDATA;
    reg [31:0] PADDR,PWDATA;
    reg PSEL,PENABLE,PWRITE;
    reg [31:0] aux_in;
    wire IRQ,PREADY;
    wire [31:0] io_pad;
    reg ext_clk_pad_i;

    //DUT instantiation
    gpio_core DUT(PCLK,PRESET,PRDATA, PADDR,PWDATA, PSEL,PENABLE,PWRITE,aux_in, IRQ,PREADY,io_pad, ext_clk_pad_i);

    //Generation of PCLK
    initial
        PCLK=1'b0;
    always #5 PCLK=~PCLK;


    initial
        ext_clk_pad_i=1'b0;
    always #10 ext_clk_pad_i=~ext_clk_pad_i;
	 
	 task reset;
	 begin
		@(negedge PCLK)
		PRESET=1'b1;
		#10;
		PRESET=1'b0;
	end
	endtask
	
	task aux_write(input[31:0]in);
		begin
			@(negedge PCLK)
			aux_in=in;
		end
		endtask


	task initialize;
	begin
		@(negedge PCLK)
		PADDR=32'h0;
		PSEL=1'b0;
		PWRITE=1'b0;
		PENABLE=1'b0;
		PWDATA=32'h0;
		aux_in=32'h0;
	end
	endtask
	
	task apb_write(input[31:0]addr, input[31:0]in);
	begin
		@(negedge PCLK)
		PADDR=addr;
		PSEL=1'b1;
		PWRITE=1'b1;
		PENABLE=1'b0;
		PWDATA=in;
		@(negedge PCLK)
		PADDR=addr;
		PSEL=1'b1;
		PWRITE=1'b1;
		PENABLE=1'b1;
		PWDATA=in;	
		@(negedge PCLK)
		PADDR=addr;
		PSEL=1'b1;
		PWRITE=1'b1;
		PENABLE=1'b0;
		PWDATA=in;			
		@(negedge PCLK)
		PADDR=addr;
		PSEL=1'b0;
		PWRITE=1'b0;
		PENABLE=1'b0;
		PWDATA=PWDATA;		
	end
	endtask
	
	
	task apb_read(input[31:0]addr);
	begin
		@(negedge PCLK)
		PADDR=addr;
		PSEL=1'b1;
		PWRITE=1'b0;
		PENABLE=1'b0;
		@(negedge PCLK)
		PADDR=addr;
		PSEL=1'b1;
		PWRITE=1'b0;
		PENABLE=1'b1;
		@(negedge PCLK)
		PADDR=addr;
		PSEL=1'b1;
		PWRITE=1'b0;
		PENABLE=1'b0;		
		@(negedge PCLK)
		PADDR=addr;
		PSEL=1'b0;
		PWRITE=1'b0;
		PENABLE=1'b0;	
	end
	endtask
	
	
	reg io_dir = 1'b1;
	reg [31:0] temp =32'bz;
	
	task io_pad_input(input [31:0]in_temp);
		begin
			io_dir=1'b0;
			temp = in_temp;
			end
		endtask
	
	task io_pad_output;
		begin
			io_dir=1'b1;
			end
		endtask
		
	
	assign io_pad=~io_dir?temp:32'bz;
	
	initial
		begin
/*			$monitor(
"T=%0t STATE=%0d PSEL=%b PENABLE=%b PWRITE=%b gpio_we=%b",
$time,
DUT.APB_INTERFACE.STATE,
PSEL,
PENABLE,
PWRITE,
DUT.gpio_we
);*/
			//io_pad_input(32'h56784321);
			reset;
			#10;
			initialize;
			
			
			// output
			apb_write(`GPIO_RGPIO_INTE , 32'h0);
			apb_write(`GPIO_RGPIO_OUT , 32'h56781234);
			apb_write(`GPIO_RGPIO_OE , 32'hffffffff);
			io_pad_output;

			// Polled input
			apb_write(`GPIO_RGPIO_OE , 32'h0);
			apb_write(`GPIO_RGPIO_CTRL , 2'b0);
			apb_write(`GPIO_RGPIO_INTE , 32'b0);
			apb_write(`GPIO_RGPIO_ECLK , 32'h0);
			io_pad_input(32'h12345678);
			apb_read(`GPIO_RGPIO_IN);
	
			// aux in
			aux_write(32'hf7f6f504);
			apb_write(`GPIO_RGPIO_AUX , 32'hffffffff);
			apb_write(`GPIO_RGPIO_OE , 32'hffffffff);			
			io_pad_output;
			apb_write(`GPIO_RGPIO_AUX , 32'h0);
			
			// Bidirectional IO sys clk
			apb_write(`GPIO_RGPIO_INTE , 32'h0);
			apb_write(`GPIO_RGPIO_ECLK , 32'h0);
			apb_write(`GPIO_RGPIO_OUT , 32'h10203040);
			apb_write(`GPIO_RGPIO_OE , 32'hf0f0f0f0);	
			io_pad_input(32'hz5z1z0z9);
			apb_read(`GPIO_RGPIO_IN);			


			// GPIO as Input in Interupt mode sys clk
			io_pad_input(32'h0000ffff);
			apb_write(`GPIO_RGPIO_OE , 32'h0);
			apb_write(`GPIO_RGPIO_CTRL , 2'b01);
			apb_write(`GPIO_RGPIO_INTE , 32'hffffffff);
			apb_write(`GPIO_RGPIO_PTRIG , 32'hffff0000);	
			apb_write(`GPIO_RGPIO_INTS , 32'h0);				
			apb_write(`GPIO_RGPIO_ECLK , 32'h0);
			io_pad_input(32'h87654321);			
			apb_read(`GPIO_RGPIO_INTS);
			wait(IRQ)
			apb_read(`GPIO_RGPIO_IN);			
			apb_write(`GPIO_RGPIO_INTS, 32'h0);
			
			//GPIO as polled input eclk
			apb_write(`GPIO_RGPIO_OE , 32'h0);
			apb_write(`GPIO_RGPIO_CTRL , 2'b00);
			apb_write(`GPIO_RGPIO_INTE , 32'b0);
			apb_write(`GPIO_RGPIO_NEC , 32'h0000f0f0);
			apb_write(`GPIO_RGPIO_ECLK , 32'h0000ffff);	
			io_pad_input(32'h12345678);
			apb_read(`GPIO_RGPIO_IN);



			// GPIO as Input in Interupt mode ext clk
			apb_write(`GPIO_RGPIO_OE , 32'h0);
			apb_write(`GPIO_RGPIO_INTE , 32'hffffffff);
			apb_write(`GPIO_RGPIO_PTRIG , 32'hffff0000);
			apb_write(`GPIO_RGPIO_INTS , 32'h0);
			apb_write(`GPIO_RGPIO_CTRL , 2'b01);		
			apb_write(`GPIO_RGPIO_NEC , 32'h0000f0f0);			
			apb_write(`GPIO_RGPIO_ECLK , 32'h0000ffff);	
			io_pad_input(32'h87654321);			
			apb_read(`GPIO_RGPIO_INTS);
			wait(IRQ)
			apb_read(`GPIO_RGPIO_IN);			
			apb_write(`GPIO_RGPIO_INTS, 32'h0);
			apb_write(`GPIO_RGPIO_CTRL , 2'b00);		
			io_pad_output;


			//GPIO as BIdirectional IO input eclk
			apb_write(`GPIO_RGPIO_INTE , 32'h0);
			apb_write(`GPIO_RGPIO_OUT , 32'h10203040);
			apb_write(`GPIO_RGPIO_OE , 32'hf0f0f0f0);
			apb_write(`GPIO_RGPIO_NEC , 32'h0f0ff0f0);
			apb_write(`GPIO_RGPIO_ECLK , 32'h0f0f0f0f);	
			io_pad_output;
			io_pad_input(32'hz4z5z6z7);
			apb_read(`GPIO_RGPIO_IN);		

			$finish;
		end

		
endmodule
