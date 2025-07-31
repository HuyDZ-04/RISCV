# RISCV Single-Cycle Processor
## **Project Title** 
Design and simulation of a RISCV Single-Cycle Processor

## **Description** 
This project was developed using Verilog HDL and simulated in Xilinx ISE Design Suite. The main purpose is to implement and simulate a RISCV Single-Cycle Processor

## **How to use** 
Tools required
* ISE Xilinx Design Suite: https://www.xilinx.com/support/download.html
* Virtual box: https://www.virtualbox.org/

## **License** 
This project is open for learning and academic reference. Please check the LICENSE file (if available) for usage rights and restrictions.

## **Detail**
- A Single-Cycle Processor executes one instruction per clock cycle. In this design, all datapath operations—fetch, decode, execute, memory access, and write-back—are completed in one clock cycle.
### Key Characteristics
+ Instruction Set Architecture: RISC-V (RV32I base integer set)

+ Clock Cycle: Single cycle per instruction

+ Architecture: Harvard or Von Neumann style (depending on design)

+ Implementation Language: Verilog / SystemVerilog
## How It Works
In a single-cycle processor, each instruction is executed in exactly one clock cycle. That means the processor must complete fetch, decode, execute, memory access, and write-back all within one cycle.

##  RISCV Single-Cycle Processor Architecture Diagram  
<p align="center">
<img width="881" height="667" alt="image" src="https://github.com/user-attachments/assets/0adb26a8-6b3b-4a61-89e5-7d1b674f9ef6" />
</p>
## Module Descriptions


| **Module**                     | **Function**                                                                 |
|-------------------------------|------------------------------------------------------------------------------|
| `RISCV_Top.v`                 | Integrates all components: datapath, control unit, and memory               |
| `ALU.v`                       | Performs arithmetic and logical operations                                  |
| `ALU_Control.v`               | Maps instruction opcode/funct to ALU operations                             |
| `Register_File.v`             | Implements 32 general-purpose 32-bit registers                              |
| `Instruction_Memory.v`        | Holds the machine code (loaded from `program.mem`)                          |
| `Data_Memory.v`               | Simulates RAM for load/store operations                                     |
| `main_control_unit.v`         | Generates control signals based on instruction type                         |
| `immediate_generator.v`       | Extracts and sign-extends immediate values                                  |
| `program_counter.v`           | Holds the current Program Counter (PC) value                                |
| `pc_adder.v`                  | Computes `PC + 4` or branch target                                          |
| `Branch_Adder.v`              | Calculates the actual branch target address                                 |
| `MUX2to1.v` / `MUX2to1_DataMemory.v` | Multiplexers used for input selection within the datapath              |
 
## Sub module detail 
### ALU.v
- ALU (Arithmetic Logic Unit)
This module implements a 32-bit Arithmetic Logic Unit (ALU) for a RISC-based processor. The ALU performs a variety of arithmetic and logical operations based on a 4-bit control signal input.

- Inputs:
A (32-bit): First operand
B (32-bit): Second operand
ALUcontrol_In (4-bit): Operation selector
- Outputs:
Result (32-bit): Output of the selected operation
Zero (1-bit): Flag that is set to 1 if the result is zero, otherwise 0
### ALU_Control.v
- The ALU Control Unit is a combinational logic module responsible for decoding RISC-V instruction function fields and ALUOp signals (provided by the Main Control Unit) into specific ALU operation codes.
This module ensures that the Arithmetic Logic Unit (ALU) performs the correct operation for each instruction type (e.g., R-type, I-type, branch instructions, etc.).
- Inputs
  **funct3 (3 bits)**: Function code field from the instruction (bits [14:12])
   
  **funct7 (7 bits)**: Function code field from the instruction (bits [31:25])
  
  **ALUOp (2 bits)**: Control signal from the Main Control Unit indicating instruction type
- Output
  **ALUcontrol_Out (4 bits)**: Encoded ALU operation signal used by the ALU module
  <img width="791" height="627" alt="image" src="https://github.com/user-attachments/assets/6728e81e-e5d9-497e-8c62-c74578c331bf" />
### Data Memory
- The Data Memory module represents the memory component used to store and retrieve data during program execution. It is accessed by lw (load word) and sw (store word) instructions and supports both read and write operations controlled by the processor's control unit.
- Key Features
  64 memory words (each 32-bit wide), addressed directly by 32-bit addresses.

  Supports asynchronous read and synchronous write.
  
  Initialized to zero on reset (rst).

  Preloaded with test data at addresses 15 and 17
  
### Instruction Memory
- The Instruction Memory module is a read-only memory unit used to store and supply 32-bit RISC-V instructions to the processor. It is initialized with a predefined set of instructions including R-type, I-type, L-type (load), S-type (store), B-type (branch), U-type, and J-type instructions for simulation or test purposes.

- Key Features
  Stores up to 64 instructions (each 32-bit wide).

  Instructions are read using the read_address input.

  Supports reset functionality to initialize all instructions to zero before loading sample instructions.

  Preloaded with various RISC-V instruction formats for testing
  
- Instruction Set Preloaded
R-Type: Arithmetic and logic operations such as add, sub, and, or, xor, sll, srl, sra, and slt

I-Type: Immediate operations like addi, ori, xori, andi, slli, srli, srai, slti

L-Type (Load): Instructions like lb, lh, and lw

S-Type (Store): Instructions such as sb, sh, and sw

B-Type (Branch): Conditional branches like beq and bne

U-Type: Instructions like lui and auipc

J-Type: Jump instruction jal
- Behavior
**  On Reset (rst):**

All memory locations are cleared (filled with 0).

