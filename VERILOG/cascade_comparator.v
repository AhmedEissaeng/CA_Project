module cascade_comparator(SP_EN,ISR,ICW3,INTA_FIRST_PULSE,INTA_SECOND_PULSE,CAS0, CAS1, CAS2,selected_slave,IRR_slave);
  input wire SP_EN;
  input [7:0] ISR;
  input [7:0] ICW3;
  input wire INTA_FIRST_PULSE;
  input wire INTA_SECOND_PULSE;
  inout CAS0, CAS1, CAS2;
  output reg selected_slave;
  output reg [7:0] IRR_slave;
  
  reg [2:0] slave_ID;
  reg [2:0] sender_ID;

  always @(ICW3 or SP_EN)
      begin
        if (SP_EN)
        begin
          // Master mode
          IRR_slave <= ICW3;
        end
        else if (!SP_EN)
        begin
          // Slave mode
          slave_ID[0]<=ICW3[0];
          slave_ID[1]<=ICW3[1];
          slave_ID[2]<=ICW3[2];
        end
      end


  always @(ISR) begin
      if (SP_EN)
      begin
        // Master mode
        if(ISR[0]==1'b1)
          sender_ID<= 3'b000;
        else if(ISR[1]==1'b1)
          sender_ID<= 3'b001;
        else if(ISR[2]==1'b1)
          sender_ID<= 3'b010;
        else if(ISR[3]==1'b1)
          sender_ID<= 3'b011;
        else if(ISR[4]==1'b1)
          sender_ID<= 3'b100;
        else if(ISR[5]==1'b1)
          sender_ID<= 3'b101;
        else if(ISR[6]==1'b1)
          sender_ID<= 3'b110;
        else if(ISR[7]==1'b1)
          sender_ID<= 3'b111;
        else
          sender_ID<= 3'bzzz;
      end
      //ISR have no need in slave mode
    end

  // IN MASTER MODE 
  assign CAS0 = SP_EN ? (INTA_FIRST_PULSE ? sender_ID[0] : (INTA_SECOND_PULSE ? sender_ID[0] : 1'bx)) : 1'bz;
  assign CAS1 = SP_EN ? (INTA_FIRST_PULSE ? sender_ID[1] : (INTA_SECOND_PULSE ? sender_ID[1] : 1'bx)) : 1'bz;
  assign CAS2 = SP_EN ? (INTA_FIRST_PULSE ? sender_ID[2] : (INTA_SECOND_PULSE ? sender_ID[2] : 1'bx)) : 1'bz;
  
  
  
  
  always @(INTA_SECOND_PULSE) begin
    if (SP_EN)
    begin
      // Master mode
    end
    else if (!SP_EN)
    begin
        if (CAS0 == slave_ID[0] && CAS1 == slave_ID[1] && CAS2 == slave_ID[2])
          selected_slave <= 1'b1;
        else
          selected_slave <= 1'b0;
    end
  end
endmodule
