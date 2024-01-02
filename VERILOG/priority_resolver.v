
module priority_resolver(irr,isr,imr,F_P,ROTATE,highest_priority_int);
    input wire [7:0] irr;
    input wire [7:0] isr;
    input wire [7:0] imr;
    input F_P;
    input wire ROTATE;
    output reg [2:0] highest_priority_int ; // Output the interrupt vector
    
    //IMR im(.IMR_reg(imr));
    //IRR ir(.IRR_Reg(irr));
    //Control_logic control(.ROTATE(ROTATE),.F_P(F_P));
    reg [2:0] rotating_counter = 3'b000;
    
    integer i ;
    

    always @(posedge F_P) begin
        if (ROTATE) begin
            // Rotating priority logic:
             for (i = 0; i < 8; i = i + 1) begin
                if (irr[rotating_counter] & ~isr[rotating_counter] & ~imr[rotating_counter]) begin
                    highest_priority_int = rotating_counter;  // Output vector
                    i=8;
                end
                rotating_counter = rotating_counter + 1;
                if (rotating_counter == 8)  // Reset counter when it reaches maximum value
                    rotating_counter = 0;
            end
        end else begin
            // Fixed priority logic (prioritizing LSB):
            for ( i = 0; i < 8; i = i + 1) begin
                if (irr[i] & ~isr[i] & ~imr[i]) begin
                    highest_priority_int = i;  // Output vector
                    i=8;
                end
            end
        end

        // Increment rotating counter for next priority cycle
        //rotating_counter = rotating_counter + 1;

       
    end

endmodule