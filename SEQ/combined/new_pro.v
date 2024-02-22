`timescale 1ns/1ps


`include "decode.v"
`include "execute.v"
`include "fetch.v"
`include "memory.v"
`include "pc_update.v"
`include "writeback.v"


module combined();
   
    reg [63:0] p_ctr;
	 reg clock;
    reg [3:0] en_coder;
    wire [3:0] in_code;
	 wire signed [63:0] val_b;
    wire [63:0] val_m;
    wire [3:0] in_fun;
    wire signed [63:0] val_c;
	wire flag_halt;
    wire in_error;
    wire [63:0] val_p;
	 wire [3:0] ra;
    wire [3:0] rb;
    wire signed [63:0] val_a;
	 wire zroFlag, N, V, cnd;
    wire signed [63:0] val_e, mem_data, mem_add;
    wire [63:0] p_ctr_final;
    wire bad_mem,bad_mem2;
   
    fetch_seq dut_1 (
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
    decode_proc dut_2 (
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
    exe dut_3(
        .in_code(in_code),
        .in_fun(in_fun),
        .val_a(val_a),
        .val_b(val_b),
        .val_c(val_c),
        .clock(clock),

        .val_e(val_e),
        .cnd(cnd)
    );
    mem dut_4 (
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
    writeBack dut_5(
        .clock(clock),
        .cnd(cnd),
        .in_code(in_code), 
        .ra(ra), 
        .rb(rb), 
        .val_e(val_e), 
        .val_m(val_m)
    );
    pc_update dut_6 (
        .in_code(in_code),
        .val_p(val_p),
        .clock(clock),
        .val_c(val_c),
        .val_m(val_m),
        .cnd(cnd),
        .p_ctr_final(p_ctr_final)
    );
    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0);
    end
    initial 
    begin
        clock = 1;
        p_ctr = 64'd0;
       en_coder=4'd8;
    end

    
    always #5 clock =~ clock;

    always@(*)
    begin
		if(in_error)
        begin
        en_coder=4'd4;
        $finish;
        end
		if(bad_mem2== 1)
        begin
        en_coder=4'd1;
        $finish;
        end
        if(flag_halt)
        begin
        en_coder=4'b0010;
        $finish;
        end
        if(bad_mem== 1)
        begin
        en_coder=4'b0001;
        $finish;
        end
        else
        begin
       en_coder=4'b1000;
        end
    end
always@(*)
begin
p_ctr=p_ctr_final;
end

   always@(*)
    begin
        if(en_coder==4'b0010) 
        begin
            $finish;
        end
        if(en_coder==4'b0011) begin
            $finish;
        end

        if(en_coder==4'b0100 || en_coder==4'b0101 || en_coder==4'b1101 || en_coder==4'b0110 || en_coder==4'b0111 || en_coder==4'b1100 || en_coder==4'b1110 || en_coder==4'b1111)
        begin
            $finish;
        end
        
        
        if(en_coder==4'b1010) begin
            $finish;
        end
        
    end
    initial begin
        $monitor("clock=%d,  in_code=%b,  in_fun=%b, ra=%b,  rb=%b\n val_a=%g,  val_b=%g,  val_c=%g, val_e=%g, val_m=%g,  p_ctr_final=%g\n mem_data=%g,  mem_add=%g,  bad_mem=%d, bad_mem2=%d, invalid_ins=%b, flag_halt=%b, cnd=%d\n ", clock, in_code, in_fun, ra, rb, val_a, val_b, val_c, val_e, val_m, p_ctr_final, mem_data, mem_add, bad_mem, bad_mem2, in_error, flag_halt, cnd);
    end
endmodule
