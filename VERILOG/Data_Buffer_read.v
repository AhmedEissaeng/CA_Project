module Data_Buffer_read(D0,D1,D2,D3,D4,D5,D6,D7,Data_out,WR,RD,CS);
  input WR,RD,CS;
  
  output reg D0,D1,D2,D3,D4,D5,D6,D7;
  
  input [7:0]Data_out;
  always@(negedge RD) begin
      if(CS==0) begin
        D0<=Data_out[0];
        D1<=Data_out[1];
        D2<=Data_out[2];
        D3<=Data_out[3];
        D4<=Data_out[4];
        D5<=Data_out[5];
        D6<=Data_out[6];
        D7<=Data_out[7];
      end
    else begin 
      D0<=D0;
      D1<=D1;
      D2<=D2;
      D3<=D3;
      D4<=D4;
      D5<=D5;
      D6<=D6;
      D7<=D7;
    end
  end
endmodule
