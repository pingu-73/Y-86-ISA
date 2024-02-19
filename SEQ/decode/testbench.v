module decode_proc_tb;    
    reg [3:0] in_fun;
    reg [63:0] val_m;
    reg [3:0] in_code;
    reg [63:0] val_e;
    reg clock;
    reg [3:0] rb;
    reg [3:0] ra;
    wire [63:0] val_b;
    wire [63:0] val_a;
    decode_proc uut (
        .in_fun(in_fun),
        .val_m(val_m),
        .in_code(in_code),
        .val_e(val_e),
        .clock(clock),
        .rb(rb),
        .ra(ra),
        .val_b(val_b),
        .val_a(val_a)
    );

    initial begin
        clock=1'b0;
        repeat(10)
         #10 clock=~clock;
    end

  initial begin
        clock=1'b0;
    end

    initial begin    
        in_code=4'd0;
        ra=64'd0;
        rb=64'd0;
      #10
      in_code=4'd2; 
      ra=4'd0; 
      rb=4'd0;
      #20
      in_code=4'd3; 
       rb=4'd3;
       #20
      in_code=4'd4; 
      ra=4'd3; 
       #20
      in_code=4'd5; 
      ra=4'd3; 
       #20
      in_code=4'd6; 
      ra=4'd7; 
      rb=4'd3;
    end
    initial begin
        $monitor("time=",$time,"Clock=%d,in_code=%b,val_a=%g, val_b=%g,ra=%g, rb=%g", clock,in_code, val_a, val_b, ra, rb);
    end
endmodule