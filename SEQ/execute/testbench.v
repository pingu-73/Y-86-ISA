`timescale 1ns / 10ps

module execute_tb;
    reg [3:0] in_code, in_fun;
    reg [63:0] val_a, val_b, val_c;
    reg clock;

    output signed [63:0] val_e;
    output cnd;

    exe dut(
        .in_code(in_code),
        .in_fun(in_fun),
        .val_a(val_a),
        .val_b(val_b),
        .val_c(val_c),
        .clock(clock),

        .val_e(val_e),
        .cnd(cnd)
    );


    initial begin
        clock=0;
        in_code=4'd0;
        in_fun=4'd0;
        val_c=64'd0;
        val_a=64'd0;
        val_b=64'd0;    

    end

    initial begin
        clock=0;

        #10 clock=~clock;

        in_code=4'b0101; in_fun=4'b0100; val_a=64'd10; val_b=64'd50; val_c=64'd20;        

        #10 clock=~clock;
        #10 clock=~clock;

        in_code=4'b0110; in_fun=4'b0001; val_a=64'd10; val_b=64'd50; val_c=64'd20;

        #10 clock=~clock;
        #10 clock=~clock;

        in_code=4'b0010; in_fun=4'b0000; val_a=64'd10; val_b=64'd50; val_c=64'd20;
        #10 clock=~clock;   
    end 
  
    initial begin
		$monitor("clock=%d\t in_code=%b\t in_fun=%b\t val_a=%d\t val_b=%d\t val_c=%d\t val_e=%d\t cnd=%d\n",clock,in_code,in_fun,val_a,val_b,val_c,val_e, cnd);
    end

    initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0);
  end

endmodule