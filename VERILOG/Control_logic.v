module Control_logic(INTA,IRR,ICW1,ICW2,ICW3,ICW4,OCW1,OCW2,OCW3,INT,F_P,S_P,SNGL,LTIM,ROTATE,V_A,AEOI,OCW_1,NON_SPECIFIC_EOI,SPECIFIC_EOI,READ_IR,READ_IS,L123,IMR_reg);
  
  input INTA;
  input [7:0]IRR,ICW1,ICW2,ICW3,ICW4,OCW1,OCW2,OCW3;
  wire IC4;
  output INT,F_P,S_P,SNGL,LTIM;
  output reg AEOI;
  output reg [4:0]V_A;
  output reg [7:0]OCW_1;
  output reg NON_SPECIFIC_EOI,SPECIFIC_EOI,READ_IR,READ_IS,ROTATE;
  output reg [2:0]L123;
  input [7:0] IMR_reg;
  
  reg MPM;
  reg [1:0] counter;
  

  parameter  NON_SPECIFIC_EOI_COMMAND =3'b001;
  parameter  SPECIFIC_EOI_COMMAND =3'b011;
  parameter  ROTATE_ON_NON_SPECIFIC_EOI_COMMAND=3'b101;
  parameter  ROTATE_IN_AUTOMATIC_EOI_SET=3'b100;
  parameter  ROTATE_IN_AUTOMATIC_EOI_MODE_CLEAR=3'b000;
  
  //IMR imr(.IMR_reg(IMR_reg));

  assign INT = ((IRR & ~IMR_reg) == 8'b00000000) || (S_P) ? 0:1;
  assign S_P = counter==2 ?   1:0;
  assign F_P = counter==1 ?   1:0;
  assign SNGL = ICW1[1];
  assign LTIM = ICW1[3]; 
  assign LTIM = ICW1[3]; 
  assign IC4 = ICW1[0];
  
  //read_write W0(.ICW1(ICW1),.ICW2(ICW2),.ICW3(ICW3),.ICW4(ICW4),.OCW1(OCW1),.OCW2(OCW2),.OCW3(OCW3),.OCW(OCW));   
  
  always @(negedge INTA) begin 
    
    if(counter==2)
      counter<=1;

    else if(counter==1) begin
      counter<=2;
    end
       
    else if(counter!==1 && counter!==2) begin
      counter<=1;
    end
end 

always @(ICW1) begin
    
    counter = 0;
  end
  

  always @(ICW2) begin
    
    V_A=ICW2[7:3];
  end
    
  always @(ICW4) begin
    
    if(IC4) begin
      AEOI<=ICW4[1];
      MPM<=ICW4[0];
    end
    else begin
      AEOI<=0;
    end  
   end
    
    always @(OCW1) begin
      OCW_1<=OCW1;
    end
      
    always @(OCW2) begin
      if(~AEOI) begin
       case(OCW2[7:5])
         NON_SPECIFIC_EOI_COMMAND: 
         begin
            NON_SPECIFIC_EOI<=1;
            SPECIFIC_EOI<=0; 
            ROTATE<=0;
            AEOI<=0;
            L123<=0;
          end
         SPECIFIC_EOI_COMMAND: 
         begin  
            SPECIFIC_EOI<=1;
            L123<=OCW2[2:0];  
            ROTATE<=0;
            AEOI<=0;
          end
         ROTATE_ON_NON_SPECIFIC_EOI_COMMAND:
         begin
            NON_SPECIFIC_EOI<=1;
            SPECIFIC_EOI<=0; 
            ROTATE<=1;
            AEOI<=0;
            L123<=0;
          end
         ROTATE_IN_AUTOMATIC_EOI_SET: 
         begin
            NON_SPECIFIC_EOI<=0;
            SPECIFIC_EOI<=0;
            AEOI<=1; 
            ROTATE<=0;
            L123<=0;
          end
          default:  
          begin
            NON_SPECIFIC_EOI<=0;
            SPECIFIC_EOI<=0;
            AEOI<=1; 
            ROTATE<=0;
            L123<=0;
          end
          endcase
        end
        end
    always@(OCW3) begin 
        if(OCW3[1:0]==2'b11)begin
          READ_IS<=1;
          READ_IR<=0;
        end
        else if(OCW3[1:0]==2'b10) begin
           READ_IR<=1;
           READ_IS<=0;
         end
        else begin
          READ_IS<=0;
          READ_IR<=0;
        end 
              
    end
endmodule
