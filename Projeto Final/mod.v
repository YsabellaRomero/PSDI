module mod(
            input clock,
            input reset,
            input A_B,             //if 1 then we're converting to polar coords the operand A
            input [31:0] Real_A,
            input [31:0] Real_B,
            input [31:0] Im_A,
            input [31:0] Im_B,
            output [63:0] out
);

reg [63:0]  out_aux;

reg [63:0]  sqrt_aux_A,
            sqrt_aux_B,
            M;

wire [31:0] sqrt_A,
            sqrt_B;

reg theta;

assign out = out_aux;

sqrt_datapath  sqrt_datapath_A(
					.clock( clock ),		// master clock
					.reset( reset ),		// synch reset, active high
					.start( start ),		// start a new sqrt
					.stop( stop ),			// load output register
					.xin( sqrt_aux_A ),		// argument
					.sqrt( sqrt_A )	        // Square root
				);

sqrt_datapath  sqrt_datapath_B(                                                 //CORRIGIR TAMAMHOS NO SQRT_DATAPATH
					.clock( clock ),		// master clock
					.reset( reset ),		// synch reset, active high
					.start( start ),		// start a new sqrt
					.stop( stop ),			// load output register
					.xin( sqrt_aux_B ),		// argument
					.sqrt( sqrt_B )	        // Square root
				);

always@(posedge clock)
if ( reset )
begin
    sqrt_aux_A <= 0;
    sqrt_aux_B <= 0;
    M <= 0;
    theta <= 0;
end
else
begin

    sqrt_aux_A = ( Real_A * Real_A ) + ( Im_A * Im_A );
    sqrt_aux_B = ( Real_B * Real_B ) + ( Im_B * Im_B );

    if( A_B )
    begin
        M <= sqrt_A;
        theta <= $atan2( Im_A , Real_A );
    end
    else
    begin
        M <= sqrt_B;
        theta <= $atan2( Im_B , Real_B );
    end

        out_aux <= {M , theta};                                   
end

endmodule