// ============================================================================
// Module: weights_memory
// Description: Dual-port weight memory block for neural networks. Supports both
//              pre-trained weights (from file) and runtime weight updates.
// Parameters:
//   - data_width: Bit-width of weight values 
//   - address_width: Address bus width (calculated as log2(num_weights))
//   - num_weights: Total weights stored (default 784)
//   - layer_no: Layer identifier 
//   - neuron_no: Neuron identifier 
//   - weight_file: Memory initialization file for pre-trained weights
// Ports:
//   - clk: System clock
//   - write_en: Write enable signal
//   - read_en: Read enable signal
//   - weight_in: Weight data input for writing
//   - weight_address_w: Write address
//   - weight_address_r: Read address
//   - weight_out: Weight data output for reading
// ============================================================================

`include "include.v"

module weights_memory #(
    parameter data_width = 16,
    address_width = 10,
    num_weights = 784,
    layer_no = 1,
    neuron_no = 5,
    weight_file = ""
)(
    input clk,
    input write_en,
    input read_en,
    input [address_width-1:0] weight_address_w,
    input [address_width-1:0] weight_address_r,
    input [data_width-1:0] weight_in,
    output reg [data_width-1:0] weight_out
);

// Memory array to store weights
reg [data_width-1:0] weights_mem[num_weights-1:0];

// ===================== Memory Initialization/Writing =====================
`ifdef pretrained
    // Pre-trained mode: Load weights from specified file at startup
    initial begin
        $readmemb(weight_file, weights_mem);
    end
`else
    // Runtime training mode: Write weights through interface
    always @(posedge clk) begin
        if (write_en) begin
            // Store incoming weight at specified write address
            weights_mem[weight_address_w] <= weight_in;
        end
    end 
`endif

// ===================== Reading Logic =====================
always @(posedge clk) begin
    if (read_en) begin
        // Output weight from specified read address
        weight_out <= weights_mem[weight_address_r]; 
    end
end

endmodule
