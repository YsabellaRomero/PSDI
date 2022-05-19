module reg_bank(
                    input clock,                // Master clock, active in the posedge
                    input reset,                // Master reset, synchronous and active high
                    //--- Data input port ----------------------------------------------------
                    input regwen,               // Register write enable: set to 1 to write the register
                                                // selected by selwreg with the data at port inA
                    input [63:0] inA,           // Data input
                    input [ 3:0] selwreg,       // Select register index [0 to 15] to write data from port inA
                    input [ 1:0] endwreg,       // Data enable: 00-write both data fields
                                                // 10/01-write only data field selected by 1’b0
                                                // 11: swap high word and low word
                    //--- Data output ports --------------------------------------------------
                    output reg [63:0] outA,     // Data output A, registered
                    output reg [63:0] outB,     // Data output B, registered
                    input [ 3:0] seloutA,       // Select register index [0 to 15] to output port outA
                    input [ 3:0] seloutB,       // Select register index [0 to 15] to output port outB
                    input cnstA,                // Define whether the output ports A and B are loaded with
                    input cnstB,                // the contents of the register bank or a fixed constant
                    input enrregA,              // Read enable to output register outA (loads output register)
                    input enrregB               // Read enable to output register outB (loads output register)
 );


// Additional registers
reg [31:0]  Real,
            Im;

reg [31:0]  real_pos,                           // Read-only registers
            real_zero,
            real_neg,
            im_pos,
            im_zero,
            im_neg;

reg [0:63]  regs_bank [3:0];                    // 16 registers with a 64 bits dimension


assign Real = inA[63:32];                       // Real part of register selwreg[i]
assign Im = inA[31:0];                          // Imaginary part of register selwreg[i]

assign real_pos  = 32'b01;                      // 1
assign real_zero = 32'b00;                      // 0
assign real_neg  = 32'b11;                      // -1
assign im_pos    = 32'b01;                      // j
assign im_zero   = 32'b00;                      // 0j
assign im_neg    = 32'b11;                      // -j


//------------------------------------------------------
//
always@(posedge clock)
if ( reset )
begin
    Real <= 32'b0;
    Im <= 32'b0;
    regs_bank <= 0;
end

else
begin
    //---------------------------------------------------
    // WRITE PART
    if( regwen )

    begin
	    case ( endwreg )
            2'b00: begin                                    // Write on both data fields
                regs_bank[selwreg] <= {Real, Im};
            end

            2'b10: begin                                    // Write on real part
                regs_bank[selwreg] <= {Real, 32'b0};
            end

            2'b01: begin                                    // Write on imaginary part
                regs_bank[selwreg] <= {32'B0, Im};
            end

            2'b11: begin                                    // Swap high word and low word
                regs_bank[selwreg] <= {Im, Real};
            end
        endcase
    end

    //---------------------------------------------------
    // READ PART
    else
    begin
        if(cnstA & cnstB)                       // Load the output ports with the predefined constants
        begin                                   // Read register address specifies the constant to load into the output ports
        end

        else                                    // Load output ports with data from registers
        begin
            if( enrregA )
                outA <= regs_bank[seloutA];
            
            if( enrregB )
                outB <= regs_bank[seloutB];
        end
    end
end



endmodule