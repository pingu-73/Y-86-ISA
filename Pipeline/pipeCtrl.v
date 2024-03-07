module p_control(
output reg F_st,
input e_cnd,
input [3:0] d_src_b,
input [3:0] M_in_code,
input [3:0] d_src_a,
output reg set_cc,
input [3:0] D_in_code,
output reg D_st,
input [1:0] W_stat,
output reg D_bub,
input [3:0] E_in_code,
input [3:0] E_dst_m,
output reg E_bub,
input [1:0] m_stat
);
reg pip_control_start;
reg pip_control_end;
initial begin
    pip_control_end=1'b0;
end
initial begin
    pip_control_start=1'b1;
end
always@(*)
begin
    set_cc=1;
    F_st=0;
    D_st=0;
    E_bub=0;
    D_bub=0;
       if(E_in_code==4'd5 & ((E_dst_m==d_src_b)|(E_dst_m==d_src_a)))
  begin
    pip_control_end=1;
    E_bub=1;
    D_st=1;
    F_st=1;
  end
    else if(E_in_code==4'd7)
    begin
        if(e_cnd==1)
        begin
            // no need
        end
        if(e_cnd==0)
        begin
          E_bub=1;
          D_bub=1;
        end
        pip_control_end=1;
    end 
 
  else if(E_in_code==4'd11 & ((E_dst_m==d_src_b)|(E_dst_m==d_src_a)))
  begin
    pip_control_end=1;
    E_bub=1;
    D_st=1;
    F_st=1;
  end
 
 else if(E_in_code==4'd9 | D_in_code==4'd9 | M_in_code==4'd9)
 begin
    D_bub=1;
    F_st=1;
    pip_control_end=1;
 end
 
else if (m_stat!=2'd0 | W_stat!=2'd0 |E_in_code==0)
begin
    pip_control_end=1;
    set_cc=1'b0;
end
end
endmodule