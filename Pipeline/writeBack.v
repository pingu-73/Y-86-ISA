module wb_pipe(
input [3:0] W_dst_e, 
input [3:0] W_in_code,
input [3:0] W_dst_m,
input [63:0] W_val_e, 
input [63:0] W_val_m,
input clock
);
reg write_start;
reg  [63:0] wb_curr_value;  
reg read_start;  // wb->value box
reg [63:0] reg_chunk[0:14]; // %rax to 15th register
initial begin
 read_start=1'b0;
 write_start=1'b0;
end
always@(posedge clock) begin
read_start=1;
 $readmemh("common.txt",reg_chunk);         
end
always@(*) begin
      if(W_in_code==4'd9 | W_in_code==4'd8)
    begin
        wb_curr_value=W_val_e;
        reg_chunk[W_dst_e]=wb_curr_value;
        $writememh("common.txt",reg_chunk);
        write_start=1;
    end
        if(W_in_code==4'd11)
    begin
        wb_curr_value=W_val_e;
        reg_chunk[W_dst_e]=wb_curr_value;
        wb_curr_value=W_val_m;
        reg_chunk[W_dst_m]=wb_curr_value;
        $writememh("common.txt",reg_chunk);
        write_start=1;
    end
    if(W_in_code==4'd3 | W_in_code==4'd2 | W_in_code==4'd6 | W_in_code==4'd10)
    begin
        wb_curr_value=W_val_e;
        reg_chunk[W_dst_e]=wb_curr_value;
        $writememh("common.txt",reg_chunk);
        write_start=1;
    end
     if(W_in_code==4'd5)
    begin
        wb_curr_value=W_val_m;
        reg_chunk[W_dst_m]=wb_curr_value;
        $writememh("common.txt",reg_chunk);
        write_start=1;
    end
end
endmodule