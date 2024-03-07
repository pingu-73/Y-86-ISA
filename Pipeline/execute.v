`include "alu.v"
module exe(
    input [3:0] E_in_code, E_in_fun,
	output reg [3:0] M_in_code, M_dst_e, M_dst_m, e_dst_e,
    input [63:0] E_val_a, E_val_b, E_val_c,
	output reg [63:0] M_val_e, M_val_a, e_val_e,
    input [3:0] E_dst_e, E_dst_m,
	output reg [1:0] M_stat,
	input [1:0] E_stat,
	input clock, set_cc,
    output reg e_cnd, M_cnd
);
	reg [63:0] val_b;
	reg signed [63:0] val_e;
	reg signed cnd;
	reg  V;
	wire signed [63:0] result;
    reg zroFlag;
    reg execute_flag;
    reg [63:0] val_a;
    reg [1:0] ctrl;
	reg signed [63:0] B;
    reg execute_finish;
    reg [3:0] in_fun;
	wire [2:0] cond;
    reg N;
    reg [2:0] cndsn_code;
    reg [63:0] val_c;
    reg signed [63:0] A;
    reg [3:0] in_code;
    initial begin 
        N=0;
        cndsn_code = 3'd0;
        execute_flag=1;
		cnd = 1'b0;
    end
	initial begin
		execute_finish=0;
		zroFlag = 0;
        V=0;
         val_e = 64'd0;
	end
	
	always @(*) begin
        V = 0;
        execute_flag=0;
        	N = 0;
		val_c = E_val_c;
	end
 
    always@(*) 
    begin
        e_cnd = cnd;
        val_a = E_val_a;
         e_dst_e = E_dst_e;
        e_val_e = val_e;
    end
 
	always @(*) begin
		in_code = E_in_code;
        V = cndsn_code[0];
		zroFlag = cndsn_code[2];
        in_fun = E_in_fun;
		N = cndsn_code[1];
        val_b = E_val_b;
	end
 
	
	ALU dut(A, B, ctrl, result, cond);
 
	always @(*) begin
		case(in_code)
			4'd10: val_e = -64'd1 + val_b;
            4'd5: val_e = val_c + val_b;
			4'd2:
			begin
				val_e = val_a;
				case(in_fun)
                    4'd4: cnd = ~zroFlag;
					4'd1: cnd = ((N^V)| zroFlag);
					4'd2: cnd = (N^V);
					4'd5: cnd = ~(N^V);
                    4'd0: cnd = 1;
					4'd6: cnd = ((~(N^V))&~zroFlag);
					4'd3: cnd = zroFlag;
				endcase
					if (e_cnd) 
					begin  
						e_dst_e = E_dst_e;
					end 
					else 
					begin 
						e_dst_e = 4'd15;
					end
				
			end
            4'd9: val_e = 64'd1 + val_b;
            4'd4: val_e = val_c + val_b;
			4'd6: 
			begin
				A = val_b; 
				B = val_a;
				case(in_fun)
                    4'b0011: ctrl = 2'b11;
					4'b0001: ctrl = 2'b01;
                    4'b0000: ctrl = 2'b00;
                    4'b0010: ctrl = 2'b10;
				endcase
				val_e = result;
				if(set_cc == 1) begin
					cndsn_code = cond;
				end
			end
            4'd3: val_e = val_c;
			4'd7:
			begin
				case(in_fun)
                    4'd3: cnd = zroFlag;
                    4'd4: cnd = ~zroFlag;
                    4'd6: cnd = ((~(N^V))&~zroFlag);
					4'd0: cnd = 1;
					4'd2: cnd = (N^V);
					4'd5: cnd = ~(N^V);
                    4'd1: cnd = ((N^V) | zroFlag);
				endcase
				if(e_cnd) begin
					e_dst_e = E_dst_e;
				end
				else begin
					e_dst_e = 4'd15;
				end
			end
			4'd11: val_e = 64'd1 + val_b;
            4'd8: val_e = -64'd1 + val_b;
		endcase
	end
 
	always@(posedge clock) begin
		M_stat <= E_stat;
		M_in_code <= E_in_code;
                execute_flag<=1;
		M_cnd <= e_cnd;
		M_val_e <= e_val_e;
                execute_finish<=1;
		M_val_a <= E_val_a;
		M_dst_e <= e_dst_e;
		M_dst_m <= E_dst_m;
	end
endmodule
