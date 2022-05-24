module ALUX(
                    input clock,                // Master clock, active in the posedge
                    input reset,                // Master reset, synchronous and active high
                    input [63:0] inA,           // Data input A 
                    input [63:0] inB,           // Data input B
                    input [4:0] opr,            // Operation between data input A and data input B
                    input start,
                    //--- Data output ports --------------------------------------------------
                    output reg [63:0] outAB,    // Data output A, registered
                    output done
 );

reg signed [31:0]   Real_A, 
                    Real_B,
                    Im_A,
                    Im_B;

reg [31:0]  real_aux,
            im_aux;

reg [63:0]  real_aux_1,
            real_aux_2,
            im_aux_1,
            im_aux_2,
            div_aux,
            M;

reg theta;

assign Real_A = inA[63:32];                       // Real part of data input A
assign Im_A = inA[31:0];                          // Imaginary part of data input A
assign Real_B = inB[63:32];                       // Real part of data input B
assign Im_B = inB[31:0];                          // Imaginary part of data input B

wire stop;

reg [63:0]  sqrt_aux_A,
            sqrt_aux_B;

assign sqrt_aux_A = ( Real_A * Real_A ) + ( Im_A * Im_A );
assign sqrt_aux_B = ( Real_B * Real_B ) + ( Im_B * Im_B );

sqrt_datapath  sqrt_datapath_A(
					.clock( clock ),		// master clock
					.reset( reset ),		// synch reset, active high
					.start( start ),		// start a new sqrt
					.stop( stop ),			// load output register
					.xin( sqrt_aux_A ),		// argument
					.sqrt( sqrt_A )	        // Square root
				);

sqrt_datapath  sqrt_datapath_B(
					.clock( clock ),		// master clock
					.reset( reset ),		// synch reset, active high
					.start( start ),		// start a new sqrt
					.stop( stop ),			// load output register
					.xin( sqrt_aux_B ),		// argument
					.sqrt( sqrt_B )	        // Square root
				);

always@(posedge clock)
if( reset )
begin
    Real_A <= 0;
    Real_B <= 0;
    Im_A <= 0;
    Im_B <= 0;
    outAB <= 0;
    real_aux <= 0;
    im_aux <= 0;
    M <= 0;
    theta <= 0;
end
else
begin
    if ( start )
    begin
        case ( opr )
        5'b00000: begin                                                 // A
            outAB <= A;
        end

        5'b00001: begin                                                 // B
            outAB <= B;
        end

        5'b00010: begin                                                 // A + B
            real_aux <= Real_A + Real_B;
            im_aux <= Im_A + Im_B;

            if( done )
                outAB <= {real_aux, im_aux};
            
            else    
                outAB <= 0;
        end

        5'b00011: begin                                                 // A - B
            real_aux <= Real_A - Real_B;
            im_aux <= Im_A - Im_B;

            if( done )
                outAB <= {real_aux, im_aux};

            else    
                outAB <= 0;
        end

        5'b00100: begin                                                 // A * B
            real_aux_1 <= Real_A * Real_B;                              // deve ser register ou wire?
            real_aux_2 <= Im_A * Im_B;
            im_aux_1 <= Real_A * Im_B;
            im_aux_2 <= Im_A * Real_B;

            real_aux <= real_aux_1[63:32] - real_aux_2[63:32];            
            im_aux <= im_aux_1[63:32] + im_aux_2[63:32];

            if( done )
                outAB <= {real_aux, im_aux};

            else    
                outAB <= 0;
        end

        5'b00101: begin                                                 // A / B
            real_aux_1 <= Real_A * Real_B;                              
            real_aux_2 <= Im_A * Im_B;
            im_aux_1 <= Im_A * Real_B;
            im_aux_2 <= Real_A * Im_B;

            div_aux <= ( Real_B * Real_B ) + ( Im_B * Im_B );

            real_aux <= ( real_aux_1 + real_aux_2 ) / div_aux[63:32];
            im_aux <= ( im_aux_1 - im_aux_2 ) / div_aux[63:32];

            if( done )
                outAB <= {real_aux, im_aux};

            else    
                outAB <= 0;
        end

        5'b00110: begin                                                 // RE(A) * RE(B), IM(A) * IM(B)
            real_aux_1 <= Real_A * Real_B;
            im_aux_1 <= Im_A * Im_B;

            real_aux <= real_aux_1[63:32];
            im_aux <= im_aux_1[63:32];

            if( done )
                outAB <= {real_aux, im_aux};

            else    
                outAB <= 0;
        end

        5'b00111: begin                                                 // RE(A) / RE(B), IM(A) / IM(B)
            
            
        end

        5'b01000: begin                                                 // A == B
            if( Real_A == Real_B && Im_A == Im_B && done )
                outAB <= A;
            else
                outAB <= 0;
        end

        5'b01001: begin                                                 // { MOD(A), ANG(A) }
            M <= sqrt_A;
            theta <= $atan2( Im_A , Real_A );

            if( done )
                outAB <= {M , theta};
            
            else    
                outAB <= 0;
        end

        5'b01010: begin                                                 // { MOD(B), ANG(B) }
            M <= sqrt_B;
            theta <= $atan2( Im_B , Real_B );
            
            if( done )
                outAB <= {M, theta};

            else    
                outAB <= 0;
        end

        default: begin
            outAB <= 0;
        end

        endcase

    end
end

 endmodule