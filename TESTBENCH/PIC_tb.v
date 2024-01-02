
module PIC_tb;

  // Signals
  reg IR0, IR1, IR2, IR3, IR4, IR5, IR6, IR7, INTA, A0, RD, WR, CS,D0, D1, D2, D3, D4, D5, D6, D7;
  wire D0_, D1_, D2_, D3_, D4_, D5_, D6_, D7_;
  wire CAS0, CAS1, CAS2, SP_EN ;
  wire INT;

  //reg T_CAS0, T_CAS1, T_CAS2, T_SP_EN ,T_D0, T_D1, T_D2, T_D3, T_D4, T_D5, T_D6, T_D7;
  
  
  // Instantiate the module
  PIC uut(
    .IR0(IR0), .IR1(IR1), .IR2(IR2), .IR3(IR3), .IR4(IR4), .IR5(IR5), .IR6(IR6), .IR7(IR7),
    .INTA(INTA), .A0(A0), .RD(RD), .WR(WR), .CS(CS),
    .CAS0(CAS0), .CAS1(CAS1), .CAS2(CAS2), .SP_EN(SP_EN),
    .D0(D0), .D1(D1), .D2(D2), .D3(D3), .D4(D4), .D5(D5), .D6(D6), .D7(D7),
    .D0_(D0_), .D1_(D1_), .D2_(D2_), .D3_(D3_), .D4_(D4_), .D5_(D5_), .D6_(D6_), .D7_(D7_),
    .INT(INT)
  );
  
  

  initial begin
    // Initialize inputs
    IR0 = 0; IR1 = 0; IR2 = 0; IR3 = 0; IR4 = 0; IR5 = 0; IR6 = 0; IR7 = 0;
    INTA = 1; A0 = 0; RD = 1; WR = 1; CS = 1;
    D0=0;   D1=0;     D2=0;   D3=0; 	 D4=0;   D5=0;     D6=0;   D7=0;
    #10 
    A0=0;
    D4=1;
    WR=0;  //get data in
    CS=0;
    D0=1;   D1=0;     D2=0;   D3=0; 	    D5=1;     D6=1;   D7=1; //icw1
    #10
    WR=1;
    #10 
    WR=0;
    A0=0;
    D4=1;
    D0=1;   D1=1;     D2=1;   D3=1; 	    D5=1;     D6=1;   D7=1; 
    #10
    WR=1;
    #10
    A0=1;
    WR=0;
    D4=0;
    D0=0;   D1=0;     D2=0;   D3=0; 	    D5=0;     D6=1;   D7=1;
    #10
    WR=1;
    #10
    WR=0;
    
    D4=0;
    D0=0;   D1=0;     D2=1;   D3=0; 	    D5=0;     D6=0;   D7=0; //icw4
    #10
    WR=1;
    #10
    A0=1;
    WR=0;
    
    D4=0;
    D0=0;   D1=0;     D2=0;   D3=0; 	    D5=0;     D6=0;   D7=0;
    #10
    WR=1;
    #10
    A0=1;
    WR=0;
   
    D4=0;
    D0=0;   D1=1;     D2=1;   D3=0; 	    D5=1;     D6=0;   D7=1; //ocw2
    #10
    WR=1;
    #10
    A0=0;
    WR=0;
    
    D4=0;
    D0=1;   D1=1;     D2=1;   D3=1; 	    D5=0;     D6=1;   D7=0; //ocw3
    #10
    WR=1;
    #10
    A0=0;
    WR=0;
    
    IR0=1;  IR1=1;  IR2=1; IR7=1;
    #20
    INTA=0;
    #10
    INTA=1;
    #10
    INTA=0;
    #10
    
    INTA=1;
    #10
    INTA=0;
    #10
    
    INTA=1;
    #10
    INTA=0;
    #10
    
    INTA=1;
    #10
    INTA=0;
    #10
    INTA=1;   WR=1;
    #10
    INTA=0;
    #10
    RD=0;
    #100
     
    
    

    // Apply stimulus
    // Add your test cases here

    // Monitor outputs
    $monitor("Time=%0t IR0=%b IR1=%b IR2=%b IR3=%b IR4=%b IR5=%b IR6=%b IR7=%b INT=%b", $time, IR0, IR1, IR2, IR3, IR4, IR5, IR6, IR7, INT);
  end
  
endmodule
