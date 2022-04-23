module psdsqrt(
    input clock,                        //master clock rising edge
    input reset,                        //synch reset active high
    input start,                        //start a new square root, one clock cycle
    input stop,                         //load output register, one clock pulse
    input [31:0] xin,                   //operand, unsigned integer 32 bits
    output reg [15:0] sqrt              //sqrt(xin), unsigned integer 16 bits
);

reg signed [31:0]   FF1;

reg signed [15:0]   testsqrt,
                    tempsqrt,
                    shift_reg,
                    FF2;

wire signed [31:0]  sqtestsqrt;

reg signed comparator;

assign sqtestsqrt = testsqrt * testsqrt;        //WARNING: verificar se o resultado é de 32 bits ou 16 bits 

always@(posedge clock)                  //Initial flip-flop
if(reset)
    FF1 <= 32'h0000;                    //confirma com os colegas tulio
else
begin
    if(start)
        FF1 <= xin;
end



always @*
if (FF1 >= sqtestsqrt)                  //A >= B WARNING: o sqtestsqrt pode dar problemas por ser um wire 
    comparator <= 1;
else
    comparator <= 0;



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



always@(posedge clock)
if(reset)
    sqrt <= 16'h0000;
else
begin
    if(stop)
        sqrt <= tempsqrt;
end



always@(posedge clock)
if(reset)
    sqrt <= 16'h0000;
else
begin
    if(start)                           //perguntar se o enable deste flip flop é o start
        FF2  <= 16'h8000;               //perguntar como trataram deste lado do circuito tulio
    else
        FF2 <= FF2 >> 1;
end


assign testsqrt = tempsqrt | FF2;      //OR Gate


endmodule