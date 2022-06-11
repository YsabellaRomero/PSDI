`timescale 1ns / 1ps

module testbench_final;

initial
begin
  $dumpfile("mysimdata_final.vcd");// The filename with the waveform data
  $dumpvars(0, testbench_final ); // The root node to dump end
end

// General parameters 
parameter CLOCK_PERIOD = 10;              // Clock period in ns
parameter MAX_SIM_TIME = 100_000_000;     // Set the maximum simulation time (time units=ns)

reg clock, reset, start, regwen;
reg cnstA, cnstB, enrregA, enrregB;

reg [63:0]  in;
reg [ 3:0]  selwreg;
reg [ 1:0]  endwreg;

reg [ 3:0]  seloutA,
            seloutB,
            opr;

wire [63:0] outA,
            outB;

reg [63:0] in_aux;

wire done;

reg [ 3:0] i;

wire [63:0] result, 
            out_ram;

reg [ 5:0] maxclock;

wire [79:0] variable_aux;

reg_bank reg_bank_1(  
                    .clock( clock ), 
                    .reset( reset ), 
                    .regwen( regwen ),
                    .inA( in ),
                    .selwreg( selwreg ),
                    .endwreg( endwreg ),
                    .outA( outA ),
                    .outB( outB ),
                    .seloutA( seloutA ),
                    .seloutB( seloutB ), 
                    .cnstA( cnstA ),
                    .cnstB( cnstB ), 
                    .enrregA( enrregA ),
                    .enrregB( enrregB )

);


ALUX ALUX_1(
                    .clock( clock ),              
                    .reset( reset ),             
                    .inA( outA ),            
                    .inB( outB ),                  
                    .opr( opr ),                   
                    .start( start ),          
                    .outAB( result ),                    
                    .done( done )
 );


controller controller_1(
                    .clock( clock ), 				
				    .reset( reset ),
				    .maxclock( maxclock ),
				    .opr( opr ),
				    .done( done ),
                    .start( start ),
				    .out_alux( result ),
				    .out( out_ram )
);

variables variables_1(
                    .i( i ),
                    .word( variable_aux )
);

//---------------------------------------------------
// Setup initial signals
initial
begin
  clock = 1'b0;
  reset = 1'b0;
  start = 1'b0;
  in_aux = 64'b0;
  regwen = 1'b0;
  cnstA = 1'b0;
  cnstB = 1'b0;
  enrregA = 1'b0;
  enrregB = 1'b0;
  opr = 4'b0000;          
  maxclock = 6'b0;
end

//---------------------------------------------------
// Generate a 50% duty-cycle clock signal
initial
begin  
    forever
        # (CLOCK_PERIOD / 2 ) clock = ~clock;
end

// Apply reset:
initial
begin
	#10
	reset = 0; 
end

//----------------------------------------------------
// Test the inputs and outputs of the register bank
integer j;
reg [ 3:0] i_aux;
initial
begin

    for (j=0; j<16; j=j+1)
    begin
        #10

        i_aux = j;
        i = j;
        execbr(variable_aux, i_aux);

        #40

        $display("Initial: %h, Expected: %h, Obtained: %h", in, result, out_ram);

        in = result;
    end
    $stop;

end

task execbr;
input [79:0] variable_aux;
input [ 3:0] i_aux;
begin
  in = variable_aux[79:16];         // Apply operands
  opr = variable_aux[15:12];
  maxclock = variable_aux[11:6];
  endwreg = variable_aux[5:4];
  enrregA = variable_aux[3];
  enrregB = variable_aux[2];  
  cnstA = variable_aux[1];
  cnstB = variable_aux[0];

  @(posedge clock);
  regwen = 1'b1;
  selwreg = i_aux;
  start = 1'b1;
  #10
  @(negedge clock);
  regwen = 1'b0;   
  seloutA = i_aux;
  seloutB = i_aux;             
end  
endtask

endmodule



