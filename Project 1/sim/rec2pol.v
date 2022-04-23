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
reg signed [33:0]			xr,
							yr;

reg signed [31:0]			zr;

//Local wires

wire signed [33:0]			sr1,
							sr2, 
							xr_aux;

wire signed [31:0]			data_out_rom;

wire [5:0]					addr;


assign sr1 = yr >>> addr;							//arithmetic shift 
assign sr2 = xr >>> addr;							//arithmetic shift 						

assign angle = zr;


/*
//-----------------------------------------------------------------------------
// Instantiation of the sum_sub_mux module:	
sum_sub1 upper(
			.start(start),
			.enable(enable),
			.reset(reset),
			.clock(clock),
			.A(xr),
			.B(sr1),
			.yr(yr[33]),
			.x_y(x),
			.aux(xr_aux)
		);
				
//-----------------------------------------------------------------------------

assign xr_aux = xr;

//-----------------------------------------------------------------------------
// Instantiation of the sum_sub_mux module:	
sum_sub1 down(
			.start(start),
			.enable(enable),
			.reset(reset),
			.clock(clock),
			.A(yr),
			.B(sr2),
			.yr(~yr[33]),
			.x_y(y),
			.aux(xr_aux)
		);
//-----------------------------------------------------------------------------


//-----------------------------------------------------------------------------
// Instantiation of the sum_sub_mux_ATAN module:	
sum_sub2 ss2 (
			.start(start),
			.enable(enable),
			.reset(reset),
			.clock(clock),
			.A(zr),
			.B(data_out_rom),
			.yr(yr[33]),
			.angle(angle)
		);
//-----------------------------------------------------------------------------
*/

//-----------------------------------------------------------------------------
// Instantiation of the ITERCOUNTER module:		
ITERCOUNTER iter_1 (  
			.clock(clock),
			.reset(reset),
			.start(start),
			.enable(enable),
			.count(addr)
		);

//-----------------------------------------------------------------------------

//-----------------------------------------------------------------------------
// Instantiation of the ATAN_ROM module:		
ATAN_ROM atan_1 (
			.addr(addr),
			.data(data_out_rom)
		);
//-----------------------------------------------------------------------------


//-----------------------------------------------------------------------------
// Instantiation of the MODSCALE module:		
MODSCALE modscal_1 (
			.XF(xr),
			.MODUL(mod)
		);
//-----------------------------------------------------------------------------


always@(posedge clock)
if(reset)
    xr <= 34'd0;
else
begin
    if(enable)
    begin
        if(start)
            xr <= x;
        else
            //yr <= yr ? (A - B) : (A + B);
            if(yr[33])
                xr <= xr - sr1;
            else
                xr <= xr + sr1;
    end
end

always@(posedge clock)
if(reset)
    yr <= 34'd0;
else
begin
    if(enable)
    begin
        if(start)
            yr <= y;
        else
            //yr <= yr ? (A - B) : (A + B);
            if(yr[33])
                yr <= yr + sr2;
            else
                yr <= yr - sr2;
    end
end


always@(posedge clock)
if(reset)
    zr <= 32'd0;
else
begin
    if(enable)
    begin
        if(start)
            zr <= 32'd0;
        else
            //yr <= yr ? (A - B) : (A + B);
            if(yr[33])
                zr <= zr - data_out_rom;
            else
                zr <= zr + data_out_rom;
    end
end


endmodule

// end of module rec2pol