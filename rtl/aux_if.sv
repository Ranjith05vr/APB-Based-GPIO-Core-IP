interface aux_if(input bit clock);
	logic [31:0] aux_in;

	clocking aux_drv_cb @ (posedge clock);
    default input #1 output #1;
	output aux_in;
	endclocking	
	
	clocking aux_mon_cb @ (negedge clock);
    default input #1 output #1;
	input aux_in;
	endclocking	
	
	modport AUX_DRV_MP (clocking aux_drv_cb);
	modport AUX_MON_MP (clocking aux_mon_cb);
endinterface
