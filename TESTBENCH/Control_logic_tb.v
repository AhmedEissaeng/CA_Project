`timescale 1ns / 1ns

module test_Control_logic;

  // Define the size of time steps
  parameter TIME_STEP = 10;

  // Inputs
  reg INTA;
  reg [7:0] IRR, ICW1, ICW2, ICW3, ICW4, OCW1, OCW2, OCW3;
  reg [7:0] IMR_reg;

  // Outputs
  wire INT, F_P, S_P, SNGL, LTIM, AEOI;
  wire [4:0] V_A;
  wire [7:0] OCW_1;
  wire NON_SPECIFIC_EOI, SPECIFIC_EOI, READ_IR, READ_IS, ROTATE;
  wire [2:0] L123;

  // Instantiate the module
  Control_logic dut (
    .INTA(INTA),
    .IRR(IRR),
    .ICW1(ICW1),
    .ICW2(ICW2),
    .ICW3(ICW3),
    .ICW4(ICW4),
    .OCW1(OCW1),
    .OCW2(OCW2),
    .OCW3(OCW3),
    .INT(INT),
    .F_P(F_P),
    .S_P(S_P),
    .SNGL(SNGL),
    .LTIM(LTIM),
    .V_A(V_A),
    .AEOI(AEOI),
    .OCW_1(OCW_1),
    .NON_SPECIFIC_EOI(NON_SPECIFIC_EOI),
    .SPECIFIC_EOI(SPECIFIC_EOI),
    .READ_IR(READ_IR),
    .READ_IS(READ_IS),
    .ROTATE(ROTATE),
    .L123(L123),
    .IMR_reg(IMR_reg)
  );

  // Initial block for test stimulus
  initial begin
    // Initialize inputs
    INTA = 1;
    IRR = 8'b00000000;
    ICW1 = 8'b00000000;
    ICW2 = 8'b00000000;
    ICW3 = 8'b00000000;
    ICW4 = 8'b00000000;
    OCW1 = 8'b00000000;
    OCW2 = 8'b00000000;
    OCW3 = 8'b00000000;
    IMR_reg = 8'b00000000;

    // test case 1: no ICW4 or ICW3, LTIM = 1 , non specific EOI , second pulse after 10 units of first pulse
    #TIME_STEP;
    IRR = 8'b01010101; 
    ICW1 = 8'b00011010; 
    ICW2 = 8'b10101000; 
    ICW3 = 8'b00000000; 
    ICW4 = 8'b00000000; 
    OCW1 = 8'b00000111; 
    OCW2 = 8'b00100000; 
    OCW3 = 8'b00001000; 
    IMR_reg = 8'b00011010;

    #5;
    INTA = 0; 
    #5;
    INTA = 1;
    #5;
    INTA = 0;


    // Monitor outputs
    #TIME_STEP;
    $display("INT: %b, F_P: %b, S_P: %b, SNGL: %b, LTIM: %b", INT, F_P, S_P, SNGL, LTIM);
    $display("V_A: %b, AEOI: %b, OCW_1: %b", V_A, AEOI, OCW_1);
    $display("NON_SPECIFIC_EOI: %b, SPECIFIC_EOI: %b, READ_IR: %b, READ_IS: %b, ROTATE: %b, L123: %b", NON_SPECIFIC_EOI, SPECIFIC_EOI, READ_IR, READ_IS, ROTATE, L123);


    // test case 2: no ICW4 or ICW3, LTIM = 1 , non specific EOI , mask interrupt to make no interrupt 
    #TIME_STEP;
    IRR = 8'b00000011; 
    ICW1 = 8'b00011010; 
    ICW2 = 8'b10101000; 
    ICW3 = 8'b00000000; 
    ICW4 = 8'b00000000; 
    OCW1 = 8'b00000111; 
    OCW2 = 8'b00100000; 
    OCW3 = 8'b00001000; 
    IMR_reg = 8'b00000111;

    


    // Monitor outputs
    #TIME_STEP;
    $display("INT: %b, F_P: %b, S_P: %b, SNGL: %b, LTIM: %b", INT, F_P, S_P, SNGL, LTIM);
    $display("V_A: %b, AEOI: %b, OCW_1: %b", V_A, AEOI, OCW_1);
    $display("NON_SPECIFIC_EOI: %b, SPECIFIC_EOI: %b, READ_IR: %b, READ_IS: %b, ROTATE: %b, L123: %b", NON_SPECIFIC_EOI, SPECIFIC_EOI, READ_IR, READ_IS, 
    ROTATE, L123);


    // test case 3: no  ICW3, LTIM = 1 , icw4 with AEOI , second pulse after 10 units of first pulse
    #TIME_STEP;
    IRR = 8'b01010101; 
    ICW1 = 8'b00011011; 
    ICW2 = 8'b10101000; 
    ICW3 = 8'b00000000; 
    ICW4 = 8'b00000010; 
    OCW1 = 8'b00000111; 
    OCW2 = 8'b00100000; 
    OCW3 = 8'b00001000; 
    IMR_reg = 8'b00011010;

    #5;
    INTA = 0; 
    #5;
    INTA = 1;
    #5;
    INTA = 0;



    // End simulation
    #200;
    $finish;
  end

endmodule

