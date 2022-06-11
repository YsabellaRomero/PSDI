`timescale 1ns / 1ps

module testbench;

initial
begin
  $dumpfile("mysimdata.vcd");// The filename with the waveform data
  $dumpvars(0, testbench ); // The root node to dump end
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

wire done;

wire [63:0] result, 
            out_ram;

reg [ 5:0] maxclock;


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
  opr = 4'b0000;          // 0000 = A; 0001 = B; 0010 = sum; 0011 = sub; ...
  maxclock = 6'b1;
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
integer i;
reg [ 3:0] i_aux;
reg [63:0] in_aux;
initial
begin
    in_aux = 12321978053717715840;

    for (i=0; i<16; i=i+1)
    begin
        #10

        //------------- User edits inputs manually ---------------
        endwreg = 2'b00;
        enrregA = 1'b1;
        enrregB = 1'b1;    
        cnstA = 1'b0;
        cnstB = 1'b0; 
        opr = 4'b1001;            // 0000 = A; 0001 = B; 0010 = sum; 0011 sub; ...
        maxclock = 6'b100110;
        //--------------------------------------------------------

        i_aux = i;
        execbr(in_aux, i_aux);
        #10

        $display("Initial: %h", in_aux);
        $display("Output A stored at the bank of registers: %h", outA);
        $display("Output B stored at the bank of registers: %h", outB);
        $display("Result obtained after ALUX: %h", result);
        $display("Value stored at the data RAM %h", out_ram);

        in_aux = in_aux+'b10000;
        in = result;
    end
    $stop;

end

task execbr;
input [63:0] inA;
input [ 3:0] i;
begin
  in = inA;               // Apply operands
  @(posedge clock);
  regwen = 1'b1;
  selwreg = i;
  start = 1'b1;
  #10
  @(negedge clock);
  regwen = 1'b0;   
  seloutA = i;
  seloutB = i;             
end  
endtask


endmodule



