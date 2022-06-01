module div(
            input clock,
            input reset,
            input complex_real,             //if 1 then we're dealing with a complex multiplication
            input [31:0] Real_A,
            input [31:0] Real_B,
            input [31:0] Im_A,
            input [31:0] Im_B,
            output [63:0] out
);

reg [63:0] out_aux;

reg [31:0]  real_aux,
            im_aux;

reg [63:0]  real_aux_1,
            real_aux_2,
            im_aux_1,
            im_aux_2,
            div_aux;

assign out = out_aux;

always@(posedge clock)
if( reset )
begin
    real_aux <= 0;
    im_aux <= 0;
    real_aux_1 <= 0;
    real_aux_2 <= 0;
    im_aux_1 <= 0;
    im_aux_2 <= 0;
    div_aux <= 0;
end
else
begin
    if( complex_real )
    begin
        real_aux_1 <= Real_A * Real_B;                              
        real_aux_2 <= Im_A * Im_B;
        im_aux_1 <= Im_A * Real_B;
        im_aux_2 <= Real_A * Im_B;

        div_aux <= ( Real_B * Real_B ) + ( Im_B * Im_B );

        real_aux <= ( real_aux_1 + real_aux_2 ) / div_aux[63:32];
        im_aux <= ( im_aux_1 - im_aux_2 ) / div_aux[63:32];
    end

        //else
        //begin
            // ??????
        //end

    out_aux <= {real_aux, im_aux};
end

endmodule   