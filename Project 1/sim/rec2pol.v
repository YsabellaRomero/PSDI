
/*
    Master in Electrical and Computer Engineering - FEUP
	
	M.EEC041 - Digital Systems Design 2021/2022
	
	----------------------------------------------------------------------
	module rec2pol - Converts rectangular coords to polar coords using the CORDIC algorithm
	
	Summary
	This module implements the CORDIC algorithm in vectoing mode to 
	convert the rectangular coordinates of a vector to polar coordinates.
	
	The inputs X and Y are 32 bit integers representing the X and Y coordinates
	with 16 integer bits and 16 fractional bits (16Q16 format)
	
	The outputs are the modulus represented in the same format and the 
	angle represented in degrees with 8 integer bits and 24 fractional bits
	
	Input range:
	The input X must be positive and less than 32767;
    The Y input can be positive or negative in the interval [-32768, 32767];
	The output modulus cannot exceed the 16-bit maximum positive in two's complement (32767)
	  
	----------------------------------------------------------------------	
	Date created: 4 Oct 2019
	Author: jca@fe.up.pt
	
	----------------------------------------------------------------------	
	This Verilog code is property of the University of Porto, Portugal
	Its utilization beyond the scope of the course Digital Systems Design
	(Projeto de Sistemas Digitais) of the Integrated Master in Electrical 
	and Computer Engineering requires explicit authorization from the author.
	
*/

module rec2pol( 
                input clock,
				input reset,
				input enable,              // set and keep high to enable iteration
				input start,               // set to 1 for one clock to start 
				input  signed [31:0] x,    // X component, 16Q16
				input  signed [31:0] y,    // Y component, 16Q16
				output signed [31:0] mod,  // Modulus, 16Q16
				output signed [31:0] angle // Angle in degrees, 8Q24
			  );
			  
			   
// ADD YOUR RTL CODE HERE	

//Registers

reg[33:0]			xr, //Register for X after aritmetic operations
					yr, //Register for Y after aritmetic operations
					zr; //Register for angle after aritimetic operations

reg[31:0]			aux_32d0;


//Local wires

wire[5:0]			count;

wire[33:0]			sr1, //Wire of X to the mux
					sr2, //Wire of Y to the mux
					add_sub1,
					mux1,
					add_sub2,
					mux2,
					Qp1,
					Qn1,
					Qp2,
					Qn2;

wire[31:0]			data,
					add_sub3,
					mux3,
					Qp3,
					Qn3;


assign sr1 = yr >>> count;						//arithmetic shift 
assign Qp1 = xr + sr1;							//sum
assign Qn1 = xr - sr1;							//sub
assign add_sub1 = yr ? Qp1 : Qn1;				//mux for add or sub
assign mux1 = start ? x : add_sub1;				//'final' mux

assign sr2 = xr >>> count;						
assign Qp2 = xr + sr2;							
assign Qn2 = xr - sr2;							
assign add_sub2 = yr ? Qp2 : Qn2;				
assign mux2 = start ? y : add_sub2;				

assign Qp3 = zr + data;							
assign Qn3 = zr - data;							
assign add_sub3 = yr ? Qp3 : Qn3;				
assign mux1 = start ? aux_32d0 : add_sub3;		

assign angle = zr;

//-----------------------------------------------------------------------------
// Instantiation of the ATAN_ROM module:		
ATAN_ROM 
			#( .ROMSIZE(32)
		    )

		atan_1 (
			.addr(count),
			.data(data)
		);

assign addr = count;
//-----------------------------------------------------------------------------

// Instantiation of the ITERCOUNTER module:		
ITERCOUNTER 
		
		iter_1 (  
			.clock(clock),
			.reset(reset),
			.start(start),
			.enable(enable),
			.count(count)
		);

//-----------------------------------------------------------------------------

// Instantiation of the MODSCALE module:		
MODSCALE 
			#( .CORDIC_SCALE_FACTOR(50'd159188) 
			)

		modscal_1 (
			.XF(xr),
			.MODUL(mod)
		);
//-----------------------------------------------------------------------------


//flip-flop 1
always @(posedge reset or posedge clock)  
begin
	if (reset)
		xr <= 32'd0;
	
	else
		xr <= mux1;
end

//flip-flop 2
always @(posedge reset or posedge clock)  
begin
	if (reset)
		yr <= 32'd0;
	
	else
		yr <= mux2;
end

//flip-flop 3
always @(posedge reset or posedge clock)  
begin
	if (reset)
		zr <= 32'd0;
	
	else
		zr <= mux3;
end
		   
//ITERCOUNTER
always @(posedge start or posedge enable)
begin
	if (enable)
		count = enable;
end

endmodule
// end of module rec2pol