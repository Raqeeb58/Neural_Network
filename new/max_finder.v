// ============================================================================
// Module: max_finder
// Description: Finds the maximum value in a serialized input array and outputs
//              its index. Processes inputs sequentially over multiple clock cycles.
// Parameters:
//   - data_width: Bit-width of each input element (default 16)
//   - no_inputs: Number of elements in the input array (default 10)
// Ports:
//   - clk, rst: Clock and reset signals
//   - valid_input: Asserted when input data is valid
//   - my_input: Concatenated input elements (width: data_width*no_inputs)
//   - valid_output: Asserted when maximum index is valid
//   - data_out: Index of the maximum value (32-bit output)
// ============================================================================

module max_finder #(
    parameter data_width = 16,
    no_inputs = 10
) (
    input clk,
    input rst,
    input valid_input,
    input [data_width*no_inputs -1 :0] my_input,
    output reg valid_output,
    output reg [31:0] data_out
);

// Internal registers
reg [data_width -1 :0] max_value;  // Stores current maximum value
integer counter;                   // Tracks processing position in input array
reg [data_width*no_inputs -1 :0] data_buffer;  // Buffer for input data

// ============================================================================
// Main Processing Logic
// Operates in three phases:
// 1. Initialization on valid_input
// 2. Sequential comparison of elements
// 3. Output validation
// ============================================================================
always @(posedge clk) begin
    valid_output <= 1'b0;  // Default output invalid
    
    if (rst) begin
        // Reset state
        counter <= 0;
        max_value <= 0;
        data_buffer <= 0;
        data_out <= 0;
    end
    else if (valid_input) begin
        // Phase 1: Initialize search with first element
        max_value <= my_input[data_width -1 :0];
        counter <= counter + 1;
        data_buffer <= my_input;  // Store all inputs for sequential processing
        data_out <= 0;  // Reset output index
    end
    else if (counter == no_inputs) begin
        // Phase 3: All elements processed
        counter <= 0;
        valid_output <= 1'b1;  // Signal valid output
    end
    else if (counter != 0) begin
        // Phase 2: Compare subsequent elements
        counter <= counter + 1;
        
        // Compare current element with stored maximum
        if (data_buffer[counter*data_width +: data_width] > max_value) begin
            max_value <= data_buffer[counter*data_width +: data_width];
            data_out <= counter;  // Update maximum index
        end
    end
end

endmodule
