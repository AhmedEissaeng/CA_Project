`timescale 1ns/1ns

module read_write_tb;

  reg WR, CS, RD, A0;
  reg [7:0] Data_in;
  wire [7:0] ICW1, ICW2, ICW3, ICW4, OCW1, OCW2, OCW3;

  // Instantiate the module
  read_write uut (
    .Data_in(Data_in),
    .WR(WR),
    .CS(CS),
    .RD(RD),
    .A0(A0),
    .ICW1(ICW1),
    .ICW2(ICW2),
    .ICW3(ICW3),
    .ICW4(ICW4),
    .OCW1(OCW1),
    .OCW2(OCW2),
    .OCW3(OCW3)
  );

  // Initial values
  initial begin
    WR = 1;
    CS = 1;
    RD = 1;
    A0 = 0;
    Data_in = 8'b00000000;

    // Testcase 1
    #10;
    Data_in = 8'b11010101; // Your test data
    WR = 0;
    CS = 0;
    A0 = 0;
    
    #10;
    WR = 1;
    
    #10;
    Data_in = 8'b11101000; // Your test data
    WR = 0;
    CS = 0;
    A0 = 1;
    
    #10;
    WR = 1;
    
    #10;
    Data_in = 8'b00001011; // Your test data
    WR = 0;
    CS = 0;
    A0 = 1;
    
    #10;
    WR = 1;
    
    #10;
    Data_in = 8'b00000000; // Your test data
    WR = 0;
    CS = 0;
    A0 = 1;
    #10;
    WR = 1;
    #10;
    Data_in = 8'b00011111; // Your test data
    WR = 0;
    CS = 0;
    A0 = 1;
    #10;
    WR = 1;
    #10
    Data_in = 8'b11100000; // Your test data
    WR = 0;
    CS = 0;
    A0 = 0;
    #10;
    WR = 1;
    #10
    Data_in = 8'b01101000; // Your test data
    WR = 0;
    CS = 0;
    A0 = 0;
    #10;
    WR = 1;
    #100;
    // Add further test cases as needed

    $stop; // Stop simulation
  end

  // Monitor outputs
  always @(negedge WR) begin
    $display("ICW1=%h ICW2=%h ICW3=%h ICW4=%h OCW1=%h OCW2=%h OCW3=%h",
             ICW1, ICW2, ICW3, ICW4, OCW1, OCW2, OCW3);
  end

endmodule