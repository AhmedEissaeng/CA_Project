module ISR(READ_IS,read,ISR_reg,V_A,S_P,L123,SPECIFIC_EOI,AEOI,highest_priority_int,NON_SPECIFIC_EOI,ISR_R,SNGL,selected_slave,IRR_slave);
  input READ_IS,read,S_P,AEOI,SPECIFIC_EOI,NON_SPECIFIC_EOI;
  input [4:0]V_A;
  input [2:0]L123;
  input [2:0] highest_priority_int; //get it from priority resolver to handle NON_SPECIFIC_EOI_COMMAND
  output reg [7:0]ISR_reg=0;
  output reg [7:0]ISR_R;
  reg [2:0]sender_ID;
  reg [1:0]counter=0;
  //for cascade 
  input selected_slave,SNGL; // selected_slave from cascade and SNGL from control unit
  input [7:0] IRR_slave; //from cascade 
  
  //Control_logic control(.READ_IS(READ_IS),.S_P(S_P),.V_A(V_A),.AEOI(AEOI),.SPECIFIC_EOI(SPECIFIC_EOI),.L123(L123),.NON_SPECIFIC_EOI(NON_SPECIFIC_EOI));
  //priority_resolver p(.highest_priority_int(highest_priority_int));
  //Data_Buffer buffer(.RD(read),.Data(ISR_R));
  
   always @(negedge read) begin
      if (counter == 2'b01) begin 
        if(READ_IS==1)
          ISR_R<=ISR_reg;
        counter <= 2'b00;
      end
      else
      counter <= counter + 1; // Increment the counter
   end

   
   always@(highest_priority_int) begin
    ISR_reg[highest_priority_int]<=1;
   end
   always@(ISR_reg) begin 
        if(ISR_reg[0]==1'b1)
          sender_ID<= 3'b000;
        else if(ISR_reg[1]==1'b1)
          sender_ID<= 3'b001;
        else if(ISR_reg[2]==1'b1)
          sender_ID<= 3'b010;
        else if(ISR_reg[3]==1'b1)
          sender_ID<= 3'b011;
        else if(ISR_reg[4]==1'b1)
          sender_ID<= 3'b100;
        else if(ISR_reg[5]==1'b1)
          sender_ID<= 3'b101;
        else if(ISR_reg[6]==1'b1)
          sender_ID<= 3'b110;
        else if(ISR_reg[7]==1'b1)
          sender_ID<= 3'b111;
        else
          sender_ID<= 3'bzzz;

   end  
   
   always@(posedge S_P) begin 
        if(SNGL && IRR_slave[highest_priority_int]==1) begin
          if(selected_slave==1)
            ISR_R<={V_A,sender_ID};
        end
        else
          ISR_R<={V_A,sender_ID};
        if(AEOI) begin
          if(sender_ID== 3'b000)
            ISR_reg[0]<=0;
          else if(sender_ID== 3'b001)
            ISR_reg[1]<=0;
          else if(sender_ID== 3'b010)
            ISR_reg[2]<=0;
          else if(sender_ID== 3'b011)
            ISR_reg[3]<=0;
          else if(sender_ID== 3'b100)
            ISR_reg[4]<=0;
          else if(sender_ID== 3'b101)
            ISR_reg[5]<=0;
          else if(sender_ID== 3'b110)
            ISR_reg[6]<=0;
          else if(sender_ID== 3'b111)
           ISR_reg[7]<=0;
        end     
          
   end 
   always@(posedge SPECIFIC_EOI)begin 
      case(L123)
        3'b000:ISR_reg[0]<=0;
        3'b001:ISR_reg[1]<=0;
        3'b010:ISR_reg[2]<=0;
        3'b011:ISR_reg[3]<=0;
        3'b100:ISR_reg[4]<=0;
        3'b101:ISR_reg[5]<=0;
        3'b110:ISR_reg[6]<=0;
        3'b111:ISR_reg[7]<=0;
      endcase 
    end 
    always@(posedge NON_SPECIFIC_EOI) begin
      ISR_reg[highest_priority_int]<=0;
    end
  
  endmodule