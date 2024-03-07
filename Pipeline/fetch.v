module fetch_pipe(
input [63:0] F_prediction_pc,
output reg [3:0] D_ra,
output reg [3:0] D_rb,
input [63:0] M_val_a,
output reg [63:0] D_val_c,
input M_cnd,
input D_st,
output reg [63:0] D_val_p,
input [3:0] W_in_code,
output reg [3:0] D_in_code,
output reg [3:0] D_in_fun,
input [63:0] W_val_m,
output reg [1:0] D_stat, //terminator
input F_st,
input [3:0] M_in_code,
input clock,
input D_bub,
output reg [63:0] f_prediction_pc,
output reg in_error
);
reg [1:0] stat;
reg [3:0] rb;
reg [3:0] in_fun;
reg [63:0] val_c;
reg [3:0] ra;
reg mem_error_fetch;
reg [7:0] mem_data_chunk [0:4095];
reg [3:0] in_code;
reg [63:0] val_p;
reg [63:0] p_ctr;
reg [0:79] instruction_arr; 
reg [63:0] holder;

initial 
begin
   $readmemb("i.txt",mem_data_chunk,0,22);
end
initial begin
   stat=2'b00;
   mem_error_fetch=0;
   in_error=0;
end
initial begin
    rb=4'd15;
    ra=4'd15;
end
initial begin
   val_p=64'd0;
   val_c=64'd0;
end
always@(*) 
begin
    if(W_in_code==4'd9)
    begin
        holder=W_val_m;
        p_ctr=holder;
    end
    else if(M_in_code==4'd7)
    begin
        if(M_cnd==1'b0) 
        begin
            holder=M_val_a;
            p_ctr=holder;
        end
    end
    else
    begin
        holder=F_prediction_pc;
        p_ctr=holder;
    end
end
always@(*)
begin
    if(p_ctr<0 | p_ctr>64'd4095)
        begin
            stat=2'b10;
            mem_error_fetch=1'b1;
        end
        else
        begin
             instruction_arr={
             mem_data_chunk[p_ctr],  mem_data_chunk[p_ctr+1],
             mem_data_chunk[p_ctr+2],mem_data_chunk[p_ctr+3],
             mem_data_chunk[p_ctr+4],mem_data_chunk[p_ctr+5],
             mem_data_chunk[p_ctr+6],mem_data_chunk[p_ctr+7],
             mem_data_chunk[p_ctr+8],mem_data_chunk[p_ctr+9]
             };
              in_fun=instruction_arr[4:7];
            in_code=instruction_arr[0:3];
            // if(in_error==0)
            // begin
               if(in_code==4'd0)
               begin
                val_p=p_ctr+64'd1;
                stat=2'b01;
                f_prediction_pc=p_ctr+64'd1;
               end       
               else if(in_code==4'd1)
               begin
                 val_p=p_ctr+64'd1;
                  f_prediction_pc=p_ctr+64'd1;
               end
               else if(in_code==4'd2)
               begin
                 ra=instruction_arr[8:11];
                 val_p=p_ctr+64'd2;
                 rb=instruction_arr[12:15];
                 f_prediction_pc=p_ctr+64'd2;
               end
              
               else if(in_code==4'd4)
               begin
                  ra=instruction_arr[8:11];
                  f_prediction_pc=p_ctr+64'd10;
                  val_c={instruction_arr[72:79],instruction_arr[64:71],
                  instruction_arr[56:63],instruction_arr[48:55],
                  instruction_arr[40:47],instruction_arr[32:39],
                  instruction_arr[24:31],instruction_arr[16:23]};
                  val_p=p_ctr+64'd10;
                  rb=instruction_arr[12:15];
               end
               else if(in_code==4'd10)
               begin
                  f_prediction_pc=p_ctr+64'd2;
                  ra=instruction_arr[8:11];
                  val_p=p_ctr+64'd2;
                  rb=instruction_arr[12:15];
               end
                 else if(in_code==4'd5)
               begin
                  ra=instruction_arr[8:11];
                  f_prediction_pc=p_ctr+64'd10;
                  val_c={instruction_arr[72:79],instruction_arr[64:71],
                  instruction_arr[56:63],instruction_arr[48:55],
                  instruction_arr[40:47],instruction_arr[32:39],
                  instruction_arr[24:31],instruction_arr[16:23]};
                  val_p=p_ctr+64'd10;
                  rb=instruction_arr[12:15];
               end
                else if(in_code==4'd3)
               begin
                 ra=instruction_arr[8:11];
                    f_prediction_pc=p_ctr+64'd10;
                 val_c={instruction_arr[72:79],instruction_arr[64:71],
                  instruction_arr[56:63],instruction_arr[48:55],
                  instruction_arr[40:47],instruction_arr[32:39],
                  instruction_arr[24:31],instruction_arr[16:23]};
                 val_p=p_ctr+64'd10;
                 rb=instruction_arr[12:15];
               end
                 else if(in_code==4'd6)
               begin
                  f_prediction_pc=p_ctr+64'd2;
                  ra=instruction_arr[8:11];
                  //val_c=instruction_arr[16:79];
                  val_p=p_ctr+64'd2;
                  rb=instruction_arr[12:15];
               end
              
                 else if(in_code==4'd8)
               begin
                  
                  val_c={instruction_arr[64:71],
                  instruction_arr[56:63],instruction_arr[48:55],
                  instruction_arr[40:47],instruction_arr[32:39],
                  instruction_arr[24:31],instruction_arr[16:23],instruction_arr[8:15]};
                  f_prediction_pc=val_c;
                  val_p=p_ctr+64'd9;
               end
                else if(in_code==4'd9)
               begin
                  f_prediction_pc=p_ctr+64'd1;
                  val_p=p_ctr+64'd1;
               end
                  else if(in_code==4'd7)
               begin
                 f_prediction_pc=p_ctr+64'd9;
               val_c={instruction_arr[64:71],
                  instruction_arr[56:63],instruction_arr[48:55],
                  instruction_arr[40:47],instruction_arr[32:39],
                  instruction_arr[24:31],instruction_arr[16:23],instruction_arr[8:15]};
                  val_p=p_ctr+64'd9;
               end
               else if(in_code==4'd11)
               begin
                  f_prediction_pc=p_ctr+64'd2;
                  rb=instruction_arr[12:15];
                  val_p=p_ctr+64'd2;
                  ra=instruction_arr[8:11];
               end
               else
               begin
                  in_error=1;
               end
        end
end
always@(posedge clock) begin
    if(D_st!=1 & D_bub!=1)
    begin
      D_val_c<=val_c;
        D_rb<=rb;
        D_stat<=stat;
        D_in_code<=in_code;
        D_ra<=ra;
        D_val_p<=val_p;
        D_in_fun<=in_fun;
    end
    if(D_bub==1'b1)
    begin
         D_val_c<=64'd0;
        D_rb<=4'd0;
        D_stat<=2'd0;
        D_in_code<=4'd1;
        D_ra<=4'd0;
        D_val_p<=64'd0;
        D_in_fun<=4'd0;
    end
end
 
endmodule