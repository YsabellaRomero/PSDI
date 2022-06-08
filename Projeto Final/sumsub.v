module sumsub(
                input clock,
                input reset,
                input [31:0] Real_A,
                input [31:0] Real_B,
                input [31:0] Im_A,
                input [31:0] Im_B,
                input sum_sub,              //if sum_sub = 1 we're dealing with sum, else with sub
                output [63:0] out
);

reg [63:0]  out_aux;

reg [31:0]  aux_Real,
            aux_Im;

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
end

endmodule



    