**  On Clock Edge (posedge clk):**

The instruction memory is loaded with test instructions starting at address 0.

Instructions are hardcoded at specific memory addresses for simulation.

**  Instruction Fetch:**

instruction_out is continuously assigned the instruction at read_address.
### Immediate Generator
- The Immediate Generator module extracts and sign-extends immediate values from 32-bit RISC-V instructions based on their instruction format. These immediate values are used in arithmetic operations, memory addressing, and control flow instructions.
- Purpose
Converts the encoded immediate fields of different instruction types (I, S, B, U, J) into 32-bit sign-extended immediate values required for correct operation in the datapath.
### Main Control Unit
- The Main Control Unit is a critical component of the RISC-V processor's datapath. It generates control signals based on the 7-bit opcode field of the instruction. These control signals coordinate the behavior of the processor's submodules such as the register file, ALU, data memory, and branching logic.
  
| Instruction Type | Opcode     | RegWrite | MemRead | MemWrite | MemToReg | ALUSrc | Branch | ALUOp |
|------------------|------------|----------|---------|----------|----------|--------|--------|-------|
| **R-type**       | `0110011`  | 1        | 0       | 0        | 0        | 0      | 0      | `10`  |
| **I-type (ALU)** | `0010011`  | 1        | 0       | 0        | 0        | 1      | 0      | `10`  |
| **Load**         | `0000011`  | 1        | 1       | 0        | 1        | 1      | 0      | `00`  |
| **Store**        | `0100011`  | 0        | 0       | 1        | 0        | 1      | 0      | `00`  |
| **Branch**       | `1100011`  | 0        | 0       | 0        | 0        | 0      | 1      | `11`  |
| **Jump (JAL)**   | `1101111`  | 1        | 0       | 0        | 0        | 0      | 0      | `10`  |
| **LUI**          | `0110111`  | 1        | 0       | 0        | 0        | 0      | 0      | `10`  |
| **Default**      | `others`   | 0        | 0       | 0        | 0        | 0      | 0      | `00`  |
- port
  
| Signal     | Width | Direction | Description                                          |
| ---------- | ----- | --------- | ---------------------------------------------------- |
| `opcode`   | 7     | Input     | Opcode from instruction bits \[6:0]                  |
| `RegWrite` | 1     | Output    | Enables writing to the register file                 |
| `MemRead`  | 1     | Output    | Enables reading from data memory                     |
| `MemWrite` | 1     | Output    | Enables writing to data memory                       |
| `MemToReg` | 1     | Output    | Selects memory or ALU output for register write-back |
| `ALUSrc`   | 1     | Output    | Selects immediate or register B as ALU input         |
| `Branch`   | 1     | Output    | Enables branch logic                                 |
| `ALUOp`    | 2     | Output    | Encodes type of ALU operation (used by ALU Control)  |

### Program Counter (PC)
- The Program Counter (PC) is a simple but essential module in the RISC-V processor datapath. It holds the address of the current instruction and updates it every clock cycle. The PC either increments normally or is updated with a new target address for control flow changes (e.g., jumps or branches).

| Signal   | Width | Direction | Description                                |
| -------- | ----- | --------- | ------------------------------------------ |
| `clk`    | 1     | Input     | Clock signal                               |
| `rst`    | 1     | Input     | Reset signal (sets PC to zero)             |
| `pc_in`  | 32    | Input     | Next PC value (from adder or branch logic) |
| `pc_out` | 32    | Output    | Current instruction address (PC value)     |

- Behavior
**On Reset (rst):**

Sets pc_out to 0, restarting program execution from the beginning.

**On Clock Edge (posedge clk)**:

Updates pc_out to the value provided in pc_in, allowing jumps, branches, or normal sequential execution.
- Notes
The PC module is a register with enable, controlled implicitly by always updating with pc_in.

Typically, pc_in is generated from:

pc_out + 4 (for sequential instructions), or

pc_out + offset (for branches or jumps).
### Register File
- The Register File is a critical component of the RISC-V CPU, providing 32 general-purpose registers for instruction execution. This module supports simultaneous reading of two registers and conditional writing to one register.

| Signal       | Width | Direction | Description                              |
| ------------ | ----- | --------- | ---------------------------------------- |
| `clk`        | 1     | Input     | Clock signal                             |
| `rst`        | 1     | Input     | Reset signal — clears all registers to 0 |
| `RegWrite`   | 1     | Input     | Write-enable control signal              |
| `Rs1`        | 5     | Input     | Source register 1 address                |
| `Rs2`        | 5     | Input     | Source register 2 address                |
| `Rd`         | 5     | Input     | Destination register address             |
| `Write_data` | 32    | Input     | Data to be written into `Rd`             |
| `read_data1` | 32    | Output    | Contents of register `Rs1`               |
| `read_data2` | 32    | Output    | Contents of register `Rs2`               |

- Behavior
**Initialization:**

Registers are initialized once at simulation startup with predefined values for testing.

x0 (Registers[0]) is hardcoded to zero by initialization and not modified during write.

**Reset (rst = 1):**

Clears all 32 registers to zero.

Write Operation (on rising clk):

If RegWrite is asserted, Write_data is stored in register Rd.

**Read Operation (combinational):**

read_data1 = Registers[Rs1]

read_data2 = Registers[Rs2]

**Initial Values (for simulation)**
The register file is preloaded with values for simulation
## Simulation Result
<img width="1920" height="935" alt="image" src="https://github.com/user-attachments/assets/c0cf3fa6-db24-4520-a4f6-abeeae3fb992" />

###  Observations:

 This simulation confirms that the RISC works correctly for sequential write and read operations.



