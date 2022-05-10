module psdsqrt(
                clock,                        //master clock rising edge
                reset,                        //synch reset active high
                start,                        //start a new square root, one clock cycle
                stop,                         //load output register, one clock pulse
                xin,                          //operand, unsigned integer 32 bits
                sqrt                          //sqrt(xin), unsigned integer 16 bits
);


//Parameters
parameter NBITSIN = 32;                       //alínea 5.1
parameter k = 8;                             //alínea 5.2  

//Inputs and outputs
input clock;                
input reset;                      
input start;                        
input stop;                         
input [NBITSIN+k-1:0] xin;                   
output reg [((NBITSIN)/2)-1:0] sqrt;

//Local register
reg signed [NBITSIN+k-1:0]        FF1;
reg signed [((NBITSIN+k)/2)-1:0]    tempsqrt,
                                shift_reg,
                                FF2;
reg signed                      comparator;


//Local wires
wire signed [NBITSIN+k-1:0]  sqtestsqrt;
wire signed [((NBITSIN+k)/2)-1:0] testsqrt;
wire [(k/2)-1:0]parte_frac;
wire [(NBITSIN+k)/2-1-(k/2):0] parte_inteira;

//Local register
reg signed [((NBITSIN+k)/2)-1:0] aux;


//---------------------------------------------------
// Square (result of 32 bits)
assign sqtestsqrt = testsqrt * testsqrt;                                 //sqtestsqrt has 40 bits


//---------------------------------------------------
// Initial flip-flop:
always@(posedge clock)                         
if(reset)
    FF1 <= {(NBITSIN+k){1'b0}};                
else
begin
    if(start & ((NBITSIN+(k/2)) > 4 && (NBITSIN+(k/2)) < 64))            //verifies if the number of bits of xin is > 4 and < 64 --> alínea 5.1                                                              
        FF1 <= xin << 8;                                                 //xin now will have 40 bits
end


//---------------------------------------------------
// Comparator
always @*
if (FF1 >= sqtestsqrt)                                                   //A >= B 
    comparator <= 1;
else
    comparator <= 0;


//---------------------------------------------------
// Flip-flop with 2 multiplexers (left input for the OR Gate)
always@(posedge clock)
if(reset)
    tempsqrt <= {(((NBITSIN+k)/2)){1'b0}};
else
begin
    if(start)
        tempsqrt <= {(((NBITSIN+k)/2)){1'b0}};
    else
        tempsqrt <= comparator ? testsqrt : tempsqrt;                   //second multiplexor
end


assign parte_frac = tempsqrt[(k/2)-1:0];
assign parte_inteira = tempsqrt[(((NBITSIN+k)/2)-1):(k/2)];

//---------------------------------------------------
// Flip-flop with stop as enable
always@(posedge clock)
if(reset)
    sqrt <= {(((NBITSIN+k)/2)){1'b0}};
else
if(stop)
begin
    if(parte_frac < 8)                                          //8d = 1000b
	    sqrt <= parte_inteira;
	else if(parte_frac == 8) 
	    sqrt <= (parte_inteira + parte_inteira[0]);
	else if (parte_frac >= 9) 
	    sqrt <= (parte_inteira+1);

end


//---------------------------------------------------
// OR Gate
assign testsqrt = tempsqrt | FF2;                               //testsqrt has 20 bits


//---------------------------------------------------
// Flip-flop with multiplexer & shift register (right input for the OR Gate)
always@(posedge clock)

if(reset)
    sqrt <= {(((NBITSIN+k)/2)){1'b0}};
else

begin
    if(start)                       
        FF2  <= {1'b1, {(((NBITSIN+k)/2)-1){1'b0}}};                                             
    else
        FF2 <= FF2 >> 1;
end


endmodule