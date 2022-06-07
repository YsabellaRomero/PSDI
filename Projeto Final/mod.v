module mod(
            input clock,
            input reset,
            input A_B,             //if 1 then we're converting to polar coords the operand A
            input [31:0] Real_A,
            input [31:0] Real_B,
            input [31:0] Im_A,
            input [31:0] Im_B,
            output done,
            output [63:0] out
);

reg [63:0]  out_aux;

reg [63:0]  M;

wire [31:0] mod_A,
            mod_B,
            theta_A,
            theta_B;

reg theta;

reg done_aux;

assign done = done_aux;
assign out = out_aux;

rec2pol rec2pol_A( 
                .clock( clock ),
				.reset( reset ),
				.enable( enable ),             
				.start( start ),               
				.x( Real_A ),           // X component, 16Q16                      
				.y( Im_A ),             // Y component, 16Q16                        
				.mod( mod_A ),          // Modulus, 16Q16                            
				.angle( theta_A )       // Angle in degrees, 8Q24                
			  );

rec2pol rec2pol_B( 
                .clock( clock ),
				.reset( reset ),
				.enable( enable ),             
				.start( start ),               
				.x( Real_A ),           // X component, 16Q16                       
				.y( Im_A ),             // Y component, 16Q16                      
				.mod( mod_B ),          // Modulus, 16Q16                      
				.angle( theta_B )       // Angle in degrees, 8Q24               
			  );

always@(posedge clock)
if ( reset )
begin
    M <= 0;
    theta <= 0;
end
else
begin
    if( A_B )
    begin
        M <= mod_A;
        theta <= theta_A;
    end
    else
    begin
        M <= mod_B;
        theta <= theta_B;
    end

        out_aux <= {M , theta};     
        done_aux <= 1;                              
end

endmodule