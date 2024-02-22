module mem(
input [3:0] in_code,
input [63:0] val_e,
input [63:0] val_p,
input [63:0] val_a,
input clock,
output reg bad_mem2,
output reg [63:0] mem_add,
output reg [63:0] val_m,
output reg [63:0] mem_data
);
reg [63:0] mem_chunk[0:1023];
initial
begin
    val_m = 64'd0;
    mem_add=64'd0;
    mem_data=64'd0;
    bad_mem2=0;
end
initial 
begin
    mem_chunk[0]=64'd0;
    mem_chunk[1]=64'd1;
    mem_chunk[2]=64'd2;
    mem_chunk[3]=64'd3;
    mem_chunk[4]=64'd4;
    mem_chunk[5]=64'd5;
    mem_chunk[6]=64'd6;
    mem_chunk[7]=64'd7;
    mem_chunk[8]=64'd8;
    mem_chunk[9]=64'd9;
    mem_chunk[10]=64'd10;
    mem_chunk[11]=64'd11;
    mem_chunk[12]=64'd12;
    mem_chunk[13]=64'd13;
    mem_chunk[14]=64'd14;
    mem_chunk[15]=64'd15;
    mem_chunk[16]=64'd16;
    mem_chunk[17]=64'd17;
    mem_chunk[18]=64'd18;
    mem_chunk[19]=64'd19;
    mem_chunk[20]=64'd20;
end
always@(*)
begin    
          if(clock==1)
          begin
          if(in_code==4'd11 | in_code==4'd9)
        begin
            val_m=mem_chunk[val_a];
            mem_add=val_a;
            bad_mem2=0;
        end
          if(in_code==4'd5)
        begin
            val_m=mem_chunk[val_e];
            mem_add=val_e;
             bad_mem2=0;
        end
        if(in_code==4'd10 | in_code==4'd4)
        begin
            mem_chunk[val_e]=val_a;
            mem_add=val_e;
             bad_mem2=0;
        end
        if(in_code==4'd8)
        begin
            mem_chunk[val_e]=val_p;
            mem_add=val_e;
             bad_mem2=0;
        end
        mem_data=mem_chunk[val_e];
          end

          
          else
          begin
            if(mem_add>64'd1023)
            begin
                bad_mem2=1;
            end
          end
    end
endmodule
