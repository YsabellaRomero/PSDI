//Nós não determinamos o número de bits de entrada
//Parameter for 5.1 
parameter NBITSIN = 32;                  //Range of NBITSIN should be 4 - 64 bits

module psdsqrt(
    input clock,                        //master clock rising edge
    input reset,                        //synch reset active high
    input start,                        //start a new square root, one clock cycle
    input stop,                         //load output register, one clock pulse
    input [NBITSIN-1:0] xin,                   //operand, unsigned integer 32 bits
    output reg [(NBITSIN/2)-1:0] sqrt              //sqrt(xin), unsigned integer 16 bits
    parameter NBITSIN;
);

//Local register:
reg signed [31:0]   FF1;
reg signed [15:0]   tempsqrt,
                    shift_reg,
                    FF2;
reg signed          comparator;


//Local wires:
wire signed [31:0]  sqtestsqrt;
wire signed [15:0] testsqrt;


//---------------------------------------------------
// Square (result of 32 bits)
assign sqtestsqrt = testsqrt * testsqrt;        


//---------------------------------------------------
// Initial flip-flop:
always@(posedge clock)                         
if(reset)
    FF1 <= 32'h0000;                    
else
begin
    if(start && ($bits(xin) > NBITSIN) && ($bits(xin) < 64))       //verifies if the number of bits of 
    begin                                                                   //is > 4 and < 64 --> 5.1
        //$display("SIZE OF XIN: %d", xin); 
        FF1 <= xin;
    end
end


//---------------------------------------------------
// Comparator
always @*
if (FF1 >= sqtestsqrt)                  //A >= B 
    comparator <= 1;
else
    comparator <= 0;


//---------------------------------------------------
// Flip-flop with 2 multiplexers (left input for the OR Gate)
always@(posedge clock)
if(reset)
    tempsqrt <= 16'h0000;
else
begin
    if(start)
        tempsqrt <= 16'h0000;
    else
        tempsqrt <= comparator ? testsqrt : tempsqrt;           //second multiplexor
end


//---------------------------------------------------
// Flip-flop with stop as enable
always@(posedge clock)
if(reset)
    sqrt <= 16'h0000;
else
begin
    if(stop)
        sqrt <= tempsqrt;
end


//---------------------------------------------------
// OR Gate
assign testsqrt = tempsqrt | FF2;       


//---------------------------------------------------
// Flip-flop with multiplexer & shift register (right input for the OR Gate)
always@(posedge clock)
if(reset)
    sqrt <= 16'h0000;
else
begin
    if(start)                           
        FF2  <= 16'h8000;               
    else
        FF2 <= FF2 >> 1;
end


endmodule