interface io_if(input bit clock);
	//cannot use logic here either input or output but not both check notes
	wire[31:0] io_pad;

	clocking io_drv_cb @ (posedge clock);
    default input #1 output #1;
	output io_pad;
	endclocking	
	
	clocking io_mon_cb @ (negedge clock);
    default input #1 output #1;
	input io_pad;
	endclocking	
	
	modport IO_DRV_MP (clocking io_drv_cb);
	modport IO_MON_MP (clocking io_mon_cb);
endinterface
