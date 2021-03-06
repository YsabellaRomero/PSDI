module ALUX(
                    input clock,                // Master clock, active in the posedge
                    input reset,                // Master reset, synchronous and active high
                    input [63:0] inA,           // Data input A 
                    input [63:0] inB,           // Data input B
                    input [3:0] opr,            // Operation between data input A and data input B
                    input start,
                    //--- Data output ports --------------------------------------------------
                    output reg [63:0] outAB,    // Data output A, registered
                    output done
 );

reg [31:0]  Real_A, 
            Real_B,
            Im_A,
            Im_B;

reg         sum_sub,
            complex_real,
            mod_A_B,
            maxclock,
            done_alux,
            enable;

wire [63:0] out_add_sub,
            out_mult,
            out_div,
            out_mod; 

reg [63:0]  out_alux;

assign done = done_alux;

//-------------------------------------------------------
// Instation of modules
sumsub sumsub_1(
                    .clock( clock ),
                    .reset( reset ),
                    .Real_A( Real_A ),
                    .Real_B( Real_B ),
                    .Im_A( Im_A ),
                    .Im_B( Im_B ),
                    .sum_sub( sum_sub ),
                    .out( out_add_sub )
);

mult mult_1(
                    .clock( clock ),
                    .reset( reset ),
                    .complex_real( complex_real ),
                    .Real_A( Real_A ),
                    .Real_B( Real_B ),
                    .Im_A( Im_A ),
                    .Im_B( Im_B ),
                    .out( out_mult )
);

mod mod_1(
                    .clock( clock ),
                    .reset( reset ),
                    .A_B( mod_A_B ),
                    .Real_A( Real_A ),
                    .Real_B( Real_B ),
                    .Im_A( Im_A ),
                    .start( start ),
                    .enable( enable ),
                    .Im_B( Im_B ),
                    .out( out_mod )
);

//-------------------------------------------------------

always@(posedge clock)
if( reset )
begin
    Real_A <= 0;
    Real_B <= 0;
    Im_A <= 0;
    Im_B <= 0;
    outAB <= 0;
    sum_sub <= 1;
    complex_real <= 1;
    mod_A_B <= 1;
    enable <= 0;
end
else
begin
    Real_A <= inA[63:32];                       // Real part of data input A
    Im_A <= inA[31:0];                          // Imaginary part of data input A
    Real_B <= inB[63:32];                       // Real part of data input B
    Im_B <= inB[31:0];                          // Imaginary part of data input B

    if ( start )
    begin
        case ( opr )
        4'b0000: begin                                                 // A
            out_alux <= inA;
            done_alux <= 1;
        end

        4'b0001: begin                                                 // B
            out_alux <= inB;
            done_alux <= 1;
        end

        4'b0010: begin                                                 // A + B
            sum_sub <= 1;
            out_alux <= out_add_sub;
            done_alux <= 1;
        end

        4'b0011: begin                                                 // A - B
            sum_sub <= 0;
            out_alux <= out_add_sub;
            done_alux <= 1;
        end

        4'b0100: begin                                                 // A * B
            complex_real <= 1;
            out_alux <= out_mult;
            done_alux <= 1;
        end

        4'b0110: begin                                                 // RE(A) * RE(B), IM(A) * IM(B)
            complex_real <= 0;
            out_alux <= out_mult;
            done_alux <= 1;
        end

        4'b1000: begin                                                 // A == B
            if( Real_A == Real_B && Im_A == Im_B )
                out_alux <= 64'b01;
            else
                out_alux <= 0;

            done_alux <= 1;
        end
        
        4'b1001: begin                                                 // { MOD(A), ANG(A) }
            mod_A_B <= 1;
            enable <= 1;
            out_alux <= out_mod;
            done_alux <= 1;
        end

        4'b1010: begin                                                 // { MOD(B), ANG(B) }
            mod_A_B <= 0;
            enable <= 1;
            out_alux <= out_mod;
            done_alux <= 1;
        end
        
        default: begin
            out_alux <= 64'b0;
            done_alux <= 1;
        end

        endcase

        if( done_alux )
        begin
            outAB <= out_alux;
            done_alux <= 0;
            out_alux <= 0;
        end
        
    end
end

 endmodule

