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
begin
    if(enable)
    begin
        if(start)
            xr <= x;
        else
            xr <= yr[33] ? (xr - sr1) : (xr + sr1);
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
            yr <= yr[33] ? (yr + sr2) : (yr - sr2);
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
            zr <= yr[33] ? (zr - data_out_rom) : (zr + data_out_rom);
    end
end


endmodule

// end of module rec2pol