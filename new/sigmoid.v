
// ============================================================================
// Module: sigmoid_activation
// Description: Implements sigmoid activation using precomputed lookup table (LUT)
//              - Converts signed input to unsigned LUT address
//              - Output ranges from 0.0 to 1.0 in fixed-point representation
// Parameters:
//   - data_width: Bit-width of output 
//   - weight_sigmoid_in_width: Bit-width of input 
// Ports:
//   - clk: System clock
//   - x: Signed input value (2's complement)
//   - valid_input: Asserted when input is valid
//   - out: Sigmoid-activated output (unsigned fixed-point)
// ============================================================================

module sigmoid_activation #(
    parameter data_width = 16,
    weight_sigmoid_in_width = 10
)(
    input clk,
    input [weight_sigmoid_in_width -1:0] x,
    input valid_input,
    output [data_width-1:0] out
);

// ===================== Lookup Table (LUT) Declaration =====================
reg [data_width-1:0] sigmoid_mem[2**weight_sigmoid_in_width-1:0];
/* x can be negative but adress cant be negative so we are manipulating x and storing it in y and assigning it to y*/
// ===================== Input Conversion Logic =====================
/* Convert signed input to unsigned LUT address:
   Add 2^(width-1) to shift input range from [-2^(n-1), 2^(n-1)-1] 
   to [0, 2^n-1] for LUT addressing */
reg [weight_sigmoid_in_width-1:0] y;

// ===================== LUT Initialization =====================
initial begin
    // Load precomputed sigmoid values from file
    $readmemb("sigContent.mif", sigmoid_mem);
    
    // Debug statements (optional for verification)
    $display("sigmoid_mem[44]= %b", sigmoid_mem[44]);
    $display("sigmoid_mem[512]= %b", sigmoid_mem[512]);
    $display("sigmoid_mem[513]= %b", sigmoid_mem[513]);
    $display("sigmoid_mem[556]= %b", sigmoid_mem[556]);
    $display("sigmoid_mem[507]= %b", sigmoid_mem[507]);
    $display("sigmoid_mem[517]= %b", sigmoid_mem[517]);
end

// ===================== Pipeline Stage =====================
always @(posedge clk) begin
    if(valid_input) begin
        // Convert signed input to unsigned LUT address
        y <= $signed(x) + (1 << (weight_sigmoid_in_width - 1));
    end
end

// ===================== Output Assignment =====================
assign out = sigmoid_mem[y];  // LUT-based sigmoid value

endmodule


