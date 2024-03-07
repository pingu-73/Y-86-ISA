`include "fetch.v"
`include "pipeCtrl.v"
`include "decode.v"
`include "writeBack.v"
`include "execute.v"
`include "memory.v"



module pipe();
    reg [1:0] stat;
    reg [63:0] F_prediction_pc;
    reg clock;
    wire [63:0] f_prediction_pc;
    wire [63:0] m_val_m;
    wire [3:0] d_src_a, d_src_b;
    wire F_st, D_st, D_bub, E_bub;
    wire [63:0] d_val_a, d_val_b;
    wire [3:0] D_rb;
    wire [3:0] W_dst_m;
    wire [63:0] D_val_p;
    wire [3:0] W_dst_e;
    wire [3:0] D_ra;
    wire [3:0] M_in_code;    
    wire [63:0] M_val_a;
    wire [63:0] E_val_b;
    wire [63:0] E_val_c;
    wire [1:0] D_stat;
    wire [3:0] E_dst_e;
    wire [3:0] E_dst_m; 
    wire [3:0] M_dst_e;
    wire M_cnd;
    wire[1:0] M_stat;
    wire [3:0] E_src_a;
    wire [1:0] W_stat;
    wire [3:0] E_in_code;
    wire [63:0] M_val_e;
    wire [3:0] M_dst_m;
    wire [1:0] E_stat;
    wire [3:0] E_in_fun;
    wire [3:0] W_in_code;
    wire [63:0] D_val_c;
    wire [3:0] D_in_code;
    wire [63:0] e_val_e;
    wire [3:0] D_in_fun;
    wire [3:0] E_src_b;
    wire [63:0] E_val_a;
    wire [3:0] e_dst_e; 
    wire e_cnd;
    wire [63:0] W_val_e;
    wire [63:0] W_val_m;    
    wire [1:0] m_stat;

    
    wire in_error;
    wire set_cc;

    fetch_pipe uut (
        .F_prediction_pc(F_prediction_pc),
        .D_ra(D_ra),
        .D_rb(D_rb),
        .M_val_a(M_val_a),
        .D_val_c(D_val_c),
        .M_cnd(M_cnd),
        .D_st(D_st),
        .D_val_p(D_val_p),
        .W_in_code(W_in_code),
        .D_in_code(D_in_code),
        .D_in_fun(D_in_fun),
        .W_val_m(W_val_m),
        .D_stat(D_stat),
        .F_st(F_st),
        .M_in_code(M_in_code),
        .clock(clock),
        .D_bub(D_bub),
        .f_prediction_pc(f_prediction_pc),
        .in_error(in_error)
    );

    exe dut2(
        .E_in_code(E_in_code),
        .E_in_fun(E_in_fun),
        .M_in_code(M_in_code),
        .M_dst_e(M_dst_e),
        .M_dst_m(M_dst_m),
        .e_dst_e(e_dst_e),
        .E_val_a(E_val_a),
        .E_val_b(E_val_b),
        .E_val_c(E_val_c),
        .M_val_e(M_val_e),
        .M_val_a(M_val_a),
        .e_val_e(e_val_e),
        .E_dst_e(E_dst_e),
        .E_dst_m(E_dst_m),
        .M_stat(M_stat),
        .E_stat(E_stat),
        .clock(clock),
        .set_cc(set_cc),
        .e_cnd(e_cnd),
        .M_cnd(M_cnd)
    );

    wb_pipe uut2(
        .W_dst_e(W_dst_e),
        .W_in_code(W_in_code),
        .W_dst_m(W_dst_m),
        .W_val_e(W_val_e),
        .W_val_m(W_val_m),
        .clock(clock)
    );

    memory_pipe uut4(
        .M_stat(M_stat),
        .W_dst_m(W_dst_m),
        .m_val_m(m_val_m),
        .M_dst_e(M_dst_e),
        .W_in_code(W_in_code),
        .W_stat(W_stat),
        .M_in_code(M_in_code),
        .W_val_m(W_val_m),
        .m_stat(m_stat),
        .M_dst_m(M_dst_m),
        .W_val_e(W_val_e),
        .M_cnd(M_cnd),
        .M_val_e(M_val_e),
        .M_val_a(M_val_a),
        .clock(clock),
        .W_dst_e(W_dst_e)
    );

    p_control uu3(
        .F_st(F_st),
        .e_cnd(e_cnd),
        .d_src_b(d_src_b),
        .M_in_code(M_in_code),
        .d_src_a(d_src_a),
        .set_cc(set_cc),
        .D_in_code(D_in_code),
        .D_st(D_st),
        .W_stat(W_stat),
        .D_bub(D_bub),
        .E_in_code(E_in_code),
        .E_dst_m(E_dst_m),
        .E_bub(E_bub),
        .m_stat(m_stat)
    );
    decode_proc dut(
        .D_in_fun(D_in_fun),
        .D_val_c(D_val_c),
        .D_in_code(D_in_code),
        .D_val_p(D_val_p),
        .W_dst_m(W_dst_m),
        .M_dst_e(M_dst_e),
        .M_dst_m(M_dst_m),
        .clock(clock),
        .E_bub(E_bub),
        .D_rb(D_rb),
        .D_ra(D_ra),
        .e_val_e(e_val_e),
        .M_val_e(M_val_e),
        .W_val_e(W_val_e),
        .e_dst_e(e_dst_e),
        .W_dst_e(W_dst_e),
        .D_stat(D_stat),
        .m_val_m(m_val_m),
        .W_val_m(W_val_m),
        .E_val_b(E_val_b),
        .E_val_a(E_val_a),
        .d_val_a(d_val_a),
        .E_val_c(E_val_c),
        .E_src_b(E_src_b),
        .E_in_code(E_in_code),
        .d_src_b(d_src_b),
        .E_dst_m(E_dst_m),
        .E_src_a(E_src_a),
        .E_in_fun(E_in_fun),
        .E_dst_e(E_dst_e),
        .E_stat(E_stat),
        .d_val_b(d_val_b),
        .d_src_a(d_src_a)
    );

    always@(W_stat) 
    begin
        stat = W_stat;
    end

    always@(stat)
    begin
        if(stat == 2'b10) begin
            $finish;
        end

		else if (stat == 2'b01) begin
			$finish;
		end

		else if (stat == 2'b11) begin
			$finish;
		end
    end

    always @(posedge clock) 
    begin
        if (F_st == 0) begin
        F_prediction_pc <= f_prediction_pc;
        end
    end

    always #15 clock = ~clock;

	initial begin
		clock = 0;
        F_prediction_pc = 64'd0;
    end

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0); 
    end

    initial begin
        $monitor($time, "\n\nclock=%d\n Fetch_Reg:\t F_predicted_PC = %g\n\t\tFETCH:\t f_predicted_PC = %g\n\t\tD_Reg:\t D_in_code = %b D_in_fun = %b D_ra = %b D_rb = %b D_val_c = %g D_val_p = %g D_stat = %g\n\t\tDECODE:\t\td_val_a = %g d_val_b = %g\n\t\tE_Reg:\t\tE_icode = %b E_in_fun = %b E_val_a = %g E_val_b = %g E_val_c = %g E_dst_e = %b E_dst_m = %b E_src_a = %g E_src_b = %g E_stat = %g\n\t\tEXECUTE:\te_cnd = %b e_val_e = %g\n\t\tMem_Reg:\t\tM_icode = %b M_cnd = %b M_val_a = %g M_val_e = %g M_dst_e = %b, M_dst_m = %b M_stat = %g\n\t\tMEMORY:\t\tm_valM = %g\n\t\tWb_Reg:\t\tWb_icode = %b Wb_val_e = %g Wb_val_m = %g Wb_dst_e = %b Wb_dst_m = %b Wb_stat = %g\n\t\tF_stall = %g D_st = %g D_bub = %g E_bub = %g set_cc = %g\n",clock,F_prediction_pc,f_prediction_pc,D_in_code,D_in_fun,D_ra,D_rb,D_val_c,D_val_p,D_stat,d_val_a,d_val_b,E_in_code,E_in_fun,E_val_a,E_val_b,E_val_c,E_dst_e,E_dst_m,E_src_a,E_src_b,E_stat,e_cnd,e_val_e,M_in_code,M_cnd,M_val_a,M_val_e,M_dst_e,M_dst_m,M_stat,m_val_m,W_in_code,W_val_e,W_val_m,W_dst_e,W_dst_m,W_stat,F_st,D_st,D_bub,E_bub,set_cc);
    end

endmodule