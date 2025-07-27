module measure (
    input [31:0] state_real_flat, // Flattened 4x8-bit array
    output reg [1:0] measured_result
);
    integer i;
    reg [7:0] state_real [0:3]; // Internal unpacked array
    reg [7:0] max_val;
    reg [1:0] max_index;

    always @(*) begin
        // Unpack manually
        state_real[0] = state_real_flat[7:0];
        state_real[1] = state_real_flat[15:8];
        state_real[2] = state_real_flat[23:16];
        state_real[3] = state_real_flat[31:24];

        max_val = 0;
        max_index = 0;

        for (i = 0; i < 4; i = i + 1) begin
            if (state_real[i][7] == 0 && state_real[i] > max_val) begin
                max_val = state_real[i];
                max_index = i[1:0];
            end
        end

        measured_result = max_index;
    end
endmodule

