// ============================================================================
// Module: relu_activation
// Description: Implements ReLU activation with overflow protection
//              - Outputs input when positive, zero otherwise
//              - Handles fixed-point overflow in positive values
// Parameters:
//   - data_width: Bit-width of output 
//   - weightIntWidth: Number of integer bits in input 
// Ports:
//   - clk: System clock
//   - x: 2x data_width input (fixed-point format)
//   - valid_input: Asserted when input is valid
//   - out: Rectified output (data_width bits)
// ============================================================================

module relu_activation #(
    parameter data_width = 16,
    weightIntWidth = 4
)(
    input clk,
    input [2*data_width-1:0] x,        // Input 
    input valid_input,
    output reg [data_width-1:0] out    // Output 
);

// ===================== ReLU Core Logic =====================
always @(posedge clk) begin
    if (valid_input) begin
        if ($signed(x) > 0) begin
            $display("positive_number in relu");  // Debug: Positive input detected
            
            // Check for overflow in integer part
            if (|x[2*data_width-1 -: weightIntWidth+1]) begin  // Check MSB integer bits
                $display("overflow in relu");     // Debug: Overflow detected
                // Saturate to maximum positive value (011...1)
                out <= {1'b0, {(data_width-1){1'b1}}};
            end
            else begin
                // Format conversion: Q(N).M (N=IntWidth, M=data_width-IntWidth)
                out <= x[2*data_width-1 - weightIntWidth -: data_width];
            end
        end
        else begin
            // Negative values clamped to zero
            out <= 0;
        end
    end
end

endmodule


