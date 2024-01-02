module IRR(IR0,IR1,IR2,IR3,IR4,IR5,IR6,IR7, LTIM, IRR_Reg,highest_priority_int);

	output reg [7:0] IRR_Reg;
	input IR0,IR1,IR2,IR3,IR4,IR5,IR6,IR7,LTIM;
	input [2:0] highest_priority_int;
	
	
	//Data_Buffer d(.Data(IRR_R));
	//Control_logic control(.LTIM(LTIM),.READ_IR(READ_IR));
  //priority_resolver p(.highest_priority_int(highest_priority_int));
  
  
  always @(highest_priority_int) begin
    IRR_Reg[highest_priority_int]<=0;
  end
  
	//edge triggered 
	always @(posedge IR0 or posedge IR1 or posedge IR2 or posedge IR3 or posedge IR4 or posedge IR5 or posedge IR6 or posedge IR7) begin
		if(!LTIM) begin
			IRR_Reg <= {IR7, IR6, IR5, IR4, IR3, IR2, IR1, IR0};
		end
	end

	//level triggered
	always @(IR0 or IR1 or IR2 or IR3 or IR4 or IR5 or IR6 or IR7) begin
		if(LTIM) begin
			IRR_Reg <= {IR7, IR6, IR5, IR4, IR3, IR2, IR1, IR0};
		end
	end	

endmodule

