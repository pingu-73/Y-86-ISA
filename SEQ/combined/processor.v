`timescale 1ns/1ps


`include "decode.v"
`include "execute.v"
`include "fetch.v"
`include "memory.v"
`include "pc_update.v"
`include "writeback.v"


module combined();
    reg clock;
    reg [63:0] p_ctr;
    reg [3:0] status_code;

    reg stat_AOK;
    reg stat_INS;
    reg stat_HLT;
    reg stat_ADR;

    wire [3:0] in_code;
    wire [3:0] in_fun;
    wire [3:0] ra;
    wire [3:0] rb;
    wire signed [63:0] val_c;
    wire [63:0] val_p;
    wire signed [63:0] val_a;
    wire signed [63:0] val_b;
    wire [63:0] val_m;
    wire [63:0] p_ctr_final;

    wire bad_mem;
    output flag_halt;
    wire in_error;
    wire bad_mem2;
    wire zroFlag, N, V, cnd;
    wire signed [63:0] val_e, mem_data, mem_add;
    
    

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
        stat_AOK = 1;
        stat_INS = 0;
        stat_HLT = 0;
	stat_ADR = 0;
    end

    always #8 clock =~ clock;

    always@(*)
    begin
        if(flag_halt)
        begin
        stat_AOK=1'b0;
        stat_INS=1'b0;
        stat_HLT=1'b1;
        stat_ADR=1'b0;
        // $finish;
        end
        else if(in_error)
        begin
        stat_AOK=1'b0;
        stat_INS=1'b1;
        stat_HLT=1'b0;
        stat_ADR=1'b0;
        end
        else if(bad_mem== 1 || bad_mem2 == 1)
        begin
        stat_AOK=1'b0;
        stat_INS=1'b0;
        stat_HLT=1'b0;
        stat_ADR=1'b1;
        // $finish;
        end
        else
        begin
        stat_AOK=1'b1;
        stat_INS=1'b0;
        stat_HLT=1'b0;
        stat_ADR=1'b0;
        end
    end
always@(*)
begin
p_ctr=p_ctr_final;
end

   always@(*)
    begin
        if(stat_ADR == 1)
        begin
            $finish;
        end
        else if (stat_HLT == 1)
        begin
            $finish;
        end
    end
    initial begin
        $monitor("clock=%d,  in_code=%b,  in_fun=%b, ra=%b,  rb=%b\n val_a=%g,  val_b=%g,  val_c=%g, val_e=%g, val_m=%g,  p_ctr_final=%g\n mem_data=%g,  mem_add=%g,  bad_mem=%g, invalid_ins=%b,  cnd=%d,  halt=%d, stat_AOK=%d, stat_INS=%d, stat_ADR=%d\n ", clock, in_code, in_fun, ra, rb, val_a, val_b, val_c, val_e, val_m, p_ctr_final, mem_data, mem_add, bad_mem, in_error, cnd, stat_HLT, stat_AOK, stat_INS, stat_ADR);
    end
endmodule