module txtrigger_ctrl(
    input clock,                        //master clock, active in posedge
    input reset,                        //synchronous reset, active high
    input [9:0] CKINI,                  //number of clocks before trigger txtrigger
    input [9:0] CKPER,                  //number of clock between txtrigger pulses
    input [4:0] NPER,                   //number of txtrigger pulses per start
    output txtrigger,                   //txtrigger pulse, single clock period
    output busy                         //set to 1 while generating pulses
);

reg [1:0]           STATE;
reg [1:0]           NEXTSTATE;
reg signed [9:0]    CNT_INI,
                    CNT_CKPER;

parameter   INI = 2’b00, 
            S1 = 2'b01, 
            S2 = 2’b10,
            S3 = 2'b11;

always @(posedge clock)     // NEXTSTATE logic
begin
    if (reset)
        begin
            NEXTSTATE <= INI;
        end
    else
    begin
        case(STATE)
            INI: if(start)
                begin
                    STATE <= S1;
                    CNT_INI <= CKINI;
                    busy <= 1;
                end

            S1: if(CNT_INI == 0)
                begin
                    STATE <= S2;
                    CNT_CKPER <= NPER;
                end
                else
                    CNT_INI <= CNT_INI - 1;

            S2: if(CNT_CKPER == 0)
                begin
                    STATE <= S3;
                    CNT_CKPER <= NPER;
                end
                else
                    CNT_CKPER <= CNT_CKPER - 1;

            S3: if(CNT_CKPER == 0)
                begin
                    STATE <= INI;
                    busy <= 0;
                end
                else if(CNT_CKPER == 0)
                    STATE <= S2;
                else
                    CNT_CKPER <= CNT_CKPER - 1;
        endcase 
    end
end


always @(posedge clock)     // output logic
    case(STATE)
        INI: txtrigger = 0;
        S1: txtrigger = 0;
        S2: txtrigger = 1;
        S3: txtrigger = 0;
    endcase

    /************** OR **************/
    //
    // txtrigger = ( STATE == S2 ); 
    //
    /********************************/

endmodule