module controller(
				 input clock, // master clock rising edge 
				 input reset,
				 input maxclock,
				 input opr,
				 input alux_done,
				 output done
				);

reg [3:0] state;
reg counter;	

always @(posedge clock)

if( !alux_done )
begin 
 	//Wait to start the next operation
end
else 
begin
	//Register in RAM the result of the last operation
	//Start the next operation from RAM
end

// begin
// 	case ( state )
// 	4'b0000: 
// 	begin
// 		if( start )
// 		begin
// 			case( opr )
// 			4'b0000: state <= 4'b0001;
// 			4'b0001: state <= 4'b0010;
// 			4'b0010: state <= 4'b0011;
// 			4'b0011: state <= 4'b0100;
// 			4'b0100: state <= 4'b0101;
// 			4'b0110: state <= 4'b0110;
// 			4'b1000: state <= 4'b0111;
// 			4'b1001: state <= 4'b1000;
// 			4'b1010: state <= 4'b1001;
// 			endcase
// 		end 
// 	end
// 	4'b0001: 
// 	begin 
// 		if ( alux_done || done || reset ) 
// 		begin
// 			done <= 0;
// 			counter <= 0;
// 			reset <= 0;
// 			state <= 4'b0000;
// 		end

// 		if ( !alux_done )
// 		begin
// 			if( counter < maxclock )
// 				counter <= counter + 1;
// 			else
// 			begin
// 				done <= 1;
// 				state <= 4'b0000;
// 			end
// 		end
// 	end
		
// 	4'b0010: begin 
// 		if ( alux_done || done || reset ) 
// 		begin
// 			done <= 0;
// 			counter <= 0;
// 			reset <= 0;
// 			state <= 4'b0000;
// 		end

// 		if ( !alux_done )
// 		begin
// 			if( counter < maxclock )
// 				counter <= counter + 1;
// 			begin
// 				done <= 1;
// 				state <= 4'b0000;
// 			end
// 		end
// 	end
		
// 	4'b0011: 
// 	begin
// 			if ( alux_done || done || reset ) 
// 		begin
// 			done <= 0;
// 			counter <= 0;
// 			reset <= 0;
// 			state <= 4'b0000;
// 		end

// 		if ( !alux_done )
// 		begin
// 			if( counter < maxclock )
// 				counter <= counter + 1;
// 			begin
// 				done <= 1;
// 				state <= 4'b0000;
// 			end
// 		end
// 	end

// 	4'b0100: 
// 	begin
// 		if ( alux_done || done || reset ) 
// 		begin
// 			done <= 0;
// 			counter <= 0;
// 			reset <= 0;
// 			state <= 4'b0000;
// 		end

// 		if ( !alux_done )
// 		begin
// 			if( counter < maxclock )
// 				counter <= counter + 1;
// 			begin
// 				done <= 1;
// 				state <= 4'b0000;
// 			end
// 		end
// 	end

// 	4'b0101: 
// 	begin
// 		if ( alux_done || done || reset ) 
// 		begin
// 			done <= 0;
// 			counter <= 0;
// 			reset <= 0;
// 			state <= 4'b0000;
// 		end

// 		if ( !alux_done )
// 		begin
// 			if( counter < maxclock )
// 				counter <= counter + 1;
// 			begin
// 				done <= 1;
// 				state <= 4'b0000;
// 			end
// 		end
// 	end

// 	4'b0110: 
// 	begin
// 		if ( alux_done || done || reset ) 
// 		begin
// 			done <= 0;
// 			counter <= 0;
// 			reset <= 0;
// 			state <= 4'b0000;
// 		end

// 		if ( !alux_done )
// 		begin
// 			if( counter < maxclock )
// 				counter <= counter + 1;
// 			begin
// 				done <= 1;
// 				state <= 4'b0000;
// 			end
// 		end
// 	end

// 	4'b0111: 
// 	begin
// 		if ( alux_done || done || reset ) 
// 		begin
// 			done <= 0;
// 			counter <= 0;
// 			reset <= 0;
// 			state <= 4'b0000;
// 		end

// 		if ( !alux_done )
// 		begin
// 			if( counter < maxclock )
// 				counter <= counter + 1;
// 			begin
// 				done <= 1;
// 				state <= 4'b0000;
// 			end
// 		end
// 	end

// 	4'b1000: 
// 	begin
// 		if ( alux_done || done || reset ) 
// 		begin
// 			done <= 0;
// 			counter <= 0;
// 			reset <= 0;
// 			state <= 4'b0000;
// 		end

// 		if ( !alux_done )
// 		begin
// 			if( counter < maxclock )
// 				counter <= counter + 1;
// 			begin
// 				done <= 1;
// 				state <= 4'b0000;
// 			end
// 		end
// 	end

// 	4'b1001: 
// 	begin
// 		if ( alux_done || done || reset ) 
// 		begin
// 			done <= 0;
// 			counter <= 0;
// 			reset <= 0;
// 			state <= 4'b0000;
// 		end
		
// 		if ( !alux_done )
// 		begin
// 			if( counter < maxclock )
// 				counter <= counter + 1;
// 			begin
// 				done <= 1;
// 				state <= 4'b0000;
// 			end
// 		end
// 	end

// 	default: state<= 4'b0000;
// 	endcase
// end
	

					
endmodule

