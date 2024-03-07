module decode_proc(
    input [3:0] D_in_fun,
    input [63:0] D_val_c,
    input [3:0] D_in_code,
    input [63:0] D_val_p,
    input [3:0] W_dst_m,
    input [3:0] M_dst_e,
    input [3:0] M_dst_m,
    input clock,
    input E_bub,
    input [3:0] D_rb,
    input [3:0] D_ra,
    input [63:0] e_val_e,
    input [63:0] M_val_e,
    input[63:0] W_val_e,
    input [3:0] e_dst_e,
    input [3:0] W_dst_e,
    input [1:0] D_stat,
    input [63:0] m_val_m,
    input [63:0] W_val_m,
    output reg [63:0] E_val_b,
    output reg [63:0] E_val_a,
    output reg [63:0] d_val_a,
    output reg [63:0] E_val_c,
    output reg [3:0] E_src_b,
    output reg [3:0] E_in_code,
    output reg [3:0] d_src_b,
    output reg [3:0] E_dst_m,
    output reg [3:0] E_src_a,
    output reg [3:0] E_in_fun,
    output reg [3:0] E_dst_e,
    output reg [1:0] E_stat,
    output reg [63:0] d_val_b,
    output reg [3:0] d_src_a
);

reg [3:0] dst_e, dst_m;
reg [63:0] reg_chunk [0:14];

always @(posedge clock)
begin
    $readmemh("common.txt",reg_chunk);
end

always@(*) 
begin
    case(D_in_code)
        4'd2: 
        begin
            d_src_b = 4'd15;
            dst_m = 4'd15;
            d_src_a = D_ra;
            dst_e = D_rb;
            d_val_a = reg_chunk[D_ra];
        end
        4'd3:
        begin
            d_src_b = 4'd15;
            dst_e = D_rb;
            d_src_a = 4'd15;
            dst_m = 4'd15;
        end
        4'd5:
        begin
            d_src_b = D_rb;
            dst_e = 4'd15;
            dst_m = D_ra;
            d_src_a = 4'd15;
            d_val_b = reg_chunk[D_rb];
        end
        4'd6:
        begin
            d_src_b = D_rb;
            dst_e = D_rb;
            dst_m = 4'd15;
            d_src_a = D_ra;
            d_val_a = reg_chunk[D_ra];
            d_val_b = reg_chunk[D_rb];
        end
        4'd11:
        begin
            dst_m = D_ra;
            dst_e = 4'd4;
            d_src_b = 4'd4;
            d_src_a = 4'd4;
            d_val_b = reg_chunk[4'd4];
            d_val_a = reg_chunk[4'd4];
        end
        4'd8:
        begin
            d_src_a = 4'd15;
            dst_m = 4'd15;
            dst_e = 4'd4;
            d_src_b = 4'd4;
            d_val_b = reg_chunk[4'd4];
        end
        4'd4:
        begin
            dst_e = D_rb;
            d_src_a = D_ra;
            d_src_b = 4'd15;
            dst_m = 4'd15;
            d_val_b = reg_chunk[D_rb];
            d_val_a = reg_chunk[D_ra];
        end
        4'd9:
        begin
            d_src_b = 4'd4;
            d_src_a = 4'd4;
            dst_m = 4'd15;
            dst_e = 4'd4;
            d_val_a = reg_chunk[4'd4];
            d_val_b = reg_chunk[4'd4];
        end
        4'd10:
        begin
            dst_m = 4'd15;
            d_src_a = D_ra;
            d_src_b = 4'd4;
            dst_e = 4'd4;
            d_val_a = reg_chunk[D_ra];
            d_val_b = reg_chunk[4'd4];
        end

        default:    //REMOVEABLE
        begin
            d_src_a = 4'd15;
            d_src_b = 4'd15;
            dst_e = 4'd15;
            dst_m = 4'd15;
        end
    endcase
end
    always@(*)
    begin
            if(d_src_b == e_dst_e)
            begin
                if(d_src_b != 4'd15) begin
                d_val_b = e_val_e;
                end
            end
            if(d_src_b == M_dst_m)
            begin
                if(d_src_b != 4'd15) begin
                    d_val_b = m_val_m;
                end
            end
            if(d_src_b == M_dst_e)
            begin
                if(d_src_b != 4'd15) begin
                    d_val_b = M_val_e;
                end
            end
            if(d_src_b == W_dst_m)
            begin
                if (d_src_b!=4'd15) begin
                    d_val_b = W_val_m; 
                end
            end
            if(d_src_b == W_dst_e)
            begin
                if (d_src_b != 4'd15) begin
                    d_val_b = W_val_e;
                end
            end

    end

    always@(*)
    begin
        if (d_src_a == W_dst_e)
        begin
            if(d_src_a != 4'd15) begin
                d_val_a = W_val_e;
            end
        end
        
        if (d_src_a == M_dst_m)
        begin
            if(d_src_a != 4'd15) begin
                d_val_a = m_val_m;
            end
        end

        if(D_in_code == 4'd8 || D_in_code == 4'd7)
        begin
            d_val_a = D_val_p;
        end

        if (d_src_a == e_dst_e)
        begin
            if(d_src_a != 4'd15) begin
                d_val_a = e_val_e;
            end
        end
        
        if (d_src_a == M_dst_e)
        begin
            if(d_src_a != 4'd15) begin
                d_val_a = M_val_e;
            end
        end
        if (d_src_a == W_dst_m)
        begin
            if(d_src_a != 4'd15) begin
                d_val_a = W_val_m;
            end
        end
    end

    always@(posedge clock)
    begin
        if (E_bub != 1)
        begin
            E_src_a <= d_src_a;
            E_src_b <= d_src_b;
            E_in_code <= D_in_code; 
            E_in_fun <= D_in_fun;
            E_dst_e <= dst_e;
            E_val_a <= d_val_a;
            E_val_b <= d_val_b;
            E_val_c <= D_val_c;
            E_stat <= D_stat;
            E_dst_m <= dst_m;
        end
        if(E_bub == 1)
        begin
            E_stat <= 2'd0;
            E_in_code <= 4'b0001;
            E_in_fun <= 4'b0000;
            E_dst_e <= 4'd15;
            E_dst_m <= 4'd15;
            E_val_a <= 4'b0000;
            E_src_b <= 4'd15;
            E_val_b <= 4'b0000;
            E_val_c <= 4'b0000;
            E_src_a <= 4'd15;
        end
    end
endmodule