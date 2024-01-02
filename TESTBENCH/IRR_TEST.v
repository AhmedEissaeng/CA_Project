`timescale 1ns / 1ns

module test_IRR;

  reg IR0, IR1, IR2, IR3, IR4, IR5, IR6, IR7, LTIM;
  wire [7:0] IRR_Reg;
  reg [2:0] highest_priority_int;
  

  // Instantiate the module under test
  IRR UUT (
    .IR0(IR0),
    .IR1(IR1),
    .IR2(IR2),
    .IR3(IR3),
    .IR4(IR4),
    .IR5(IR5),
    .IR6(IR6),
    .IR7(IR7),
    .LTIM(LTIM),
    .IRR_Reg(IRR_Reg),
    .highest_priority_int(highest_priority_int)
  );

  // Initial stimulus
  initial begin
    // Apply some stimulus
    IR0 = 0; IR1 = 0; IR2 = 0; IR3 = 0; IR4 = 0; IR5 = 0; IR6 = 0; IR7 = 0; LTIM = 0; highest_priority_int = 0;

    // Test case 1: Edge-triggered with LTIM=0
    LTIM = 0;
    IR0 = 1; #5; IR0 = 0; // Simulate rising edge on IR0
    #10;

    $display("LTIM = %b, IR[7:0] = %b, IRR_Reg = %b", LTIM, {IR7, IR6, IR5, IR4, IR3, IR2, IR1, IR0}, IRR_Reg);

    // Test case 2: Level-triggered with LTIM=1
    LTIM = 1;
    IR1 = 1; #5; IR2 = 1; // Simulate level-triggered with IR1 and IR2 high
    #10;

    // Test case 3: edge-triggered with LTIM=1

    IR0 = 1; IR1 = 1; IR2 = 1; IR3 = 1; IR4 = 1; IR5 = 1; IR6 = 1; IR7 = 1; LTIM = 1;
    #10;

    LTIM = 0;
    IR1 = 0; #5; IR2 = 0; // Simulate level-triggered with IR1 and IR2 low
    #10;

    $display("LTIM = %b, IR[7:0] = %b, IRR_Reg = %b", LTIM, {IR7, IR6, IR5, IR4, IR3, IR2, IR1, IR0}, IRR_Reg);

    // Add more test cases as needed

    // Finish simulation
    $finish;
  end

endmodule
