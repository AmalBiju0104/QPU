module quantum_core (
    input clk,
    input reset,
    input [2:0] opcode,
    input [1:0] qubit1,
    input [1:0] qubit2,
    output [31:0] out_state_flat  // Flattened state vector
);

    // Fixed-point state vector (only real part for simplicity)
    reg signed [7:0] state [0:3];
    integer i;

    // Main logic
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            for (i = 0; i < 4; i = i + 1)
                state[i] <= 0;
            state[0] <= 10; // |00⟩ initialized
        end else begin
            case (opcode)
                3'b000: apply_hadamard(qubit1);     // H
                3'b001: apply_x(qubit1);            // X
                3'b010: apply_cnot(qubit1, qubit2); // CNOT
                default: ; // Do nothing
            endcase
        end
    end

    // Hadamard gate (acts on qubit 0 only for now)
    task apply_hadamard(input [1:0] qubit);
        reg signed [7:0] temp0, temp1;
        begin
            if (qubit == 0) begin
                temp0 = (state[0] + state[2]) >>> 1;
                temp1 = (state[0] - state[2]) >>> 1;
                state[0] = temp0;
                state[2] = temp1;

                temp0 = (state[1] + state[3]) >>> 1;
                temp1 = (state[1] - state[3]) >>> 1;
                state[1] = temp0;
                state[3] = temp1;
            end
        end
    endtask

    // Pauli-X gate (bit-flip)
    task apply_x(input [1:0] qubit);
        reg signed [7:0] temp;
        begin
            if (qubit == 0) begin
                temp = state[0]; state[0] = state[2]; state[2] = temp;
                temp = state[1]; state[1] = state[3]; state[3] = temp;
            end else if (qubit == 1) begin
                temp = state[0]; state[0] = state[1]; state[1] = temp;
                temp = state[2]; state[2] = state[3]; state[3] = temp;
            end
        end
    endtask

    // CNOT gate: control = qubit1, target = qubit2
    task apply_cnot(input [1:0] control, input [1:0] target);
        reg signed [7:0] temp;
        begin
            if (control == 0 && target == 1) begin
                temp = state[2]; state[2] = state[3]; state[3] = temp;
            end else if (control == 1 && target == 0) begin
                temp = state[1]; state[1] = state[3]; state[3] = temp;
            end
        end
    endtask

    // Flatten output
    assign out_state_flat = {state[0], state[1], state[2], state[3]};

endmodule

