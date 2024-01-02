module PIC (
    input IR0, IR1, IR2, IR3, IR4, IR5, IR6, IR7, INTA, A0, RD, WR, CS,
    inout CAS0, CAS1, CAS2, SP_EN, 
    input D0, D1, D2, D3, D4, D5, D6, D7,
    output D0_, D1_, D2_, D3_, D4_, D5_, D6_, D7_,
    output INT
);

    wire [7:0]  IRR_Reg, ISR_Reg, ICW1, ICW2, ICW3, ICW4, OCW1, OCW2, OCW3, OCW_1, IMR_reg,IRR_slave;
    wire READ_IR, READ_IS, F_P, S_P, SNGL, LTIM, ROTATE, AEOI, NON_SPECIFIC_EOI, SPECIFIC_EOI,selected_slave;
    wire [2:0] highest_priority_int, L123;
    wire [4:0] V_A;
    reg [7:0]bus_write;
    wire [7:0]bus_read;

    Data_Buffer data (
        .D0(D0), .D1(D1), .D2(D2), .D3(D3), .D4(D4), .D5(D5), .D6(D6), .D7(D7),
        .Data(bus_read), .WR(WR), .RD(RD), .CS(CS)
    );
    
    Data_Buffer_read data_read(.D0(D0_), .D1(D1_), .D2(D2_), .D3(D3_), .D4(D4_), .D5(D5_), .D6(D6_), .D7(D7_),.Data_out(bus_write),.WR(WR), .RD(RD), .CS(CS));

    read_write rw (
        .Data_in(bus_read), .WR(WR), .CS(CS), .RD(RD), .A0(A0),
        .ICW1(ICW1), .ICW2(ICW2), .ICW3(ICW3), .ICW4(ICW4),
        .OCW1(OCW1), .OCW2(OCW2), .OCW3(OCW3)
    );

    Control_logic control (
        .INTA(INTA), .IRR(IRR_Reg), .ICW1(ICW1), .ICW2(ICW2), .ICW3(ICW3),
        .ICW4(ICW4), .OCW1(OCW1), .OCW2(OCW2), .OCW3(OCW3), .INT(INT),
        .F_P(F_P), .S_P(S_P), .SNGL(SNGL), .LTIM(LTIM), .ROTATE(ROTATE),
        .V_A(V_A), .AEOI(AEOI), .OCW_1(OCW_1), .NON_SPECIFIC_EOI(NON_SPECIFIC_EOI),
        .SPECIFIC_EOI(SPECIFIC_EOI), .READ_IR(READ_IR), .READ_IS(READ_IS),
        .L123(L123), .IMR_reg(IMR_reg)
    );

    IRR IR (
        .IR0(IR0), .IR1(IR1), .IR2(IR2), .IR3(IR3), .IR4(IR4), .IR5(IR5),
        .IR6(IR6), .IR7(IR7), .LTIM(LTIM), .IRR_Reg(IRR_Reg), 
        .highest_priority_int(highest_priority_int)
    );

    ISR isr (
        .READ_IS(READ_IS), .read(RD), .ISR_reg(ISR_Reg), .V_A(V_A),
        .S_P(S_P), .L123(L123), .SPECIFIC_EOI(SPECIFIC_EOI),
        .AEOI(AEOI), .highest_priority_int(highest_priority_int),
        .NON_SPECIFIC_EOI(NON_SPECIFIC_EOI),.selected_slave(selected_slave), 
        .IRR_slave(IRR_slave),.SNGL(SNGL)
    );

    IMR imr (
        .OCW_1(OCW_1), .IMR_reg(IMR_reg)
    );

    priority_resolver p (
        .irr(IRR_Reg), .isr(ISR_Reg), .imr(IMR_reg), .F_P(F_P),
        .ROTATE(ROTATE), .highest_priority_int(highest_priority_int)
    );

    cascade_comparator cascade (
        .SP_EN(SP_EN), .ISR(ISR_Reg), .ICW3(ICW3), .INTA_FIRST_PULSE(F_P),
        .INTA_SECOND_PULSE(S_P), .CAS0(CAS0), .CAS1(CAS1), .CAS2(CAS2),
        .selected_slave(selected_slave), .IRR_slave(IRR_slave)
    );

  always @(posedge READ_IR or posedge READ_IS or posedge S_P) begin
        if (READ_IR) 
            bus_write <= IRR_Reg;
        else if (READ_IS)
           bus_write <= ISR_Reg;
    end

endmodule
