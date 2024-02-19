module pc_update(
    input [3:0] in_code,
    input [63:0] val_p,
    input clock,
    input [63:0] val_c,
    input [63:0] val_m,
    input cnd,
    output reg [63:0] p_ctr_final
);
always@(*)
begin
    if(in_code==4'd9)
    begin
        p_ctr_final=val_m;
    end
    if(in_code==4'd7)
    begin
        if(cnd==1'b1)
        begin
            p_ctr_final=val_c;
        end
        else
        begin
            p_ctr_final=val_p;
        end
    end
    if(in_code==4'd8)
    begin
        p_ctr_final=val_c;
    end
     if(in_code==4'd1 | in_code==4'd0)
     begin
        p_ctr_final=val_p;
    end
     if(in_code==4'd3 | in_code==4'd5)
     begin
        p_ctr_final=val_p;
    end
     if(in_code==4'd4 | in_code==4'd2 | in_code==4'd6)
     begin
        p_ctr_final=val_p;
    end
     if(in_code==4'd11 | in_code==4'd10)
     begin
        p_ctr_final=val_p;
    end
end
endmodule