`include "include.v"
// ============================================================================
// Module: neuron
// Description: Implements a single neuron for a neural network layer.
//              - Supports both pre-trained and runtime-trained weights/biases.
//              - Performs multiply-accumulate (MAC) operations over inputs.
//              - Applies either sigmoid or ReLU activation.
// Parameters:
//   - data_width: Bit-width for data 
//   - num_weights: Number of weights per neuron 
//   - layer_no: Layer identifier 
//   - neuron_no: Neuron identifier 
//   - weight_file: Memory file for pre-trained weights
//   - bias_file: Memory file for pre-trained biases
//   - activation: "sigmoid" or "relu" activation function
//   - weight_sigmoid_in_width: Input width for sigmoid activation
//   - weightintwidht: Integer width for ReLU activation
// Ports:
//   - clk, rst: Clock and reset
//   - my_input: Serial input data (1 element/cycle)
//   - valid_input: Input data valid flag
//   - weight_value, valid_weight: Weight loading interface
//   - bias_value, valid_bias: Bias loading interface
//   - neuron_layer_no, neuron_neuron_no: Layer/neuron selector for loading
//   - valid_output: Asserted when output is valid
//   - neuron_out: Activated neuron output
// ============================================================================

module neuron #(
    parameter data_width = 16,
    num_weights = 784,
    layer_no = 1,
    neuron_no = 5,
    weight_file = "",
    weight_sigmoid_in_width = 10,
    bias_file = "",
    activation = "",
    weightintwidht = 1
)(
    input clk, rst,
    input [data_width - 1 : 0] my_input,           // One input per cycle
    input valid_input,                             // Input valid flag
    input [31:0] weight_value,                     // Weight input for loading
    input valid_weight,                            // Weight valid flag
    input [31:0] bias_value,                       // Bias input for loading
    input valid_bias,                              // Bias valid flag
    input [31:0] neuron_layer_no,                  // Layer selector for loading
    input [31:0] neuron_neuron_no,                 // Neuron selector for loading
    output reg valid_output,                       // Output valid flag
    output [data_width - 1 : 0] neuron_out         // Neuron output
);

    // Address width for weight memory
    parameter address_width_weight = $clog2(num_weights);

    // ===================== Weight Memory Control Signals =====================
    reg write_en_top;                                         // Write enable for weights
    wire read_en_top;                                         // Read enable for weights
    reg [data_width - 1 : 0] w_in_top;                        // Data for writing weights
    reg [address_width_weight - 1 : 0] weight_address_w_top;  // Write address
    reg [address_width_weight - 1 : 0] weight_address_r_top;  // Read address
    wire [data_width - 1 : 0] weight_out_top;                 // Output from weight memory

    // ===================== Bias Storage =====================
    reg [2 * data_width - 1 : 0] bias;             // Bias (doubled width for MAC)
    reg [31:0] biasReg[0:0];                       // Bias register for pre-trained
    reg addr = 0;                                  // Address for biasReg

    // ===================== MAC and Pipeline Registers =====================
    reg [data_width - 1 : 0] my_input_delay;       // Input delay for synchronization
    reg [2 * data_width - 1 : 0] mul;              // Multiplication result
    wire valid_mul;                                // Valid flag for multiplication
    reg [2 * data_width - 1 : 0] mul_sum;          // Accumulated sum (MAC)
    wire [2 * data_width - 1 : 0] combo_add;       // Sum for next accumulation
    wire [2 * data_width - 1 : 0] bias_add;        // Sum with bias
    wire valid_mux;                                // Valid flag for accumulation
    reg valid_mux_f;                               // Falling edge detector
    reg valid_mux_d;                               // Delayed valid_mux
    reg valid_input_sigmoid;                       // Valid input for activation
    reg weight_valid;                              // Delayed valid_input
    reg sigValid;                                  // Output valid flag

    // ===================== Weight Write Logic =====================
    always @(posedge clk) begin
        if (rst) begin
            write_en_top <= 0;
            weight_address_w_top <= {address_width_weight{1'b1}};  // Reset to max value
        end else if (valid_weight & (neuron_layer_no == layer_no) & (neuron_neuron_no == neuron_no)) begin
            // Write weight if valid and correct neuron/layer
            w_in_top <= weight_value;
            write_en_top <= 1;
            weight_address_w_top <= weight_address_w_top + 1;
        end else begin
            write_en_top <= 0;
        end
    end

    // ===================== Weight Read Logic =====================
    assign read_en_top = valid_input;
    always @(posedge clk) begin
        if (rst | valid_output)
            weight_address_r_top <= 0;
        else if (valid_input)
            weight_address_r_top <= weight_address_r_top + 1;
    end

    // ===================== Bias Handling =====================
    `ifdef pretrained
        // If pre-trained, load bias from file
        initial begin
            $readmemb(bias_file, biasReg);
        end
        always @(posedge clk) begin
            bias <= {biasReg[addr][data_width-1:0], {data_width{1'b0}}};
        end
    `else
        // Otherwise, load bias via interface
        always @(posedge clk) begin
            if (valid_bias & (neuron_layer_no == layer_no) & (neuron_neuron_no == neuron_no)) begin
                bias <= {bias_value[data_width-1:0], {data_width{1'b0}}};
            end
        end
    `endif

    // ===================== Pipeline and Valid Signal Logic =====================
    always @(posedge clk) begin
        my_input_delay <= my_input;
        weight_valid <= valid_input;
        sigValid <= ((weight_address_r_top == (num_weights)) & valid_mux_f) ? 1'b1 : 1'b0;
        valid_output <= sigValid;                 // ek cycle ke baad activation se output aajayega and valid output high kardo               
        valid_mux_d <= valid_mux;
        valid_mux_f <= !valid_mux & valid_mux_d; //multiply hochuka hai sab at the falling edge of valid_mul isko high kardo and bias add kardo
        valid_input_sigmoid <= valid_mux_f;      // ek cyce ka delay means bias bhi add hogaya hai activation mein bhej do
    end

    // ===================== Multiply Stage =====================
    always @(posedge clk) begin
        if (rst)
            mul <= 0;
        else if (valid_mul)
            mul <= $signed(weight_out_top) * $signed(my_input_delay);
    end

    assign valid_mul = weight_valid;
    assign valid_mux = valid_mul;
    assign combo_add = mul + mul_sum;
    assign bias_add = bias + mul_sum;

    // ===================== Accumulation and Overflow Protection =====================
    always @(posedge clk) begin
        if (rst | valid_output)
            mul_sum <= 0;
        else if (valid_mux_d) begin
            // Overflow protection for accumulation
            if (mul[2*data_width-1] & mul_sum[2*data_width-1] & !combo_add[2*data_width-1])
                mul_sum <= {1'b1, {2*data_width-1{1'b0}}}; // Clamp to min
            else if (!mul[2*data_width-1] & !mul_sum[2*data_width-1] & combo_add[2*data_width-1])
                mul_sum <= {1'b0, {2*data_width-1{1'b1}}}; // Clamp to max
            else
                mul_sum <= combo_add;
        end else if ((weight_address_r_top == num_weights) & valid_mux_f) begin
            // Add bias at the end of accumulation, with overflow protection
            if (!bias[2*data_width-1] & !mul_sum[2*data_width-1] & bias_add[2*data_width-1])
                mul_sum <= {1'b0, {2*data_width-1{1'b1}}};
            else if (bias[2*data_width-1] & mul_sum[2*data_width-1] & !bias_add[2*data_width-1])
                mul_sum <= {1'b1, {2*data_width-1{1'b0}}};
            else
                mul_sum <= bias_add;
        end
    end

    // ===================== Weight Memory Instantiation =====================
    weights_memory #(
        .data_width(data_width),
        .address_width(address_width_weight),
        .num_weights(num_weights),
        .layer_no(layer_no),
        .neuron_no(neuron_no),
        .weight_file(weight_file)
    ) WM (
        .clk(clk),
        .write_en(write_en_top),
        .read_en(read_en_top),
        .weight_in(w_in_top),
        .weight_address_w(weight_address_w_top),
        .weight_address_r(weight_address_r_top),
        .weight_out(weight_out_top)
    );

    // ===================== Activation Function Selection =====================
    generate
        if (activation == "sigmoid") begin : siginst
            initial begin $display("Sigmoid activation is instantiated."); end
            sigmoid_activation #(
                .data_width(data_width),
                .weight_sigmoid_in_width(weight_sigmoid_in_width)
            ) sa (
                .clk(clk),
                .x(mul_sum[2*data_width-1-:weight_sigmoid_in_width]),
                .valid_input(valid_input_sigmoid),
                .out(neuron_out)
            );
        end else begin : Reluinst
            initial begin $display("ReLU activation is instantiated."); end
            relu_activation #(
                .data_width(data_width),
                .weightintwidht(weightintwidht)
            ) ra (
                .clk(clk),
                .x(mul_sum),
                .valid_input(valid_input_sigmoid),
                .out(neuron_out)
            );
        end
    endgenerate

endmodule

