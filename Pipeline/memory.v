module memory_pipe(
    input [1:0] M_stat,
    output reg [3:0] W_dst_m,
    output reg [63:0] m_val_m,
     input [3:0] M_dst_e,
    output reg [3:0] W_in_code,
    output reg [1:0] W_stat,
       input [3:0] M_in_code,
    output reg [63:0] W_val_m,
    output reg [1:0] m_stat,
    input [3:0] M_dst_m,
    output reg [63:0] W_val_e,
    input M_cnd,
    input [63:0] M_val_e,
    input [63:0] M_val_a,
     input clock,
    output reg [3:0] W_dst_e
);
reg [63:0] mem_add;
initial 
begin
 
    mem_add=64'd0;
end
reg [63:0] mem_data_chunk[4095:0];
initial 
begin
    mem_data_chunk[0]=64'd2;
    mem_data_chunk[1]=64'd4;
    mem_data_chunk[2]=64'd6;
    mem_data_chunk[3]=64'd8;
    mem_data_chunk[4]=64'd10;
    mem_data_chunk[5]=64'd12;
    mem_data_chunk[6]=64'd14;
    mem_data_chunk[7]=64'd16;
    mem_data_chunk[8]=64'd18;
    mem_data_chunk[9]=64'd20;
    mem_data_chunk[10]=64'd22;
    mem_data_chunk[11]=64'd24;
    mem_data_chunk[12]=64'd26;
    mem_data_chunk[13]=64'd28;
    mem_data_chunk[14]=64'd30;
    mem_data_chunk[15]=64'd32;
    mem_data_chunk[16]=64'd34;
    mem_data_chunk[17]=64'd36;
    mem_data_chunk[18]=64'd38;
    mem_data_chunk[19]=64'd40;
    mem_data_chunk[20]=64'd42;
    mem_data_chunk[21]=64'd44;
    mem_data_chunk[22]=64'd46;
    mem_data_chunk[23]=64'd48;
    mem_data_chunk[24]=64'd50;
    mem_data_chunk[25]=64'd52;
    mem_data_chunk[26]=64'd54;
end
reg mem_error_data;
reg fed_value;
initial
begin
    mem_error_data=1'd0;
    m_val_m=64'd0;
end
always@(*)
begin
    if(M_in_code==4'd8)
    begin
        fed_value=M_val_a;
       mem_data_chunk[M_val_e]=M_val_a;
       mem_add=M_val_e;
    end
        if(M_in_code==4'd11 | M_in_code==4'd9)
    begin
        fed_value=0;
        m_val_m=mem_data_chunk[M_val_a];
          mem_add=M_val_a;
    end
      if(M_in_code==4'd4 | M_in_code==4'd10)
    begin
        mem_add=M_val_e;
        fed_value=M_val_a;
        mem_data_chunk[M_val_e]=M_val_a;
    end
    if(M_in_code==4'd5)
    begin
        m_val_m=mem_data_chunk[M_val_e];
        fed_value=0;
        mem_add=M_val_e;
    end
end
always@(*)
begin
    if( mem_add<0 | mem_add>64'd4095)
    begin
        mem_error_data=1;
    end
end
always@(*)
begin
    if(mem_error_data!=1)
    begin
        m_stat=M_stat;
    end
    if(mem_error_data==1)
    begin
        m_stat=2'b10;
    end
end
//changes at positive trigger
always@(posedge clock) begin
    W_in_code<=M_in_code;
    W_dst_m<=M_dst_m;
      W_val_e<=M_val_e;
    W_dst_e<=M_dst_e;
    W_stat<=m_stat;
    W_val_m<=m_val_m;
end
endmodule