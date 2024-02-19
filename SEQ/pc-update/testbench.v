module pc_update_tb;
  reg [3:0] in_code_tb;
  reg [63:0] val_p_tb;
  reg clock_tb;
  reg [63:0] val_c_tb;
  reg [63:0] val_m_tb;
  reg cnd_tb;
  output [63:0] p_ctr_final_tb;

  
  pc_update uut (
    .in_code(in_code_tb),
    .val_p(val_p_tb),
    .clock(clock_tb),
    .val_c(val_c_tb),
    .val_m(val_m_tb),
    .cnd(cnd_tb),
    .p_ctr_final(p_ctr_final_tb)
  );

  initial begin
    clock_tb = 0;
    forever #5 clock_tb = ~clock_tb;
    val_m_tb=64'd0;
    val_c_tb=64'd0;
    val_p_tb=64'd0;
    cnd_tb=0;
  end

  initial begin
    in_code_tb = 4'd6;
    val_m_tb=64'd5;
    val_c_tb=64'd3;
    val_p_tb=64'd8;
    cnd_tb=0;
    #10;

    in_code_tb = 4'd9;
     val_m_tb=64'd4;
    val_c_tb=64'd91;
    val_p_tb=64'd21;
    cnd_tb=0;
    #10;

     in_code_tb = 4'd8;
     val_m_tb=64'd19;
    val_c_tb=64'd15;
    val_p_tb=64'd16;
    cnd_tb=1;
    #10;

 in_code_tb = 4'd4;
     val_m_tb=64'd22;
    val_c_tb=64'd6;
    val_p_tb=64'd6;
    cnd_tb=1;
    #10;

 in_code_tb = 4'd5;
     val_m_tb=64'd12;
    val_c_tb=64'd23;
    val_p_tb=64'd27;
    cnd_tb=1;
    #10;

     in_code_tb = 4'd1;
     val_m_tb=64'd27;
    val_c_tb=64'd29;
    val_p_tb=64'd31;
    cnd_tb=1;
    #10;
    
    $stop;
  end

  
  initial begin
    $monitor("clock=%b, Time=%0t, in_code=%0d, val_m=%g, val_c=%g, val_p=%g, cnd=%g, p_ctr_final=%g",
      clock_tb,$time, in_code_tb, val_m_tb, val_c_tb, val_p_tb, cnd_tb, p_ctr_final_tb);
  end

endmodule