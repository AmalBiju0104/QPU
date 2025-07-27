module top (
    input clk,
    input reset
);
    reg [3:0] pc; // Program Counter
    wire [6:0] instr;
    wire [2:0] opcode;
    wire [1:0] qubit1, qubit2;
   wire [31:0] out_state_flat;
    wire [7:0] out_state [0:3];

    assign out_state[0] = out_state_flat[31:24];
    assign out_state[1] = out_state_flat[23:16];
    assign out_state[2] = out_state_flat[15:8];
    assign out_state[3] = out_state_flat[7:0];

    wire [31:0] state_real_flat;
    wire [1:0] result;

    // ROM instance
    program_rom ROM (
        .addr(pc),
        .instruction(instr)
    );

    // Flatten the out_state array
    assign state_real_flat = {out_state[3], out_state[2], out_state[1], out_state[0]};

    // Measurement unit
    measure meas (
        .state_real_flat(state_real_flat),
        .measured_result(result)
    );

    // Decoder instance
    instruction_decoder DEC (
        .instruction(instr),
        .opcode(opcode),
        .qubit1(qubit1),
        .qubit2(qubit2)
    );

    // Quantum core
    quantum_core QCORE (
         .clk(clk),
    .reset(reset),
    .opcode(opcode),
    .qubit1(qubit1),
    .qubit2(qubit2),
    .out_state_flat(out_state_flat)  // ✅ correct port name
    );

    // PC logic
    always @(posedge clk or posedge reset) begin
        if (reset)
            pc <= 0;
        else
            pc <= pc + 1;
    end

    always @(posedge clk) begin
        $display("Time %0t:", $time);
        $display("  PC = %0d | Opcode = %b | q1 = %b | q2 = %b", pc, opcode, qubit1, qubit2);
        $display("  Quantum State = [%0d, %0d, %0d, %0d]",
                 out_state[0], out_state[1], out_state[2], out_state[3]);
        $display("  Measured Output = %b", result);
        $display("");
    end

endmodule

