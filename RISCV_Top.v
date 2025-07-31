module RISCV_Top(
		  input clk, rst
		); 
//....................................................................//

wire [31:0] pc_out_wire, pc_next_wire, pc_wire, decode_wire, read_data1, regtomux, WB_wire, branch_target, immgen_wire,muxtoAlu,read_data_wire,WB_data_wire;
wire RegWrite,ALUSrc, MemRead,MemWrite,MemToReg,Branch,Zero;
wire [1:0] ALUOp_wire;
wire [3:0] ALUcontrol_wire;
//....................................................................//

// Program Counter
program_counter PC(.clk(clk),.rst(rst),.pc_in(pc_wire),.pc_out(pc_out_wire));
// PC Adder
pc_adder PC_Adder(.pc_in(pc_out_wire),.pc_next(pc_next_wire));
// PC Mux
pc_mux pc_mux(.pc_in(pc_next_wire),.pc_branch(branch_target),.pc_select(Branch&Zero),.pc_out(pc_wire));
// Instruction Memory
Instruction_Memory Instr_Mem(.rst(rst),.clk(clk),.read_address(pc_out_wire),.instruction_out(decode_wire));
// Register File
Register_File Reg_File(.rst(rst), .clk(clk), .RegWrite(RegWrite), .Rs1(decode_wire[19:15]), .Rs2(decode_wire[24:20]), .Rd(decode_wire[11:7]), .Write_data(WB_data_wire), .read_data1(read_data1), .read_data2(regtomux));
// Control Unit
main_control_unit Control_Unit(.opcode(decode_wire[6:0]),.RegWrite(RegWrite),.MemRead(MemRead),.MemWrite(MemWrite),.MemToReg(MemToReg),.ALUSrc(ALUSrc),.Branch(Branch),.ALUOp(ALUOp_wire));
// ALU_Control
ALU_Control ALU_Control(.funct3(decode_wire[14:12]),.funct7(decode_wire[31:25]),.ALUOp(ALUOp_wire),.ALUcontrol_Out(ALUcontrol_wire));
// ALU
ALU ALU(.A(read_data1),.B(muxtoAlu),.ALUcontrol_In(ALUcontrol_wire),.Result(WB_wire),.Zero(Zero));
// Immediate Generator
immediate_generator Imm_Gen(.instruction(decode_wire),.imm_out(immgen_wire));
// ALU Mux
MUX2to1 Imm_Mux(.input0(regtomux),.input1(immgen_wire),.select(ALUSrc),.out(muxtoAlu));
// Data Memory
Data_Memory Data_Mem(.clk(clk),.rst(rst),.MemRead(MemRead),.MemWrite(MemWrite),.address(WB_wire),.write_data(regtomux),.read_data(read_data_wire));
//WB Mux
MUX2to1_DataMemory WB_Mux(.input0(WB_wire),.input1(read_data_wire),.select(MemToReg),.out(WB_data_wire));
//Branch_Adder
Branch_Adder Branch_Adder(.PC(pc_out_wire), .offset(immgen_wire), .branch_target(branch_target));
//






endmodule
