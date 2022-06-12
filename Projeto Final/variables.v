module variables(
                    input [ 3:0] i,
                    output [79:0] word
);

reg [0:79] bank_words [15:0];

assign word = bank_words[i];

initial
begin
    //64 bits para a palavra ( 32 REAL + 32 IMAGINÁRIA)  ---  4 bits para operação  ---  6 bits para o respetivo tempo máximo
    //de operação  --- 2 bits para endwreg  ---  1 bit para enregA  ---  1 bit para enregB  --- 1 bit para cnstA  --- 1 bit 
    //para cnstB

    bank_words[0] = {64'd1232, 4'd0, 6'd1, 2'd0, 1'd1, 1'd1, 1'd0, 1'd1};
    bank_words[1] = {64'd5848, 4'd1, 6'd1, 2'd2, 1'd1, 1'd1, 1'd1, 1'd0};
    bank_words[2] = {64'd615340, 4'd2, 6'd2, 2'd1, 1'd1, 1'd1, 1'd0, 1'd0};
    bank_words[3] = {64'd982352, 4'd3, 6'd2, 2'd3, 1'd1, 1'd1, 1'd1, 1'd0};
    bank_words[4] = {64'd0814, 4'd4, 6'd6, 2'd0, 1'd1, 1'd1, 1'd0, 1'd1};
    bank_words[5] = {64'd7205, 4'd6, 6'd4, 2'd2, 1'd1, 1'd1, 1'd0, 1'd0};
    bank_words[6] = {64'd1399, 4'd8, 6'd1, 2'd1, 1'd0, 1'd1, 1'd1, 1'd0};
    bank_words[7] = {64'd63, 4'd9, 6'd38, 2'd3, 1'd1, 1'd1, 1'd0, 1'd0};
    bank_words[8] = {64'd138821, 4'd10, 6'd38, 2'd0, 1'd1, 1'd1, 1'd1, 1'd1};
    bank_words[9] = {64'd12297829382, 4'd0, 6'd1, 2'd2, 1'd0, 1'd0, 1'd0, 1'd0};
    bank_words[10] = {64'd301, 4'd1, 6'd1, 2'd1, 1'd1, 1'd0, 1'd0, 1'd1};
    bank_words[11] = {64'd1784, 4'd2, 6'd2, 2'd3, 1'd1, 1'd1, 1'd1, 1'd1};
    bank_words[12] = {64'd3312, 4'd3, 6'd2, 2'd0, 1'd0, 1'd1, 1'd0, 1'd1};
    bank_words[13] = {64'd92233, 4'd4, 6'd6, 2'd2, 1'd1, 1'd1, 1'd0, 1'd0};
    bank_words[14] = {64'd26018915, 4'd6, 6'd4, 2'd1, 1'd1, 1'd1, 1'd1, 1'd0};
    bank_words[15] = {64'd126, 4'd8, 6'd1, 2'd3, 1'd0, 1'd0, 1'd1, 1'd1};

end

//opr = 0000 (0) --> maxclock = 000001 (1)
//opr = 0001 (1) --> maxclock = 000001 (1)
//opr = 0010 (2) --> maxclock = 000010 (2)
//opr = 0011 (3) --> maxclock = 000010 (2)
//opr = 0100 (4) --> maxclock = 000110 (6)
//opr = 0110 (6) --> maxclock = 000100 (4)
//opr = 1000 (8) --> maxclock = 000001 (1)
//opr = 1001 (9) --> maxclock = 100110 (38)
//opr = 1010 (10) -> maxclock = 100110 (38)

endmodule