`timescale 1ns / 1ps

module txtrigger_ctrl_tb;

	// Inputs
	reg clock;
	reg reset;
	reg txtrigger;
	reg busy;
	reg [9:0] CKINI;
	reg [9:0] CKPER;
	reg [4:0] NPER;

	// Outputs
	wire signed [31:0] mod;
	wire signed [31:0] angle;

	// Instantiate the Unit Under Test (UUT)
	txtrigger_ctrl uut (
		.clock(clock), 
		.reset(reset), 
		.CKINI(CKINI), 
		.CKPER(CKPER), 
		.NPER(NPER),
		.txtrigger(txtrigger),
		.busy(busy)
	);

	// Parameters:	
	parameter CLOCK_FREQ   =  100_000_000; // master clock frequency (Hz)
	parameter CLOCK_PERIOD =  1_000_000_000 / 100_000_000; // clock period (ns)

	// Initialize inputs:
	initial begin
		clock = 0;
		reset = 0;
		CKINI = 0;
		CKPER = 0;
		NPER = 0;
		txtrigger = 0;
		busy = 0;
	end
	
	// Generate the clock (10 ns period, frequency = 100 MHz)
	initial
	begin
	  #11
	  forever #5 clock = ~clock;
	end
	
	// Apply reset:
	initial
	begin
	  #101 
	  reset = 1;
	  #20
	  reset = 0;
	end

	
	// Main verification program:
	initial
	begin
	  #10
	  // Wait for releasing the reset:
	  @(negedge reset);
	  // Wait 10 clock cycles
	  //	This is not required but helps analysing the signals in the
      //    waveform window.
	  
	  repeat (10)
	  	@(negedge clock);
	  
	  // Call the task to start a conversion:
	  execcordic( 123, 456 );
	 
	  $stop;
	  
	end
	

	//--------------------------------------------------------------------
	// Execute a CORDIC: 
	//   apply inputs, set enable to 1, raise start for 1 clock cycle, wait 32 clock cyles
	// set variable "printresults" to 1 to enable printing the results during simulation
	task execcordic;
	input signed [15:0] X;
	input signed [15:0] Y;
	begin
	   x0 = {X,16'd0};
	   y0 = {Y,16'd0};
	   
	   start = 1;
	   enable = 1;
	   @(negedge clock);
	   start = 0;
	   
	   repeat( 32 )
	   	@(negedge clock);
	   
	   enable = 0;
	   
	   // Wait some clocks to separate the calls to the task
	   repeat( 10 )
	   	@(negedge clock);
	   
	   if ( printresults )
	   begin  
	   	// Calculate the expected results:
	   	  Xr = X;
	   	  Yr = Y;
	   	  real_mod = $sqrt( Xr*Xr+Yr*Yr);
	   	  real_atan = $atan2(Yr,Xr) * 180 / PI;
	   	  err_mod = 100 * ( real_mod - (mod / fracfactor) ) / (mod / fracfactor);
	   	  err_atan = 100 * ( real_atan - (angle / fracfactorangle) ) / (angle / fracfactorangle);
	      
	   	  $display("Xi=%d, Yi = %d, Mod=%f  Angle=%f drg Exptd: M=%f, A=%f drg (ERRORs = %f%% %f%%)",
	   	  		       X, Y, mod / fracfactor, angle / fracfactorangle,
	   	  		       real_mod, real_atan, err_mod, err_atan );	
	    end
	
	end
	endtask


endmodule
// end of module rec2pol_tb
