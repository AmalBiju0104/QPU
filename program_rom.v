module program_rom (
    input [3:0] addr,
    output reg [6:0] instruction
);
    always @(*) begin
        case (addr)
            4'd0: instruction = 7'b000_00_00; // H q0
            4'd1: instruction = 7'b010_00_01; // CNOT q0, q1
            4'd2: instruction = 7'b011_01_00; // MEASURE q1
            default: instruction = 7'b000_00_00;
        endcase
    end
endmodule
