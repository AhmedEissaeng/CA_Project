module tb_data_read;

  wire [7:0] D;
  reg RD, WR, A0, CS;
  wire [1:0] ICW;
  wire [2:0] OCW;
  
  reg [7:0] data;
  // Instantiate the data_read module
  data_read uut (
    .D(D),
    .RD(RD),
    .WR(WR),
    .A0(A0),
    .CS(CS),
    .ICW(ICW),
    .OCW(OCW)
  );
  assign D = (!WR)? data : 8'bz;
  // Initial block for testbench
  initial begin
    // Initialize inputs
    data=8'b00000000;
    RD = 1;
    WR = 1;
    A0 = 0;
    CS = 1;

    // Wait for a few simulation time units
    #5;

    // Test case 1: ICW[0] set condition
    A0 = 0;
    data[4] = 1;
    #5;
    // turn on
    RD = 0;
    WR = 0;
    CS = 0;
    #5;
    
    
    // Test case 2: ICW[1] set condition
    A0 = 1;
    #5;

    // Test case 3: OCW[0] set condition
    

    // Test case 4: OCW[1] set condition
    A0 = 0;
    data[3] = 0; // Set specific condition for OCW[1]
    data[4] = 0;
    #5;

    // Test case 5: OCW[2] set condition
    A0 = 0;
    data[3] = 1; // Set specific condition for OCW[2]
    #5;

    // Add more test cases as needed

    // End simulation
    $finish;
  end

endmodule
