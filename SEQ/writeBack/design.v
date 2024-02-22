module writeBack(
    input clock, cnd,
    input [3:0] in_code, ra, rb,

    input [63:0] val_e, val_m
);

    reg [63:0] reg_chunk[0:14];


    always@(*) begin
        if(clock==1)
            $readmemh("registers.txt", reg_chunk);
        
    end

    always@(*) begin
        if(clock == 0)
        begin
            $writememh("registers.txt", reg_chunk);
        end
    end


    always@(negedge clock)
    begin
        case(in_code)
            4'd2: 
            begin
                if (cnd == 1)
                begin 
                    reg_chunk[rb] = val_e;
                end
            end
            4'd3: 
            begin 
                reg_chunk[rb] = val_e;
            end
            4'd5: 
            begin 
                reg_chunk[ra] = val_m;
            end
            4'd6: 
            begin 
                reg_chunk[rb] = val_e;
            end
            4'd8: 
            begin 
                reg_chunk[4'd4] = val_e;
            end
            4'd9: 
            begin 
                reg_chunk[4'd4] = val_e;
            end
            4'd10:
            begin
                reg_chunk[4'd4] = val_e;
            end
            4'd11: 
            begin
                reg_chunk[4'd4] = val_e;

                reg_chunk[ra] = val_m;
            end
        endcase
    end
endmodule
