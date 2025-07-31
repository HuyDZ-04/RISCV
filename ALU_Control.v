module ALU_Control(        
    input [2:0] funct3,         
    input [6:0]funct7,        
    input [1:0] ALUOp,          
    output reg [3:0] ALUcontrol_Out 
);
always @(*) begin
  case ({ALUOp, funct7, funct3})
    12'b10_0000000_000 : ALUcontrol_Out <= 4'b0000;    // ADD 
    12'b00_0000000_000 : ALUcontrol_Out <= 4'b0000;    // ADD 
    12'b00_0000000_001 : ALUcontrol_Out <= 4'b0000;    // ADD 
    12'b00_0000000_010 : ALUcontrol_Out <= 4'b0000;    // ADD 
    12'b10_0100000_000 : ALUcontrol_Out <= 4'b0001;    // SUB 
    12'b10_0000000_111 : ALUcontrol_Out <= 4'b0010;    // AND
    12'b10_0000000_110 : ALUcontrol_Out <= 4'b0011;    // OR
    12'b10_0000000_100 : ALUcontrol_Out <= 4'b0100;    // XOR
    12'b10_0000000_001 : ALUcontrol_Out <= 4'b0101;    // SLL
    12'b10_0000000_101 : ALUcontrol_Out <= 4'b0110;    // SRL
    12'b10_0100000_101 : ALUcontrol_Out <= 4'b0111;    // SRA
    12'b10_0000000_010 : ALUcontrol_Out <= 4'b1000;    // SLT
    default            : ALUcontrol_Out <= 4'b0000; 
  endcase
end


endmodule