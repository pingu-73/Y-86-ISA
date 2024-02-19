module writeBack(
    input clock, cnd,
    input [3:0] in_code, ra, rb,

    input [63:0] val_e, val_m
);

    reg [3:0] dst_m, dst_e;
    reg [63:0] Register_File[0:14];


    always@(*) begin
        if(clock==1)
            $readmemh("registers.txt", Register_File);
        
    end

    always@(*) begin
        if(clock == 0)
        begin
            $writememh("registers.txt", Register_File);
        end
    end

    initial begin
        dst_m = 4'd15;
        dst_e = 4'd15;
    end

    always@(negedge clock)
    begin
        case(in_code)
            4'd2: 
            begin
                if (cnd == 1)
                begin 
                    dst_e = rb;
                    Register_File[dst_e] = val_e;
                end
            end
            4'd3: 
            begin 
                dst_e = rb;
                Register_File[dst_e] = val_e;
            end
            4'd5: 
            begin 
                dst_m = ra;
                Register_File[dst_m] = val_m;
            end
            4'd6: 
            begin 
                dst_e = rb;
                Register_File[dst_e] = val_e;
            end
            4'd8: 
            begin 
                dst_e = 4'd4;
                Register_File[dst_e] = val_e;
            end
            4'd9: 
            begin 
                dst_e = 4'd4;
                Register_File[dst_e] = val_e;
            end
            4'd10:
            begin
                dst_e = 4'd4;
                Register_File[dst_e] = val_e;
            end
            4'd11: 
            begin
                dst_e = 4'd4;
                Register_File[dst_e] = val_e;

                dst_m = ra;
                Register_File[dst_m] = val_m;
            end
        endcase
    end
endmodule