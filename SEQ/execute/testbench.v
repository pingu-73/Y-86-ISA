`timescale 1ns / 10ps

module execute_tb;
    reg [3:0] in_code, in_fun;
    reg [63:0] val_a, val_b, val_c;
    reg clock;

    output [63:0] val_e;
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

 initial
    begin
        clock = 0;
        repeat (16)  
        #10 clock = ~clock;
    end

    initial begin
        clock=0;
        in_code = 4'd0;
        in_fun = 4'd0;
    end
    initial begin
        #10 
        in_code=4'b0101; 
        in_fun=4'b0100; 
        val_a=64'd10; 
        val_b=64'd41; 
        val_c=64'd23;        
        #20
        in_code=4'b0110; 
        val_a=64'd13; 
        #20
        in_fun=4'b0000; 
        val_c=64'd117;
           #20
        val_a=64'd73; 
        val_b=64'd74; 
           #20
        in_code=4'b0010; 
        val_a=64'd14; 
        val_c=64'd19;
           #20
        val_b=64'd91; 
           #20
        in_code=4'b0011; 
           #20
        val_a=64'd101; 
        val_b=64'd111; 
        val_c=64'd121;
         
    end 
  
    initial begin
		$monitor("clock=%d\t in_fun=%b\t in_code=%b\t val_b=%g\t val_c=%g\t val_a=%g\t cnd=%d\t val_e=%g\n",clock,in_fun,in_code,val_b,val_c,val_a,cnd, val_e);
    end

    initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0);
  end

endmodule