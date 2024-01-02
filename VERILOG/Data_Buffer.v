module Data_Buffer(D0,D1,D2,D3,D4,D5,D6,D7,Data,WR,RD,CS);
  
  input WR,RD,CS;
  
  input D0,D1,D2,D3,D4,D5,D6,D7;
  
  output reg[7:0]Data;
  
  //assign Data = ((~WR & ~CS) ==1) ? {D7,D6,D5,D4,D3,D2,D1,D0}:0;
  always@(negedge WR) begin
      if(CS==0) begin
        Data <= {D7,D6,D5,D4,D3,D2,D1,D0};
      end
    else
      Data <= Data; 
  end
  
 
endmodule
