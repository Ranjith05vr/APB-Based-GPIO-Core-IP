interface apb_if(input bit clock);
	logic PSEL;
	logic PENABLE;
	logic PWRITE;
	logic PRESET;
    logic [31:0] PWDATA;
    logic [31:0] PADDR;
	logic [31:0] PRDATA;
    logic IRQ;
	logic PREADY;


	
	clocking apb_drv_cb @ (posedge clock);
    default input #1 output #1;
	output PSEL;
	output PENABLE;
	output PWRITE;
	output PRESET;
    output PWDATA;
    output PADDR;
	input PRDATA;
    input IRQ;
	input PREADY;
	endclocking	
	
	clocking apb_mon_cb @ (negedge clock);
    default input #1 output #1;
	input PSEL;
	input PENABLE;
	input PWRITE;
	input PRESET;
    input PWDATA;
    input PADDR;
	input PRDATA;
    input IRQ;
	input PREADY;
	endclocking	
	
	modport APB_DRV_MP (clocking apb_drv_cb);
	modport APB_MON_MP (clocking apb_mon_cb);
endinterface
