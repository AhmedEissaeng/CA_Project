module priority_resolver_tb;

  reg [7:0] irr;
  reg [7:0] isr;
  reg [7:0] imr;
  reg F_P;
  reg ROTATE;
  wire [2:0] highest_priority_int;

  priority_resolver dut(.irr(irr), .isr(isr), .imr(imr), .F_P(F_P), .ROTATE(ROTATE), .highest_priority_int(highest_priority_int));

  initial begin
    // Test cases for rotating priority logic:
    // Test Case 1
    irr = 8'b00000101;
    isr = 8'b10000000;
    imr = 8'b00000000;
    F_P = 1;
    ROTATE = 1;
    #5; // Delay for simulation
   

    // Test Case 2
    irr = 8'b01100000;
    isr = 8'b00000000;
    imr = 8'b00100000;
    F_P = 1;
    ROTATE = 1;
    #5; // Delay for simulation
   

    // Test cases for fixed priority logic:
    // Test Case 3
    irr = 8'b00011000;
    isr = 8'b00000000;
    imr = 8'b00001000;
    F_P = 0;
    ROTATE = 0;
    #5; // Delay for simulation
    

    // Test Case 4
    irr = 8'b10000010;
    isr = 8'b01000000;
    imr = 8'b00000000;
    F_P = 0;
    ROTATE = 0;
    #5; // Delay for simulation
    

    // Edge cases:
    // Test Case 5
    irr = 8'b00000000;
    isr = 8'b00000000;
    imr = 8'b11111111;
    F_P = 0;
    ROTATE = 1;
    #5; // Delay for simulation
    

    // Test Case 6
    irr = 8'b11111111;
    isr = 8'b11111111;
    imr = 8'b00000000;
    F_P = 1;
    ROTATE = 0;
    #5; // Delay for simulation
   

    $stop;
  end

endmodule
