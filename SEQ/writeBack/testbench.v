module write_back_test();
    reg clock, cnd;
    reg [63:0] val_m;
    reg [3:0] in_code, ra, rb;
    reg [63:0] val_e;

    writeBack dut(
        .clock(clock),
        .cnd(cnd),
        .in_code(in_code), 
        .ra(ra), 
        .rb(rb), 
        .val_e(val_e), 
        .val_m(val_m)
    );

    initial
    begin
        clock = 0;
        repeat (12)  
        #10 clock = ~clock;
    end

    initial
    begin
        clock=0;
        in_code=4'd0;
        ra=4'd2;
    end
    initial begin
          rb=4'd2;
        cnd=1;
        val_e=64'd0;
        val_m=64'd0;
    end


    initial
    begin

        #10
        in_code=4'd3;
        ra=4'd0; 
        val_e=64'd21; 
        val_m=64'd58;
        #20
        in_code=4'd3; 
        ra=4'd3; 
        cnd=1; 
        #20
        in_code=4'd4; 
        rb=4'd4; 
        cnd=1; 
        val_e=64'd81; 
        val_m=64'd66;
        #20
        cnd=0;
        val_e=64'd77;
        #20
        val_m=64'd10;
        #20
        ra=4'd5; 
        rb=4'd4; 
        val_e=64'd261; 
        val_m=64'd262;        
    end

    initial 
    begin
        $monitor("clock = %d\t cnd = %b\t val_e = %b\t rb = %b\t in_code = %b\t val_m = %g\t ra = %g\n",clock,cnd,val_e,rb,in_code,val_m,ra);
    end
endmodule
