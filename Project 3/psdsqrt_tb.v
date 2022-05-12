/* 
PSD 2021-2022

Lab 1 - Design and verification of a sequential square root calculator

	This Verilog code is property of University of Porto
	Its utilization beyond the scope of the course Digital Systems Design
	(Projeto de Sistemas Digitais) of the Master in Electrical 
	and Computer Engineering requires explicit authorization from the author.
	
	jca@fe.up.pt, April 2022
	
*/
`timescale 1ns / 1ns

module psdsqrt_tb;

/* 
initial
begin
  $dumpfile("mysimdata.vcd");// The filename with the waveform data
  $dumpvars(0, ext_controller_1); // The root node to dump end
end
*/

// general parameters 
parameter CLOCK_PERIOD = 10;              // Clock period in ns
parameter MAX_SIM_TIME = 100_000_000;     // Set the maximum simulation time (time units=ns)

//Parameters defined by the user
parameter NBITSIN_tb = 32;                       //alínea 5.1
parameter k_tb = 8;                              //alínea 5.2  


// Registers for driving the inputs:
reg  clock, reset;
//reg  start, stop;
reg  [NBITSIN_tb-1:0] x;

// Wires to connect to the outputs:
wire [(NBITSIN_tb/2)-1:0] sqrt;


//----------------------------------------------------
//alínea 5.3
reg busy, start, stop;
reg run;                        

/*
ext_controller #( .NBITSIN(NBITSIN_tb),
                  .k( k_tb ) 
              ) 

      ext_controller_1    
		  ( 		
          .run(run),
				  .clock(clock), 
				  .reset(reset),
				  .busy(busy),
				  .start(start),
				  .stop(stop)
			);
*/
// Instantiate the module under verification:
psdsqrt #( .NBITSIN( NBITSIN_tb ),              //alínea 5.1
           .k( k_tb )                           //alínea 5.2
        )

      psdsqrt_1
      ( 
	      .clock(clock), // master clock, active in the positive edge
        .reset(reset), // master reset, synchronous and active high
		
        .start(start), // set to 1 during one clock cycle to start a sqrt
        .stop(stop),   // set to 1 during one clock cycle to load the output registers
		
        .xin(x),       // the operands
        .sqrt(sqrt)
      ); 
      
        
//---------------------------------------------------
// Setup initial signals
initial
begin
  clock = 1'b0;
  reset = 1'b0;
  run = 1'b1;
  x = 1'b0;
  //start = 1'b0;
  //stop  = 1'b0;
end

//---------------------------------------------------
// generate a 50% duty-cycle clock signal
initial
begin  
  forever
    # (CLOCK_PERIOD / 2 ) clock = ~clock;
end

//---------------------------------------------------
// Apply the initial reset for 2 clock cycles:
initial
begin
  # (CLOCK_PERIOD/3) // wait a fraction of the clock period to 
                     // misalign the reset pulse with the clock edges:
  reset = 1;
  # (2 * CLOCK_PERIOD ) // apply the reset for 2 clock periods
  reset = 0;
end

//---------------------------------------------------
// Set the maximum simulation time:
initial
begin
  # ( MAX_SIM_TIME )
  $stop;
end

//---------------------------------------------------
// The verification program (THIS IS TRUE A PROGRAM!)
integer i;
initial
begin

  // Wait 10 clock periods
  #( 10*CLOCK_PERIOD );

  execsqrt( 123456 );
  $display("Golden: %d, sqrt = %d",  golden_sqrt( 123456 ), sqrt);  

  execsqrt( 109876 );
  $display("Golden: %d, sqrt = %d",  golden_sqrt( 109876 ), sqrt);  

  execsqrt( 543210 );
  $display("Golden: %d, sqrt = %d",  golden_sqrt( 543210 ), sqrt);  

  execsqrt( 12 );
  $display("Golden: %d, sqrt = %d",  golden_sqrt( 12 ), sqrt);  

  execsqrt( 13 );
  $display("Golden: %d, sqrt = %d",  golden_sqrt( 13 ), sqrt);  

  execsqrt( 1057 );
  $display("Golden: %d, sqrt = %d",  golden_sqrt( 1057 ), sqrt);  

  execsqrt( 4291 );
  $display("Golden: %d, sqrt = %d",  golden_sqrt( 4291 ), sqrt);  
       
  #( 10*CLOCK_PERIOD );
  $stop;  
  //$finish
  
end


//---------------------------------------------------
// Simulate the sequential controller to perform a square root.
task execsqrt;
input [NBITSIN_tb:0] xin;
begin
  x = xin;   // Apply operands

  
  @(negedge clock);
  start = 1'b1;       // Assert start
  @(negedge clock );
  start = 1'b0;  
  repeat ((NBITSIN_tb+k_tb)/2) @(posedge clock);                                 //alterado
  @(negedge clock);
  stop = 1'b1;        // Assert stop
  @(negedge clock);
  stop = 1'b0;
  @(negedge clock);
  /*
  @(posedge clock);
  run = 1'b1;       // Assert start
  @(posedge clock );
  run = 1'b0;
  @(posedge clock );  
  while (busy) @(posedge clock);
  */

end  
endtask



//---------------------------------------------------
// A Verilog function implementing the same SQRT algorithm
// This is the "golden" function whose result should be exact
// bit by bit with the result created by your circuit.
// Note this does not include the rounding process nor
// supports the parameterization for different number of bits
function [15:0] golden_sqrt( input [31:0] xin );
reg   [15:0] mask;
reg   [15:0] temproot;
integer i;
begin
  mask = 16'b1000_0000_0000_0000;
  temproot = 0;
  for (i=0; i<16; i=i+1 )
  begin
    if (  xin >= ( temproot | mask ) * (temproot | mask ) )
      temproot = temproot | mask;
    mask = mask >> 1;
  end
  golden_sqrt = temproot;
end
endfunction

endmodule
			   
