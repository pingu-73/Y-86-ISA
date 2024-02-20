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
      memory_chunk[0]=8'b00110000; //3 0
    memory_chunk[1]=8'b00000000; //F rB=0
    memory_chunk[2]=8'b00000000;           
    memory_chunk[3]=8'b00000000;           
    memory_chunk[4]=8'b00000000;           
    memory_chunk[5]=8'b00000000;           
    memory_chunk[6]=8'b00000000;           
    memory_chunk[7]=8'b00000000;           
    memory_chunk[8]=8'b00000000;          
    memory_chunk[9]=8'b00000000; //V=0

    // irmovq $0x10, %rdx
    memory_chunk[10]=8'b00110000; //3 0
    memory_chunk[11]=8'b00000010; //F rB=2
    memory_chunk[12]=8'b00000000;           
    memory_chunk[13]=8'b00000000;           
    memory_chunk[14]=8'b00000000;           
    memory_chunk[15]=8'b00000000;           
    memory_chunk[16]=8'b00000000;           
    memory_chunk[17]=8'b00000000;           
    memory_chunk[18]=8'b00000000;          
    memory_chunk[19]=8'b00010000; //V=16

    // irmovq $0xc, %rbx
    memory_chunk[20]=8'b00110000; //3 0
    memory_chunk[21]=8'b00000011; //F rB=3
    memory_chunk[22]=8'b00000000;           
    memory_chunk[23]=8'b00000000;           
    memory_chunk[24]=8'b00000000;           
    memory_chunk[25]=8'b00000000;           
    memory_chunk[26]=8'b00000000;           
    memory_chunk[27]=8'b00000000;           
    memory_chunk[28]=8'b00000000;          
    memory_chunk[29]=8'b00001100; //V=12

    // jmp check
    memory_chunk[30]=8'b01110000; //7 fn
    memory_chunk[31]=8'b00000000; //Dest
    memory_chunk[32]=8'b00000000; //Dest
    memory_chunk[33]=8'b00000000; //Dest
    memory_chunk[34]=8'b00000000; //Dest
    memory_chunk[35]=8'b00000000; //Dest
    memory_chunk[36]=8'b00000000; //Dest
    memory_chunk[37]=8'b00000000; //Dest
    memory_chunk[38]=8'b00100111; //Dest=39

    // check:
        // addq %rax, %rbx 
        memory_chunk[39]=8'b01100000; //5 fn
        memory_chunk[40]=8'b00000011; //rA=0 rB=3
        // je rbxres  
        memory_chunk[41]=8'b01110011; //7 fn=3
        memory_chunk[42]=8'b00000000; //Dest
        memory_chunk[43]=8'b00000000; //Dest
        memory_chunk[44]=8'b00000000; //Dest
        memory_chunk[45]=8'b00000000; //Dest
        memory_chunk[46]=8'b00000000; //Dest
        memory_chunk[47]=8'b00000000; //Dest
        memory_chunk[48]=8'b00000000; //Dest
        memory_chunk[49]=8'b01111010; //Dest=122
        // addq %rax, %rdx
        memory_chunk[50]=8'b01100000; //5 fn
        memory_chunk[51]=8'b00000010; //rA=0 rB=2
        // je rdxres 
        memory_chunk[52]=8'b01110011; //7 fn=3
        memory_chunk[53]=8'b00000000; //Dest
        memory_chunk[54]=8'b00000000; //Dest
        memory_chunk[55]=8'b00000000; //Dest
        memory_chunk[56]=8'b00000000; //Dest
        memory_chunk[57]=8'b00000000; //Dest
        memory_chunk[58]=8'b00000000; //Dest
        memory_chunk[59]=8'b00000000; //Dest
        memory_chunk[60]=8'b01111101; //Dest=125
        // jmp loop2 
        memory_chunk[61]=8'b01110000; //7 fn=0
        memory_chunk[62]=8'b00000000; //Dest
        memory_chunk[63]=8'b00000000; //Dest
        memory_chunk[64]=8'b00000000; //Dest
        memory_chunk[65]=8'b00000000; //Dest
        memory_chunk[66]=8'b00000000; //Dest
        memory_chunk[67]=8'b00000000; //Dest
        memory_chunk[68]=8'b00000000; //Dest
        memory_chunk[69]=8'b01000110; //Dest

        // halt
        memory_chunk[70]=8'b00000000;  
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
             memory_chunk[p_ctr],memory_chunk[p_ctr+1],
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
                 val_c=instruction_arr[16:79];
                 val_p=p_ctr+64'd10;
                 rb=instruction_arr[12:15];
                 flag_halt=0;
               end
               if(in_code==4'd4)
               begin
                  ra=instruction_arr[8:11];
                  val_c=instruction_arr[16:79];
                  val_p=p_ctr+64'd10;
                  rb=instruction_arr[12:15];
                  flag_halt=0;
               end
                 if(in_code==4'd5)
               begin
                  ra=instruction_arr[8:11];
                  val_c=instruction_arr[16:79];
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
                 val_c=instruction_arr[8:71];
                 flag_halt=0;
               end
                 if(in_code==4'd8)
               begin
                  val_c=instruction_arr[8:71];
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