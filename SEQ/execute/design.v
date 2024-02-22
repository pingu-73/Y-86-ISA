`include "alu.v"

module exe(
    input [3:0] in_code, in_fun,
    input [63:0] val_a, val_b, val_c,
	input clock,

    output reg [63:0] val_e,
    output reg cnd
);
    reg [2:0] cndsn_code;
    reg zroFlag, N, V;


	wire [2:0] cond;
    wire signed [63:0]ans;
    
    reg [1:0] ctrl;
	reg signed [63:0] A, B;


	initial begin
		cndsn_code = 3'd0;
        zroFlag = 0;
        N = 0;
        V = 0;
	end

    always@(*)
    begin 
		if (clock == 1) begin
			V = cond[0];
			N = cond[1];
			zroFlag = cond[2];
		end
    end

    ALU uut(A, B, ctrl, ans, cond);

	initial begin
        val_e = 64'd0;
        cnd = 1'b0; 
    end

    always @(*)
	begin
		if(clock == 1)
		begin
			case(in_code)
				4'd2:
				begin
					val_e = val_a;
					case(in_fun)
						4'd0: cnd = 1;
						4'd1: cnd = ((N^V)| zroFlag);
						4'd2: cnd = (N^V);
						4'd5: cnd = ~(N^V);
						4'd6: cnd = ((~(N^V))&~zroFlag);
						4'd3: cnd = zroFlag;
						4'd4: cnd = ~zroFlag;
					endcase
				end
				4'd7:
				begin
					case(in_fun)
						4'd0: cnd = 1;
						4'd5: cnd = ~(N^V);
						4'd1: cnd = ((N^V)| zroFlag);
						4'd2: cnd = (N^V);
						4'd3: cnd = zroFlag;
						4'd6: cnd = ((~(N^V))&~zroFlag);
						4'd4: cnd = ~zroFlag;
					endcase
				end
				4'd3: val_e = val_c;
				4'd4: val_e = val_c+val_b;
				4'd6:
				begin
					A = val_b;
					B = val_a;
					case(in_fun)
						4'b0000: ctrl = 2'b00;
						4'b0001: ctrl = 2'b01;
						4'b0010: ctrl = 2'b10;
						default: ctrl = 2'b11;
					endcase
					val_e = ans;
					cndsn_code = cond;
				end
				4'd5: val_e = val_c+val_b;
				4'd8: val_e = -64'd1+val_b;
				4'd9: val_e = 64'd1+val_b;
				4'd10: val_e = -64'd1+val_b;
				4'd11: val_e = 64'd1+val_b;
			endcase
		end
	end
endmodule
