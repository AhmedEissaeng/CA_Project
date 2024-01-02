module read_write(Data_in,WR,CS,RD,A0,ICW1,ICW2,ICW3,ICW4,OCW1,OCW2,OCW3);
  
  input WR,CS,RD,A0;
  
  output reg [7:0]ICW1,ICW2,ICW3,ICW4,OCW1,OCW2,OCW3;
  
  reg SNGL,IC4,OCW;
  
  input [7:0]Data_in;
  
  reg [1:0] state;
  
  //Data_Buffer D0(.Data(Data_in),.WR(WR),.CS(CS));
  
  always @(negedge WR) begin 
       if(A0==0 && Data_in[4]==1)begin
        OCW<=0;
        ICW1<=Data_in;
          state<=2'b01;
          if(Data_in[0]==1) begin 
            IC4<=1;
          end
          if(Data_in[1]==0) begin 
            SNGL<=0;
          end
       end                                  
      else if(state==2'b01 && OCW==0) begin
          if(A0==1) begin 
            ICW2<=Data_in ; 
          end
            if(SNGL==0) begin
              state<=2'b10;
            end
            else if(IC4==1) begin 
              state<=2'b11;
            end
            else 
            begin
              OCW<=1;
            end
          end
      else if(state==2'b10 && OCW==0) begin
          if(A0==1) begin 
            ICW3<=Data_in ;
          end
          if (IC4==1) begin 
              state<=2'b11;
          end
          else
           begin 
              OCW<=1;
            end 
          end
      else if(state==2'b11 && OCW==0) begin
          if(A0==1 && Data_in[7:5]==3'b000) begin 
            ICW4<=Data_in ;
            OCW<=1;
          end
        end
  end
  always @(negedge WR) begin 
    if(OCW) begin
      case(A0)
        1'b0:
        begin
          if(Data_in[4:3]==2'b00) begin
            OCW2<=Data_in;
          end
          else if(Data_in[4:3]==2'b01 && Data_in[7]==0) begin
            OCW3<=Data_in;
          end 
        end
        1'b1:OCW1<=Data_in;
      endcase
    end
 end
endmodule