module fetch_seq_tb;
    reg [63:0] p_ctr;
    reg clock;
    wire [3:0] in_code, in_fun, rb, ra;
    wire flag_halt;
    wire [63:0] val_c, val_p;
    wire bad_mem, in_error;

    fetch_seq uut (
        .p_ctr(p_ctr),
        .clock(clock),
        .in_code(in_code),
        .in_fun(in_fun),
        .rb(rb),
        .ra(ra),
        .flag_halt(flag_halt),
        .val_c(val_c),
        .val_p(val_p),
        .bad_mem(bad_mem),
        .in_error(in_error)
    );
initial
  begin
    clock = 0;
    repeat (7) 
     #10 clock = ~clock;
  end

  initial
  begin

    $dumpfile("fetch_tb.vcd");
    $dumpvars(0, fetch_seq_tb);

    clock=0;
    p_ctr=64'd0;

  end
  
  initial 
  begin 

    #10 
    p_ctr=64'd0; 
    
    #20
    p_ctr=val_p;
    
    #20
    p_ctr=val_p;
    
    // #20
    // p_ctr=64'd1024;    
    
  end 
  
  initial 
  begin
    $monitor($time, "\tclk = %d p_ctr = %g\n\t\tin_code = %b in_fun = %b ra = %b rb = %b val_c = %g val_p = %g bad_mem = %d, in_error = %d, halt = %d\n",clock,p_ctr,in_code,in_fun,ra,rb,val_c,val_p,bad_mem,in_error, flag_halt);
  end
endmodule
