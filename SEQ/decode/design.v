module decode_proc(
    input [3:0] in_fun,
    input [63:0] val_m,
    input [3:0] in_code,
    input [63:0] val_e,
    input clock,
    input [3:0] rb,
    input [3:0] ra,
    output reg [63:0] val_b,
    output reg [63:0] val_a 
);
reg cnd;
reg [63:0] reg_chunk [0:14];
initial begin
    cnd=1'd1;
end
always @(posedge clock)
begin
    $readmemh("input.txt",reg_chunk);
end
always @(*)
begin
    if(clock==0)
    begin
        cnd=1'd0;
    end
    else
    begin
    if(in_code==4'd0)
    begin
        //no need 
    end
     if(in_code==4'd1)
    begin
        //no need 
    end
    if(in_code==4'd2)
    begin
        val_a=reg_chunk[ra];
    end
     if(in_code==4'd3)
    begin
        //no need
    end
     if(in_code==4'd4)
    begin
        val_a=reg_chunk[ra];
        val_b=reg_chunk[rb];
    end
      if(in_code==4'd5)
    begin
        //val_a=reg_chunk[ra];
        val_b=reg_chunk[rb];
    end
       if(in_code==4'd6)
    begin
        val_a=reg_chunk[ra];
        val_b=reg_chunk[rb];
    end
    
        if(in_code==4'd7)
    begin
        //no need
    end
    if(in_code==4'd8)
    begin
        val_b=reg_chunk[4];
    end
    if(in_code==4'd9)
    begin
        val_a=reg_chunk[4];
         val_b=reg_chunk[4];
    end
    if(in_code==4'd11)
    begin
        val_a=reg_chunk[4];
         val_b=reg_chunk[4];
    end
       if(in_code==4'd10)
    begin
        val_a=reg_chunk[ra];
         val_b=reg_chunk[4];
    end
    end
end


endmodule