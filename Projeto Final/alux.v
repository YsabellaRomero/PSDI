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
            mod_A_B;

wire [63:0] out_add_sub,
            out_mult,
            out_div,
            out_mod; 

reg [63:0]  out;
      

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
                    .done( done ),
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
                    .done( done ),
                    .out( out_mult )
);

mod mod_1(
                    .clock( clock ),
                    .reset( reset ),
                    .A_B( mod_A_B ),
                    .Real_A( Real_A ),
                    .Real_B( Real_B ),
                    .Im_A( Im_A ),
                    .Im_B( Im_B ),
                    .done( done ),
                    .out( out_mod )
);

controller controller_1 (
                    .clock( clock ),
                    .reset( reset ),
                    .maxclock( )

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
end
else
begin
    Real_A <= inA[63:32];                       // Real part of data input A
    Im_A <= inA[31:0];                          // Imaginary part of data input A
    Real_B <= inB[63:32];                       // Real part of data input B
    Im_B <= inB[31:0];                          // Imaginary part of data input B

    begin
	case ( state )
	4'b0000: 
	begin
		if( start )
		begin
			case( opr )
			4'b0000: state <= 4'b0001;
			4'b0001: state <= 4'b0010;
			4'b0010: state <= 4'b0011;
			4'b0011: state <= 4'b0100;
			4'b0100: state <= 4'b0101;
			4'b0110: state <= 4'b0110;
			4'b1000: state <= 4'b0111;
			4'b1001: state <= 4'b1000;
			4'b1010: state <= 4'b1001;
			endcase
		end 
	end
	4'b0001:                                                     // A
	begin 
		if ( done || reset ) 
		begin
			done <= 0;
			counter <= 0;
			reset <= 0;
			state <= 4'b0000;
		end

		if ( !alux_done )
		begin
            maxclock <= 1;
            out <= inA;
			if( counter < maxclock )
				counter <= counter + 1;
			else
			begin
				done <= 1;
				state <= 4'b0000;
			end
		end
	end
		
	4'b0010: begin 
		if ( alux_done || done || reset ) 
		begin
			done <= 0;
			counter <= 0;
			reset <= 0;
			state <= 4'b0000;
		end

		if ( !alux_done )
		begin
			if( counter < maxclock )
				counter <= counter + 1;
			begin
				done <= 1;
				state <= 4'b0000;
			end
		end
	end
		
	4'b0011: 
	begin
			if ( alux_done || done || reset ) 
		begin
			done <= 0;
			counter <= 0;
			reset <= 0;
			state <= 4'b0000;
		end

		if ( !alux_done )
		begin
			if( counter < maxclock )
				counter <= counter + 1;
			begin
				done <= 1;
				state <= 4'b0000;
			end
		end
	end

	4'b0100: 
	begin
		if ( alux_done || done || reset ) 
		begin
			done <= 0;
			counter <= 0;
			reset <= 0;
			state <= 4'b0000;
		end

		if ( !alux_done )
		begin
			if( counter < maxclock )
				counter <= counter + 1;
			begin
				done <= 1;
				state <= 4'b0000;
			end
		end
	end

	4'b0101: 
	begin
		if ( alux_done || done || reset ) 
		begin
			done <= 0;
			counter <= 0;
			reset <= 0;
			state <= 4'b0000;
		end

		if ( !alux_done )
		begin
			if( counter < maxclock )
				counter <= counter + 1;
			begin
				done <= 1;
				state <= 4'b0000;
			end
		end
	end

	4'b0110: 
	begin
		if ( alux_done || done || reset ) 
		begin
			done <= 0;
			counter <= 0;
			reset <= 0;
			state <= 4'b0000;
		end

		if ( !alux_done )
		begin
			if( counter < maxclock )
				counter <= counter + 1;
			begin
				done <= 1;
				state <= 4'b0000;
			end
		end
	end

	4'b0111: 
	begin
		if ( alux_done || done || reset ) 
		begin
			done <= 0;
			counter <= 0;
			reset <= 0;
			state <= 4'b0000;
		end

		if ( !alux_done )
		begin
			if( counter < maxclock )
				counter <= counter + 1;
			begin
				done <= 1;
				state <= 4'b0000;
			end
		end
	end

	4'b1000: 
	begin
		if ( alux_done || done || reset ) 
		begin
			done <= 0;
			counter <= 0;
			reset <= 0;
			state <= 4'b0000;
		end

		if ( !alux_done )
		begin
			if( counter < maxclock )
				counter <= counter + 1;
			begin
				done <= 1;
				state <= 4'b0000;
			end
		end
	end

	4'b1001: 
	begin
		if ( alux_done || done || reset ) 
		begin
			done <= 0;
			counter <= 0;
			reset <= 0;
			state <= 4'b0000;
		end
		
		if ( !alux_done )
		begin
			if( counter < maxclock )
				counter <= counter + 1;
			begin
				done <= 1;
				state <= 4'b0000;
			end
		end
	end

	default: state<= 4'b0000;
	endcase
end

    // if ( start )
    // begin
    //     case ( opr )
    //     4'b0000: begin                                                 // A
    //         maxclock <= 1;
    //         out <= inA;
    //     end

    //     4'b0001: begin                                                 // B
    //         maxclock <= 1;
    //         out <= inB;
    //     end

    //     4'b0010: begin                                                 // A + B
    //         maxclock <= 2;
    //         sum_sub <= 1;
    //         out <= out_add_sub;
    //     end

    //     4'b0011: begin                                                 // A - B
    //         maxclock <= 2;
    //         sum_sub <= 0;
    //         out <= out_add_sub;
    //     end

    //     4'b0100: begin                                                 // A * B
    //         maxclock <= 6;
    //         complex_real <= 1;
    //         out <= out_mult;
    //     end

    //     4'b0110: begin                                                 // RE(A) * RE(B), IM(A) * IM(B)
    //         maxclock <= 4;
    //         complex_real <= 0;
    //         out <= out_mult;
    //     end

    //     4'b1000: begin                                                 // A == B
    //         maxclock <= 1;
    //         if( Real_A == Real_B && Im_A == Im_B )
    //             out <= 64'b01;
    //         else
    //             out <= 0;
    //     end
        
    //     4'b1001: begin                                                 // { MOD(A), ANG(A) }
    //         maxclock <= 38;
    //         mod_A_B <= 1;
    //         out <= out_mod;
    //     end

    //     4'b1010: begin                                                 // { MOD(B), ANG(B) }
    //         maxclock <= 38;
    //         mod_A_B <= 0;
    //         out <= out_mod;
    //     end
        
    //     default: begin
    //         out <= 64'b0;
    //     end

    //     endcase

    //     if( done )
    //     begin
    //         outAB <= out;
    //     end 
    // end
end

 endmodule

