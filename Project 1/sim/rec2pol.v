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
reg signed [33:0]	xr,
					yr;

reg signed[31:0]	zr;

//Local wires
wire signed[33:0]	sr1,
					sr2,
					FF1,
					FF2;

wire signed [31:0]	data_out_rom,
					FF3;

wire  [5:0]			addr;


assign sr1 = yr >>> addr;							//arithmetic shift 
assign sr2 = xr >>> addr;							//arithmetic shift 						

//Flip-Flops
// always @(posedge clock)  
// begin
// 	if (enable)
// 		xr <= FF1;
// 		yr <= FF2;
// 		zr <= FF3;
// end

assign angle = zr;

// //-----------------------------------------------------------------------------
// // Instantiation of the sum_sub_mux module:	
// sum_sub1 upper(
// 			.A(xr),
// 			.B(sr1),
// 			.x_y(x),
// 			.yr(yr[33]),
// 			.start(start),
// 			.mux(FF1)
// 		);
				
// //-----------------------------------------------------------------------------


// //-----------------------------------------------------------------------------
// // Instantiation of the sum_sub_mux module:	
// sum_sub1 down(
// 			.A(yr),
// 			.B(sr2),
// 			.x_y(y),
// 			.yr(~yr[33]), //Not of yr[33]
// 			.start(start),
// 			.mux(FF2)
// 		);
// //-----------------------------------------------------------------------------


// //-----------------------------------------------------------------------------
// // Instantiation of the sum_sub_mux_ATAN module:	
// sum_sub2 
// 			#( .aux(32'd0)
// 			)

// 		sub3 (
// 			.A(zr),
// 			.B(data_out_rom),
// 			.yr(yr[33]),
// 			.start(start),
// 			.mux(FF3)
// 		);
//-----------------------------------------------------------------------------

//-----------------------------------------------------------------------------
// Instantiation of the ITERCOUNTER module:		
ITERCOUNTER iter_1 (  
			.clock(clock), //Sinal clock que liga a entrada do modulo .clock
			.reset(reset), 
			.start(start),
			.enable(enable),
			.count(addr) //Professor nomeou de .addr(rom_addr)
					);

//-----------------------------------------------------------------------------


//-----------------------------------------------------------------------------
// Instantiation of the ATAN_ROM module:		
ATAN_ROM #( .ROMSIZE(32)
		    )

		atan_1 (
			.addr(addr), //Professor nomeou de .addr(rom_addr)
			.data(data_out_rom)
		);
//-----------------------------------------------------------------------------

//assign addr = countß;

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
//Bloco da operacao do circuito do modulo
always @(posedge clock)
if(reset)
begin
	yr <= 32'd0;
end
else
begin
	if(start)
		yr <= y; // y(input) é carregado no registo yr
	else
		if(yr[33])
			yr <= yr + (xr >>> addr);
		else
			yr <= yr - (xr >>> addr);
end

always @(posedge clock)
if(reset)
begin
	xr <= 34'd0;
end
else
begin
	if(start)
		xr <= x; // y(input) é carregado no registo yr
	else
		if(yr[33])
			xr <= xr - (yr >>> addr);
		else
			xr <= xr + (xr >>> addr);
end

reg [31:0] zr_q
//Bloco da operacao do circuito do angulo
always @(posedge clock)
if(reset)
begin
	zr <= 32'd0;
end
else
begin
	if(start)
		zr  <= 32'd0;
	else
		if(yr[33])
			zr_q <= zr - data_out_rom;
		else
			zr <= zr + data_out_rom;
end

endmodule

// end of module rec2pol