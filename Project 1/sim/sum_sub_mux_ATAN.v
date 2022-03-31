// Module for sum/sub plus both multiplexors after ATAN_ROM:

module sum_sub2 ( 
				input [31:0] A,
				input [31:0] B,
				input yr,
                input start,
				output [31:0] mux
				);

wire [33:0] sum,
			sub,
			add_sub;

parameter aux = 32'd0;

assign sum = A + B;                             //sum
assign sub = A - B;                             //sub
assign add_sub = yr ? sum : sub;			    //mux for add or sub
assign mux = start ? aux : add_sub;				//'final' mux

endmodule