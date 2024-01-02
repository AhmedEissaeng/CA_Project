module cascade_comparator_tb;


  reg INTA_FIRST_PULSE;
  reg INTA_SECOND_PULSE;
  
  // Inputs master
  reg M_SP_EN;
  reg [7:0] M_ISR;
  reg [7:0] M_ICW3;
  // Inouts
  wire M_CAS0, M_CAS1, M_CAS2;

  // Inputs slave
  reg SP_EN;
  reg [7:0] ICW3,ICW3_slave_2;

  // Outputs
  wire selected_slave1,selected_slave2;
  
// Instantiate the module master 
  cascade_comparator master (
    .SP_EN(M_SP_EN),
    .ISR(M_ISR),
    .ICW3(M_ICW3),
    .INTA_FIRST_PULSE(INTA_FIRST_PULSE),
    .INTA_SECOND_PULSE(INTA_SECOND_PULSE),
    .CAS0(M_CAS0),
    .CAS1(M_CAS1),
    .CAS2(M_CAS2)
  );


  // Instantiate the module slave 
  cascade_comparator slave1 (
    .SP_EN(SP_EN),
    .ICW3(ICW3),
    .INTA_FIRST_PULSE(INTA_FIRST_PULSE),
    .INTA_SECOND_PULSE(INTA_SECOND_PULSE),
    .CAS0(M_CAS0),
    .CAS1(M_CAS1),
    .CAS2(M_CAS2),
    .selected_slave(selected_slave1)
  );

  // Instantiate the module slave 
  cascade_comparator slave2 (
    .SP_EN(SP_EN),
    .ICW3(ICW3_slave_2),
    .INTA_FIRST_PULSE(INTA_FIRST_PULSE),
    .INTA_SECOND_PULSE(INTA_SECOND_PULSE),
    .CAS0(M_CAS0),
    .CAS1(M_CAS1),
    .CAS2(M_CAS2),
    .selected_slave(selected_slave2)
  );

  // Initial stimulus
  initial begin
    // Initialize inputs
    SP_EN = 0;   //slave
    M_SP_EN = 1; //master
    M_ISR = 8'b00000000;    //input determine which PIC slave have the INT (can see the result in (CAS_REG))
    M_ICW3 = 8'b00001001;   //for master there it  PIC slave in pin IR0 and IR3  
    ICW3 = 8'b00000001;   //for master there it only PIC slave in pin IR0  (the first slave have id ==>001)
    ICW3_slave_2 = 8'b00000111;     //for slave to set id to this slave    (the second slave have id ==>111)
    INTA_FIRST_PULSE=0;
    INTA_SECOND_PULSE=0;
    
    //
    #10 M_ISR = 8'b00000100; // Simulate ISR[2] being active
    #10 INTA_FIRST_PULSE=1;     INTA_SECOND_PULSE=0;   //first pulse
    
    #20 INTA_FIRST_PULSE=0;     INTA_SECOND_PULSE=1;   //second pulse
    
    // 
    #10 M_ISR = 8'b00000010; // Simulate ISR[1] being active
    #10INTA_FIRST_PULSE=1;     INTA_SECOND_PULSE=0;   //first pulse
     
    #10INTA_FIRST_PULSE=0;     INTA_SECOND_PULSE=1;   //second pulse
    
    #10INTA_FIRST_PULSE=0;     INTA_SECOND_PULSE=0;
    
    #10 M_ISR = 8'b00100000; // Simulate ISR[5] being active
    #10INTA_FIRST_PULSE=1;     INTA_SECOND_PULSE=0;   //first pulse
     
    #10INTA_FIRST_PULSE=0;     INTA_SECOND_PULSE=1;   //second pulse

    
    #10 M_ISR = 8'b10000000; // Simulate ISR[7] being active
    #10INTA_FIRST_PULSE=1;     INTA_SECOND_PULSE=0;   //first pulse
     
    #10INTA_FIRST_PULSE=0;     INTA_SECOND_PULSE=1;   //second pulse
    
    #10INTA_FIRST_PULSE=0;     INTA_SECOND_PULSE=0;

    #30$stop; // Finish simulation after some time
  end
  

endmodule



