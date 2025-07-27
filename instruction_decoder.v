module instruction_decoder (
    input [6:0] instruction,
    output reg [2:0] opcode,
    output reg [1:0] qubit1,
    output reg [1:0] qubit2
);
    always @(*) begin
        opcode  = instruction[6:4];
        qubit1  = instruction[3:2];
        qubit2  = instruction[1:0];
    end
endmodule
