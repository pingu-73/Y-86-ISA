module mem_tb;
  reg [3:0] in_code;
  reg [63:0] val_e;
  reg [63:0] val_p;
  reg [63:0] val_a;
  reg clock;
  output bad_mem2;
  output [63:0] mem_add;
  output [63:0] val_m;
  output [63:0] mem_data;

  mem uut (
    .in_code(in_code),
    .val_e(val_e),
    .val_p(val_p),
    .val_a(val_a),
    .clock(clock),
    .bad_mem2(bad_mem2),
    .mem_add(mem_add),
    .val_m(val_m),
    .mem_data(mem_data)
  );


  initial
  begin
    clock = 1;
    repeat (10)  
    #10 clock = ~clock;
  end

  initial begin
    clock=0;
    in_code=4'd0;
  end

  initial begin
     val_p=64'd0;
     val_a=64'd0;
     val_e=64'd0;
  end
  initial begin
    #10;
    in_code = 4'd5;
    val_e = 64'd3;
      #20;
    in_code = 4'd10;
    val_e = 64'd5;
    val_a = 64'd17;
    #20;
    in_code = 4'd5;
    val_e = 64'd4;
    val_a = 64'd25;
    #20;
    in_code = 4'd9;
    val_e = 64'd3;
    val_a = 64'd5;
    #20;
    in_code = 4'd8;
    val_e = 64'd3;
    val_p = 64'd999;
  end

  initial begin
    $monitor("clock=%d,Time=%0t, in_code=%d, val_e=%g, val_p=%g, val_a=%g, bad_mem2=%g, mem_add=%g, val_m=%g, mem_data=%g",
      clock,$time, in_code, val_e, val_p, val_a, bad_mem2, mem_add, val_m, mem_data);
  end

endmodule