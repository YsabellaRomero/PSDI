`timescale 1ns / 1ns

module testbench;

reg  clock, reset;
reg [31:0]      regA,
                regB;

wire [ 3:0]     opr; 

reg_bank reg_bank_1(  
            .clock( clock ), 
            .reset( reset ), 
            .regwe( regwe ),
            .inA( inA ),
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

//assign regA = outA;

ALU_op ALU_op_1(
                    .clock(clock),
                    .reset(clock),
                    .regA(regA),
                    .regB(regB),
                    .opr(opr),
                    .regdest(regdest)
 );

endmodule
