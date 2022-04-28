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
parameter k = 20;                             //alínea 5.2  

//Inputs and outputs
input clock;                
input reset;                      
input start;                        
input stop;                         
input [NBITSIN-1:0] xin;                   
output reg [(NBITSIN/2)-1:0] sqrt;

//Local register:
reg signed [NBITSIN-1:0]        FF1;
reg signed [(NBITSIN/2)-1:0]    tempsqrt,
                                shift_reg,
                                FF2;
reg signed                      comparator;


//Local wires:
wire signed [NBITSIN-1:0]  sqtestsqrt;
wire signed [(NBITSIN/2)-1:0] testsqrt;


//---------------------------------------------------
// Square (result of 32 bits)
assign sqtestsqrt = testsqrt * testsqrt;      


//---------------------------------------------------
// Initial flip-flop:
always@(posedge clock)                         
if(reset)
    //FF1 <= 32'h0000;
    FF1 <= 0;                    
else
begin
    if(start & ($bits(xin) > 4 && $bits(xin) < 64))               //verifies if the number of bits of xin is > 4 and < 64 --> alínea 5.1                                                                 
    begin                                                         //alínea 5.2
        if(k % 2 == 0)                                            //verifies is k is even or odd
            FF1 <= xin << k;                                      //X * 2^k    
        else
        begin
            FF1 <= xin << (k + 1);                                //make k even if odd
        end
    end
        FF1 <= xin;
end


//---------------------------------------------------
// Comparator
always @*
if (FF1 >= sqtestsqrt)                                            //A >= B 
    comparator <= 1;
else
    comparator <= 0;


//---------------------------------------------------
// Flip-flop with 2 multiplexers (left input for the OR Gate)
always@(posedge clock)
if(reset)
    //tempsqrt <= 16'h0000;
    tempsqrt <= 0;
else
begin
    if(start)
        tempsqrt <= 16'h0000;
        //tempsqrt <= 0;
    else
        tempsqrt <= comparator ? testsqrt : tempsqrt;           //second multiplexor
end


//---------------------------------------------------
// Flip-flop with stop as enable
always@(posedge clock)
if(reset)
    //sqrt <= 16'h0000;
    sqrt <= 0;
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
    //sqrt <= 16'h0000;
    sqrt <= 0;
else
begin
    if(start)         
        //FF2  <= 16'h8000;                
        FF2  <= 'h8000;                                            
    else
        FF2 <= FF2 >> 1;
end


endmodule