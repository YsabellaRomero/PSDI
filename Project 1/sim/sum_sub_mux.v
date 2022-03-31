// Module for sum/sub plus both multiplexors:

module sum_sub1 ( 
				input [33:0] A,
				input [33:0] B,
				input yr,
                input [31:0] x_y,
                input start,
				output [33:0] mux
				);

wire [33:0] sum,
			sub,
			add_sub;

assign sum = A + B;                             //sum
assign sub = A - B;                             //sub
assign add_sub = yr ? sum : sub;			    //mux for add or sub
assign mux = start ? x_y : add_sub;				//'final' mux

endmodule