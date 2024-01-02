module ISR_tb;


  // input
  reg READ_IS, read, S_P, AEOI, SPECIFIC_EOI, NON_SPECIFIC_EOI;
  reg [4:0] V_A;
  reg [2:0] L123, highest_priority_int;
  reg selected_slave, SNGL;
  reg [7:0] IRR_slave;

  //output
  wire [7:0] ISR_reg, ISR_R;
  // Instantiate ISR module
  ISR uut (
    .READ_IS(READ_IS),
    .read(read),
    .ISR_reg(ISR_reg),
    .V_A(V_A),
    .S_P(S_P),
    .L123(L123),
    .SPECIFIC_EOI(SPECIFIC_EOI),
    .AEOI(AEOI),
    .highest_priority_int(highest_priority_int),
    .NON_SPECIFIC_EOI(NON_SPECIFIC_EOI),
    .ISR_R(ISR_R),
    .SNGL(SNGL),
    .selected_slave(selected_slave),
    .IRR_slave(IRR_slave)
  );


  // Initial block
  initial begin
    // Initialize inputs
    READ_IS = 0;
    read = 1;
    S_P = 0;
    AEOI = 1;
    SPECIFIC_EOI = 0;
    NON_SPECIFIC_EOI = 0;
    V_A = 0;
    L123 = 0;
    //cacade
    selected_slave = 0;
    SNGL = 0;
    IRR_slave = 0;

    // first test ISR_reg[0] ==>1
    highest_priority_int=0;
    // ISR_R==>00000000 
    #10 S_P = 1;
    #10 S_P = 0;
    
    // second test ISR_reg[5] ==>1
    #10 highest_priority_int=5;
    // ISR_R==>00000101 
    #20 S_P = 1;
    #10 S_P = 0;

    // third test ISR_reg[2] ==>1
    #10 highest_priority_int=2;
    // ISR_R==>00000010 
    #20 S_P = 1;
    #10 S_P = 0;
    
    // forth test READ_IS
    #10  read=1;
    #10  read=0;
    #10  read=1;
    #5 READ_IS=1; 
    #10  read=0;  
    #20 READ_IS=0;
    #10  read=1;
    #5 READ_IS=1;
    #10  read=0;    
    #10 READ_IS=0;
    // fifth test ISR_reg[7] ==>1
    #5 AEOI=0;
    #10 highest_priority_int=7;
    // ISR_R==>100000000 
    #20 S_P = 1;
    #10 S_P = 0;

    // now test specific EOI
    #10 L123 = 3'b010;
    #10 SPECIFIC_EOI = 1'b1;
    #10 SPECIFIC_EOI = 1'b0;
    #10 L123 = 3'b111;
    #10 SPECIFIC_EOI = 1'b1;
    #10 SPECIFIC_EOI = 1'b0;

    #10 highest_priority_int=3;
    // ISR_R==>000001000 
    #20 S_P = 1;
    #10 S_P = 0;
    // now test non-specific EOI
    #10  NON_SPECIFIC_EOI = 1'b1;
    #10 NON_SPECIFIC_EOI =1'b0;

    //test cascade pin
    #10 SNGL=1; selected_slave=0; IRR_slave=8'b11111111;
    #10 highest_priority_int=4;
    #20 S_P = 1;
    #10 S_P = 0;
    #10 selected_slave=1;
    #20 S_P = 1;
    #10 S_P = 0;
    // End simulation
    #10 $stop;
  end

endmodule


