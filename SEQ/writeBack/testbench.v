`timescale 1ns / 10ps

module write_back_tb();
    reg clock, cnd;
    reg [3:0] in_code, ra, rb;
    reg [63:0] val_e, val_m;

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
        repeat (12)  #10 clock = ~clock;
    end

    initial
    begin
        clock=0;
        in_code=4'd0;
        ra=4'd0;
        rb=4'd0;
        cnd=0;
        val_e=64'd0;
        val_m=64'd0;

    end

    initial
    begin

        #10
        in_code=4'd2; ra=4'd0; rb=4'd1; cnd=0; val_e=64'd21; val_m=64'd58;

        #20
        in_code=4'd2; ra=4'd0; rb=4'd1; cnd=1; val_e=64'd21; val_m=64'd58;

        #20
        in_code=4'd3; ra=4'd1; rb=4'd2; cnd=0; val_e=64'd77; val_m=64'd0;

        #20
        in_code=4'd3; ra=4'd1; rb=4'd2; cnd=1; val_e=64'd77; val_m=64'd0;

        #20
        in_code=4'd4; ra=4'd3; rb=4'd4; cnd=1; val_e=64'd256;val_m=64'd10;

        #20
        in_code=4'd5; ra=4'd5; rb=4'd4; cnd=1; val_e=64'd256; val_m=64'd10;        
    end

    initial 
    begin
        $monitor("clock = %d\t in_code = %b\t ra = %b\t rb = %b\t Cnd = %b\t val_e = %g\t val_m = %g\n",clock,in_code,ra,rb,cnd,val_e,val_m);
    end
    // initial
    // begin

    //     $dumpfile("dump.vcd");
    //     $dumpvars(0, write_back_tb);
    // end
endmodule