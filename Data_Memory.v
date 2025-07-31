module Data_Memory(
    input clk,               
    input rst,               
    input MemRead,           
    input MemWrite,          
    input [31:0] address,    
    input [31:0] write_data, 
    output[31:0] read_data 
);
  reg [31:0] D_Memory [63:0];

  integer k;

  assign read_data = (MemRead) ? D_Memory[address] : 32'b00;

  always @(posedge clk) begin
	D_Memory[17] = 56;
	D_Memory[15] = 65;
end 

  always @(posedge clk or posedge rst) begin
    if (rst ) begin
      for (k = 0; k < 64; k = k + 1) begin
        D_Memory[k] = 32'b00;
      end
    end else if (MemWrite) begin
      D_Memory[address] = write_data;
    end
  end

endmodule