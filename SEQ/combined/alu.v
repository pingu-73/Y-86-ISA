module add_sub(A, B, Cin, Control, S, Co);
    input A, B, Cin, Control;

    output S, Co;

    wire a_xor_b, a_and_b, and2, ctrl;

    xor(ctrl, Control, B);
    
    xor(a_xor_b, A, ctrl);
    xor(S, a_xor_b, Cin);
    and(a_and_b, A, ctrl);
    and(and2, a_xor_b, Cin);
    or(Co, a_and_b, and2);
endmodule

module XOR_operation (
  input [63:0] val1_xor,
  input [63:0] val2_xor,
  output [63:0] result_xor
//   output [63:0] additional_check
);
  genvar iterator_xor;

 
     generate for (iterator_xor = 0; iterator_xor <= 63; iterator_xor = iterator_xor + 1) begin
      xor(result_xor[iterator_xor], val1_xor[iterator_xor], val2_xor[iterator_xor]);
    end
  endgenerate

  
//   assign additional_check = val1_xor ^ val2_xor;
  
endmodule

module AND_operation (
  input [63:0] val1,
  input [63:0] val2,
  output [63:0] result
//   output [63:0] additional_check
);
  genvar iterator_and;


    generate  for (iterator_and = 0; iterator_and <= 63; iterator_and = iterator_and + 1) begin
      and(result[iterator_and], val1[iterator_and], val2[iterator_and]);
    end
  endgenerate

  
//   assign additional_check = val1 & val2;
  
endmodule

module sum(A, B, Control, S, Co);

    input [63:0] A, B;
    input Control;

    output [63:0] S;
    output Co;

    wire [64:0] Cin;
    assign Cin[0] = Control;
    
    genvar i;
    generate for(i = 0; i <= 63; i = i+1)
        begin
            add_sub x1(A[i], B[i], Cin[i], Control, S[i], Cin[i+1]);
        end
    endgenerate
    
    xor(Co, Cin[64], Cin[63]);
    
endmodule


// ============================= ALU Implementation=======================================


module ALU(A, B, Control, Result, flag);

    input [63:0] A, B;
    input [1:0] Control;

    output reg [63:0] Result;
    output wire [2:0] flag;

    wire [63:0] and_result, xor_result, add_result, sub_result;
    wire Cout_1, Cout_2;
    reg V; //overflow
    reg N; //Negitive flag

    AND_operation x1(A, B, and_result);
    XOR_operation x2(A, B, xor_result);
    sum x3(A, B, 1'b0, add_result, Cout_1);
    sum x4(A, B, 1'b1, sub_result, Cout_2);

    always @*
    begin
        if(Control == 2'b00)
        begin
            Result = add_result;
            V = Cout_1;
        end
        else if(Control == 2'b01)
        begin
            Result = sub_result;
            V = Cout_2;
        end
        else if(Control == 2'b10)
        begin
            Result = and_result;
            V = 1'b0;
        end
        else if(Control == 2'b11)
        begin
            Result = xor_result;
            V = 1'b0;
        end
        N = Result[63];
    end
    assign flag[0] = V; //overflow flag
    assign flag[1] = (N==1); //negative flag
    assign flag[2] = (Result==64'b0); //zero flag
endmodule