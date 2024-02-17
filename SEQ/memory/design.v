module mem(
input [3:0] in_code,
input [63:0] val_e,
input [63:0] val_p,
input [63:0] val_a,
input clock,
output reg bad_mem,
output reg [63:0] mem_add,
output reg [63:0] val_m,
output reg [63:0] mem_data
);
reg [63:0] memory_chunk[1023:0];
initial
begin
    mem_add=64'd0;
    mem_data=64'd0;
end
initial 
begin
    memory_chunk[0]=64'd2;
    memory_chunk[1]=64'd4;
    memory_chunk[2]=64'd6;
    memory_chunk[3]=64'd8;
    memory_chunk[4]=64'd10;
    memory_chunk[5]=64'd12;
    memory_chunk[6]=64'd14;
    memory_chunk[7]=64'd16;
    memory_chunk[8]=64'd18;
    memory_chunk[9]=64'd20;
    memory_chunk[10]=64'd22;
    memory_chunk[11]=64'd24;
    memory_chunk[12]=64'd26;
    memory_chunk[13]=64'd28;
    memory_chunk[14]=64'd30;
    memory_chunk[15]=64'd32;
    memory_chunk[16]=64'd34;
    memory_chunk[17]=64'd36;
    memory_chunk[18]=64'd38;
    memory_chunk[19]=64'd40;
    memory_chunk[20]=64'd42;
    memory_chunk[21]=64'd44;
    memory_chunk[22]=64'd46;
    memory_chunk[23]=64'd48;
    memory_chunk[24]=64'd50;
    memory_chunk[25]=64'd52;

end
always@(posedge clock)
begin
    bad_mem=1'b0;
    if(mem_add>64'd1023)
    begin
        bad_mem=1'b1;
    end
    if(bad_mem==0)
    begin
        mem_add=val_e;
          if(in_code==4'd11)
        begin
            val_m=memory_chunk[val_a];
            mem_add=val_a;
        end
          if(in_code==4'd5)
        begin
            val_m=memory_chunk[val_e];
        end
          if(in_code==4'd9)
        begin
            val_m=memory_chunk[val_a];
             mem_add=val_a;
        end
        if(in_code==4'd10)
        begin
            memory_chunk[val_e]=val_a;
        end
         if(in_code==4'd4)
        begin
            memory_chunk[val_e]=val_a;
        end
        if(in_code==4'd8)
        begin
            memory_chunk[val_e]=val_p;
        end
        mem_data=memory_chunk[val_e];
    end
end

endmodule