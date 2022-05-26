`timescale 1ns / 1ps

module testbench;

initial
begin
  $dumpfile("mysimdata.vcd");// The filename with the waveform data
  $dumpvars(0, testbench ); // The root node to dump end
end

// general parameters 
parameter CLOCK_PERIOD = 10;              // Clock period in ns
parameter MAX_SIM_TIME = 100_000_000;     // Set the maximum simulation time (time units=ns)

reg  clock, reset, start, regwen;
reg cnstA, cnstB, enrregA, enrregB;

reg [63:0]  in;
reg [ 3:0]  selwreg;
reg [ 1:0]  endwreg;

reg [ 3:0]  seloutA,
            seloutB;

wire [63:0] outA,
            outB;

//wire [ 3:0] opr; 


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

/*
ALUX ALUX_1(
                    .clock(clock),              
                    .reset(reset),             
                    .inA(outA),            
                    .inB(outB),                  
                    .opr(opr),                   
                    .start(start),          
                    .outAB(result),                    
                    .done(done)
 );
*/



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
end

//---------------------------------------------------
// generate a 50% duty-cycle clock signal
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
//Test the inputs and outputs of the register bank
integer i, in_aux;
initial
begin
    //Declarar valores aleatorios para inA na mesma quantidade de registos
    //Inserir um a um dos endereços de registos com diferentes valores 
    //Verificar se no output os valores de cada um dos registos
    for (i=0; i<16; i=i+1)
    begin
        #10
        endwreg = 2'b00;
        enrregA = 1'b1;
        enrregB = 1'b1;    
        cnstA = 1'b0;
        cnstB = 1'b0;  
        in_aux = i*400;
        execbr(in_aux, i);
        #10
        $display("Expected Value: %d || Obtained: %d", in_aux, outA);
    end
    $stop;

end

task execbr;
input [63:0] inA;
input i;
begin
  in = inA;   // Apply operands
  @(posedge clock);
  regwen = 1'b1;
  selwreg = i;
  seloutA = i;
  seloutB = i;
  #10
  @(negedge clock);
  regwen = 1'b0;                
end  
endtask


endmodule

