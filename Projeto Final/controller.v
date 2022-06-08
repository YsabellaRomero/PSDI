module controller(
				 input 			clock, 				// master clock rising edge 
				 input 			reset,
				 input [ 5:0] 	maxclock,
				 input [03:0] 	opr,
				 input 			done,
				 input 			start,
				 input [63:0] 	out_alux,
				 output [63:0]	out
				);

reg [3:0] 	state;
reg [63:0]	out_ram;
reg [ 5:0]	counter;	

//Symbolic state names
parameter S0 = 4'b0000;			// Initial state
parameter S1 = 4'b0001;			// A					
parameter S2 = 4'b0010;			// B					
parameter S3 = 4'b0011;			// sum			
parameter S4 = 4'b0100;			// sub	
parameter S5 = 4'b0101;			// complex multiplication
parameter S6 = 4'b0110;			// real multiplication
parameter S7 = 4'b0111;			// A == B
parameter S8 = 4'b1000;			// mod A
parameter S9 = 4'b1001;			// mod B

assign out = out_ram;

always @(posedge clock)
begin
	case ( state )
	S0: begin
		if( start )
		begin
			case( opr )
			4'b0000: state <= S1;
			4'b0001: state <= S2;
			4'b0010: state <= S3;
			4'b0011: state <= S4;
			4'b0100: state <= S5;
			4'b0110: state <= S6;
			4'b1000: state <= S7;
			4'b1001: state <= S8;
			4'b1010: state <= S9;
			endcase
		end 
		else
			state <= 4'b0000;
	end
	S1: begin 
		if ( done || reset ) 
		begin
			counter <= 0;
			state <= S0;
		end

		if ( !done )
		begin
			if( counter < maxclock )
				counter <= counter + 1;
			else
			begin
				out_ram <= out_alux;
				state <= S0;
			end
		end
	end
		
	S2: begin 
		if ( done || reset ) 
		begin
			counter <= 0;
			state <= S0;
		end

		if ( !done )
		begin
			if( counter < maxclock )
				counter <= counter + 1;
			begin
				out_ram <= out_alux;
				state <= S0;
			end
		end
	end
		
	S3: begin
		if ( done || reset ) 
		begin
			counter <= 0;
			state <= S0;
		end

		if ( !done )
		begin
			if( counter < maxclock )
				counter <= counter + 1;
			begin
				out_ram <= out_alux;
				state <= S0;
			end
		end
	end

	S4: begin
		if ( done || reset ) 
		begin
			counter <= 0;
			state <= S0;
		end

		if ( !done )
		begin
			if( counter < maxclock )
				counter <= counter + 1;
			begin
				out_ram <= out_alux;
				state <= S0;
			end
		end
	end

	S5: begin
		if ( done || reset ) 
		begin
			counter <= 0;
			state <= S0;
		end

		if ( !done )
		begin
			if( counter < maxclock )
				counter <= counter + 1;
			begin
				out_ram <= out_alux;
				state <= S0;
			end
		end
	end

	S6: begin
		if ( done || reset ) 
		begin
			counter <= 0;
			state <= S0;
		end

		if ( !done )
		begin
			if( counter < maxclock )
				counter <= counter + 1;
			begin
				out_ram <= out_alux;
				state <= S0;
			end
		end
	end

	S7: begin
		if ( done || reset ) 
		begin
			counter <= 0;
			state <= S0;
		end

		if ( !done )
		begin
			if( counter < maxclock )
				counter <= counter + 1;
			begin
				out_ram <= out_alux;
				state <= S0;
			end
		end
	end

	S8: begin
		if ( done || reset ) 
		begin
			counter <= 0;
			state <= S0;
		end

		if ( !done )
		begin
			if( counter < maxclock )
				counter <= counter + 1;
			begin
				out_ram <= out_alux;
				state <= S0;
			end
		end
	end

	S9: begin
		if ( done || reset ) 
		begin
			counter <= 0;
			state <= S0;
		end
		
		if ( !done )
		begin
			if( counter < maxclock )
				counter <= counter + 1;
			begin
				out_ram <= out_alux;
				state <= S0;
			end
		end
	end

	default: state<= S0;
	endcase
end
	

					
endmodule

