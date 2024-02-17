module fetch_seq(
   input [63:0] p_ctr,
   input clock,
   output reg [3:0] in_code,
   output reg [3:0] in_fun,
   output reg [3:0] rb,
   output reg [3:0] ra,
   output reg flag_halt,
   output reg [63:0] val_c,
   output reg [63:0] val_p,
   output reg bad_mem,
   output reg in_error
    );
    reg[0:79] instruction_arr; 
    reg [7:0] memory_chunk[0:1023];
    initial begin
      flag_halt=0;
       rb=4'd15;
       in_code=4'd0;
      ra=4'd15;
    end
    initial begin
      bad_mem=0;
      in_error=0;
    end
    initial 
    begin
        val_p=64'd0;
        in_fun=4'd0;
        val_c=64'd0;
    end
   initial 
   begin
    $readmemb("i.txt",memory_chunk,0,21);
   end
        always@(posedge clock)
        begin
        if(p_ctr>64'd1023)
        begin
            bad_mem=1'd1;
        end
        else
        begin
             instruction_arr={
             memory_chunk[p_ctr],  memory_chunk[p_ctr+1],
             memory_chunk[p_ctr+2],memory_chunk[p_ctr+3],
             memory_chunk[p_ctr+4],memory_chunk[p_ctr+5],
             memory_chunk[p_ctr+6],memory_chunk[p_ctr+7],
             memory_chunk[p_ctr+8],memory_chunk[p_ctr+9]
             };
              in_fun=instruction_arr[4:7];
            in_code=instruction_arr[0:3];
            if(in_code>4'd11)
            begin
                in_error=1'd1;
            end
            if(in_code<4'd0)
            begin
                in_error=1'd1;
            end
            if(in_error==0)
            begin
               if(in_code==4'd0)
               begin
                val_p=p_ctr+64'd1;
                flag_halt=1;
               end       
               if(in_code==4'd1)
               begin
                 val_p=p_ctr+64'd1;
                 flag_halt=0;
               end
               if(in_code==4'd2)
               begin
                 ra=instruction_arr[8:11];
                 val_p=p_ctr+64'd2;
                 rb=instruction_arr[12:15];
                 flag_halt=0;
               end
               if(in_code==4'd3)
               begin
                 ra=instruction_arr[8:11];
                 val_c={instruction_arr[72:79],instruction_arr[64:71],
                  instruction_arr[56:63],instruction_arr[48:55],
                  instruction_arr[40:47],instruction_arr[32:39],
                  instruction_arr[24:31],instruction_arr[16:23]};
                 val_p=p_ctr+64'd10;
                 rb=instruction_arr[12:15];
                 flag_halt=0;
               end
               if(in_code==4'd4)
               begin
                  ra=instruction_arr[8:11];
                  val_c={instruction_arr[72:79],instruction_arr[64:71],
                  instruction_arr[56:63],instruction_arr[48:55],
                  instruction_arr[40:47],instruction_arr[32:39],
                  instruction_arr[24:31],instruction_arr[16:23]};
                  val_p=p_ctr+64'd10;
                  rb=instruction_arr[12:15];
                  flag_halt=0;
               end
                 if(in_code==4'd5)
               begin
                  ra=instruction_arr[8:11];
                  val_c={instruction_arr[72:79],instruction_arr[64:71],
                  instruction_arr[56:63],instruction_arr[48:55],
                  instruction_arr[40:47],instruction_arr[32:39],
                  instruction_arr[24:31],instruction_arr[16:23]};
                  val_p=p_ctr+64'd10;
                  rb=instruction_arr[12:15];
                  flag_halt=0;
               end
                 if(in_code==4'd6)
               begin
                  ra=instruction_arr[8:11];
                  //val_c=instruction_arr[16:79];
                  val_p=p_ctr+64'd2;
                  rb=instruction_arr[12:15];
                  flag_halt=0;
               end
                 if(in_code==4'd7)
               begin
                 val_p=p_ctr+64'd9;
               val_c={instruction_arr[64:71],
                  instruction_arr[56:63],instruction_arr[48:55],
                  instruction_arr[40:47],instruction_arr[32:39],
                  instruction_arr[24:31],instruction_arr[16:23],instruction_arr[8:15]};
                 flag_halt=0;
               end
                 if(in_code==4'd8)
               begin
                      val_c={instruction_arr[64:71],
                  instruction_arr[56:63],instruction_arr[48:55],
                  instruction_arr[40:47],instruction_arr[32:39],
                  instruction_arr[24:31],instruction_arr[16:23],instruction_arr[8:15]};
                  val_p=p_ctr+64'd9;
                  flag_halt=0;
               end
                if(in_code==4'd9)
               begin
                  val_p=p_ctr+64'd1;
                  flag_halt=0;
               end
               if(in_code==4'd10)
               begin
                  ra=instruction_arr[8:11];
                  val_p=p_ctr+64'd2;
                  rb=instruction_arr[12:15];
                  flag_halt=0;
               end
               if(in_code==4'd11)
               begin
                  ra=instruction_arr[8:11];
                  val_p=p_ctr+64'd2;
                  rb=instruction_arr[12:15];
                  flag_halt=0;
               end

            end
        end
        end
endmodule