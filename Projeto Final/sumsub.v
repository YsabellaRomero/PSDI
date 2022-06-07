module sumsub(
                input clock,
                input reset,
                input [31:0] Real_A,
                input [31:0] Real_B,
                input [31:0] Im_A,
                input [31:0] Im_B,
                input sum_sub,              //if sum_sub = 1 we're dealing with sum, else with sub
                output done,
                output [63:0] out
);

reg [63:0]  out_aux;

reg [31:0]  aux_Real,
            aux_Im;

reg done_aux;

assign done = done_aux;
assign out = out_aux;

always@(posedge clock)
if( reset )
begin
    aux_Real <= 0;
    aux_Im <= 0;
end
else
begin
    if( sum_sub )
    begin
        aux_Real <= Real_A + Real_B;
        aux_Im <= Im_A + Im_B;
    end
    else
    begin
        aux_Real <= Real_A - Real_B;
        aux_Im <= Im_A - Im_B;
    end

    out_aux <= {aux_Real,aux_Im};
    done_aux <= 1;
end

endmodule



    
