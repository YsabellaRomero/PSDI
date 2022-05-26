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

reg [0:63]  regs_bank [3:0];                    // 16 registers with a 64 bits dimension
wire [0:63]  regs_const [8:0];                  // 9 sets of predefined constants

reg aux;

//Predefined constant sets
assign regs_const[0] = {32'b01, 32'b01};        // 1  + j
assign regs_const[1] = {32'b00, 32'b01};        // 0  + j
assign regs_const[2] = {32'b11, 32'b01};        // -1 + j
assign regs_const[3] = {32'b01, 32'b00};        // 1  + 0j
assign regs_const[4] = {32'b00, 32'b00};        // 0  + 0j
assign regs_const[5] = {32'b11, 32'b00};        // -1 + 0j
assign regs_const[6] = {32'b01, 32'b11};        // 1  - j
assign regs_const[7] = {32'b00, 32'b11};        // 0  - j
assign regs_const[8] = {32'b11, 32'b11};        // -1 - j


//------------------------------------------------------
//
always@(posedge clock)
if ( reset )
begin
    Real <= 32'b0;
    Im <= 32'b0;
    regs_bank[selwreg] <= 32'b0;
    outA <= 64'b0;
    outB <= 64'b0;
end

else
begin
    //---------------------------------------------------
    // WRITE PART
    if( regwen )

    begin

        Real <= inA[63:32];                       // Real part of register selwreg[i]
        Im <= inA[31:0];                          // Imaginary part of register selwreg[i]
	    case ( endwreg )
            2'b00: begin                                    // Write on both data fields
                regs_bank[selwreg] <= {Real, Im};
                //$display("lala = %d", regs_bank[selwreg]);
            end

            2'b10: begin                                    // Write on real part
                regs_bank[selwreg] <= {Real, 32'b0};
            end

            2'b01: begin                                    // Write on imaginary part
                regs_bank[selwreg] <= {32'b0, Im};
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
        if( enrregA )
        begin
            if( cnstA ) 
            begin                                
                if( seloutA > 8)
                begin
                    aux <= seloutA - 9;
                    outA <= regs_const[aux];                // Load the output port A with the predefined constant
                end
            end
            else
                outA <= regs_bank[seloutA];                 // Load output port A with data from register
        end

        if( enrregB )
        begin
            if( cnstB )
            begin
                if( seloutB > 8)                  
                begin
                    aux <= seloutB - 9;
                    outB <= regs_const[aux];                // Load the output port B with the predefined constant
                end
            end
            else
                outB <= regs_bank[seloutB];                 // Load output port B with data from register
        end
    end
end



endmodule