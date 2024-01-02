module IMR(OCW_1,IMR_reg);
  
  input [7:0]OCW_1 ;
  
  output reg [7:0] IMR_reg;
  
  //Control_logic control(.OCW_1(OCW_1));
  
  always@(OCW_1) begin
    IMR_reg<=OCW_1;
    
  end
endmodule
