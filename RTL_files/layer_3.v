// ============================================================================
// Module: layer_3
// Description: Implements the second layer of a neural network, consisting of
//              10 parallel neurons. Each neuron receives the same input but
//              uses its own set of weights and biases.
// Parameters:
//   - no_neuron: Number of neurons in this layer (default 10)
//   - num_weights: Number of weights per neuron (default 30)
//   - data_width: Bit-width for input/output data (default 16)
//   - layer_no: Layer number (default 3)
//   - weight_sigmoid_in_width: Width for weight sigmoid input (default 10)
//   - weightintwidht: Integer width for weight (default 4)
//   - activation: Activation function type (string)
// Ports:
//   - clk, rst: Clock and reset
//   - my_input: Input data to all neurons
//   - valid_input: Valid signal for input data
//   - weight_value, bias_value: Values for weights and biases (for loading)
//   - valid_weight, valid_bias: Valid signals for weight and bias updates
//   - neuron_neuron_no, layer_layer_no: Identifiers for neuron/layer selection
//   - valid_output: Valid output signals from each neuron
//   - neuron_out: Concatenated outputs from all neurons
// ============================================================================

module layer_3 #(
    parameter no_neuron = 30,
    num_weights = 30,
    data_width = 16,
    layer_no = 3,
    weight_sigmoid_in_width = 10,
    weightintwidht = 4,
    activation = ""
)(
    input clk, rst,
    input [data_width-1:0] my_input,
    input valid_input,
    input [31:0] weight_value,
    input [31:0] bias_value,
    input valid_weight,
    input valid_bias,
    input [31:0]neuron_neuron_no,
    input [31:0]layer_layer_no,
    output [no_neuron-1:0] valid_output,
    output [no_neuron*data_width-1 :0] neuron_out
);
// --------------------------------------------------------------------------
// Instantiating 10 neurons for this layer.
// Each neuron receives the same input but has unique weights, biases, and
// memory files. Outputs are concatenated into neuron_out, and each neuron
// asserts its own valid_output bit when its result is ready.
// --------------------------------------------------------------------------

// Neuron 1
neuron #(
    .data_width(data_width), .num_weights(num_weights), .layer_no(layer_no), .neuron_no(1),
    .weight_file("w_3_0.mif"), .bias_file("b_3_0.mif"),
    .weight_sigmoid_in_width(weight_sigmoid_in_width), .activation(activation), .weightintwidht(weightintwidht)
) n_1 (
    .clk(clk), .rst(rst), .my_input(my_input), .valid_input(valid_input),
    .weight_value(weight_value), .valid_weight(valid_weight),
    .bias_value(bias_value), .valid_bias(valid_bias),
    .neuron_layer_no(layer_layer_no), .neuron_neuron_no(neuron_neuron_no),
    .valid_output(valid_output[0]),
    .neuron_out(neuron_out[0*data_width +: data_width])
);

// Neuron 2
neuron #(
    .data_width(data_width), .num_weights(num_weights), .layer_no(layer_no), .neuron_no(2),
    .weight_file("w_3_1.mif"), .bias_file("b_3_1.mif"),
    .weight_sigmoid_in_width(weight_sigmoid_in_width), .activation(activation), .weightintwidht(weightintwidht)
) n_2 (
    .clk(clk), .rst(rst), .my_input(my_input), .valid_input(valid_input),
    .weight_value(weight_value), .valid_weight(valid_weight),
    .bias_value(bias_value), .valid_bias(valid_bias),
    .neuron_layer_no(layer_layer_no), .neuron_neuron_no(neuron_neuron_no),
    .valid_output(valid_output[1]),
    .neuron_out(neuron_out[1*data_width +: data_width])
);

// Neuron 3
neuron #(
    .data_width(data_width), .num_weights(num_weights), .layer_no(layer_no), .neuron_no(3),
    .weight_file("w_3_2.mif"), .bias_file("b_3_2.mif"),
    .weight_sigmoid_in_width(weight_sigmoid_in_width), .activation(activation), .weightintwidht(weightintwidht)
) n_3 (
    .clk(clk), .rst(rst), .my_input(my_input), .valid_input(valid_input),
    .weight_value(weight_value), .valid_weight(valid_weight),
    .bias_value(bias_value), .valid_bias(valid_bias),
    .neuron_layer_no(layer_layer_no), .neuron_neuron_no(neuron_neuron_no),
    .valid_output(valid_output[2]),
    .neuron_out(neuron_out[2*data_width +: data_width])
);

// Neuron 4
neuron #(
    .data_width(data_width), .num_weights(num_weights), .layer_no(layer_no), .neuron_no(4),
    .weight_file("w_3_3.mif"), .bias_file("b_3_3.mif"),
    .weight_sigmoid_in_width(weight_sigmoid_in_width), .activation(activation), .weightintwidht(weightintwidht)
) n_4 (
    .clk(clk), .rst(rst), .my_input(my_input), .valid_input(valid_input),
    .weight_value(weight_value), .valid_weight(valid_weight),
    .bias_value(bias_value), .valid_bias(valid_bias),
    .neuron_layer_no(layer_layer_no), .neuron_neuron_no(neuron_neuron_no),
    .valid_output(valid_output[3]),
    .neuron_out(neuron_out[3*data_width +: data_width])
);

// Neuron 5
neuron #(
    .data_width(data_width), .num_weights(num_weights), .layer_no(layer_no), .neuron_no(5),
    .weight_file("w_3_4.mif"), .bias_file("b_3_4.mif"),
    .weight_sigmoid_in_width(weight_sigmoid_in_width), .activation(activation), .weightintwidht(weightintwidht)
) n_5 (
    .clk(clk), .rst(rst), .my_input(my_input), .valid_input(valid_input),
    .weight_value(weight_value), .valid_weight(valid_weight),
    .bias_value(bias_value), .valid_bias(valid_bias),
    .neuron_layer_no(layer_layer_no), .neuron_neuron_no(neuron_neuron_no),
    .valid_output(valid_output[4]),
    .neuron_out(neuron_out[4*data_width +: data_width])
);

// Neuron 6
neuron #(
    .data_width(data_width), .num_weights(num_weights), .layer_no(layer_no), .neuron_no(6),
    .weight_file("w_3_5.mif"), .bias_file("b_3_5.mif"),
    .weight_sigmoid_in_width(weight_sigmoid_in_width), .activation(activation), .weightintwidht(weightintwidht)
) n_6 (
    .clk(clk), .rst(rst), .my_input(my_input), .valid_input(valid_input),
    .weight_value(weight_value), .valid_weight(valid_weight),
    .bias_value(bias_value), .valid_bias(valid_bias),
    .neuron_layer_no(layer_layer_no), .neuron_neuron_no(neuron_neuron_no),
    .valid_output(valid_output[5]),
    .neuron_out(neuron_out[5*data_width +: data_width])
);

// Neuron 7
neuron #(
    .data_width(data_width), .num_weights(num_weights), .layer_no(layer_no), .neuron_no(7),
    .weight_file("w_3_6.mif"), .bias_file("b_3_6.mif"),
    .weight_sigmoid_in_width(weight_sigmoid_in_width), .activation(activation), .weightintwidht(weightintwidht)
) n_7 (
    .clk(clk), .rst(rst), .my_input(my_input), .valid_input(valid_input),
    .weight_value(weight_value), .valid_weight(valid_weight),
    .bias_value(bias_value), .valid_bias(valid_bias),
    .neuron_layer_no(layer_layer_no), .neuron_neuron_no(neuron_neuron_no),
    .valid_output(valid_output[6]),
    .neuron_out(neuron_out[6*data_width +: data_width])
);

// Neuron 8
neuron #(
    .data_width(data_width), .num_weights(num_weights), .layer_no(layer_no), .neuron_no(8),
    .weight_file("w_3_7.mif"), .bias_file("b_3_7.mif"),
    .weight_sigmoid_in_width(weight_sigmoid_in_width), .activation(activation), .weightintwidht(weightintwidht)
) n_8 (
    .clk(clk), .rst(rst), .my_input(my_input), .valid_input(valid_input),
    .weight_value(weight_value), .valid_weight(valid_weight),
    .bias_value(bias_value), .valid_bias(valid_bias),
    .neuron_layer_no(layer_layer_no), .neuron_neuron_no(neuron_neuron_no),
    .valid_output(valid_output[7]),
    .neuron_out(neuron_out[7*data_width +: data_width])
);

// Neuron 9
neuron #(
    .data_width(data_width), .num_weights(num_weights), .layer_no(layer_no), .neuron_no(9),
    .weight_file("w_3_8.mif"), .bias_file("b_3_8.mif"),
    .weight_sigmoid_in_width(weight_sigmoid_in_width), .activation(activation), .weightintwidht(weightintwidht)
) n_9 (
    .clk(clk), .rst(rst), .my_input(my_input), .valid_input(valid_input),
    .weight_value(weight_value), .valid_weight(valid_weight),
    .bias_value(bias_value), .valid_bias(valid_bias),
    .neuron_layer_no(layer_layer_no), .neuron_neuron_no(neuron_neuron_no),
    .valid_output(valid_output[8]),
    .neuron_out(neuron_out[8*data_width +: data_width])
);

// Neuron 10
neuron #(
    .data_width(data_width), .num_weights(num_weights), .layer_no(layer_no), .neuron_no(10),
    .weight_file("w_3_9.mif"), .bias_file("b_3_9.mif"),
    .weight_sigmoid_in_width(weight_sigmoid_in_width), .activation(activation), .weightintwidht(weightintwidht)
) n_10 (
    .clk(clk), .rst(rst), .my_input(my_input), .valid_input(valid_input),
    .weight_value(weight_value), .valid_weight(valid_weight),
    .bias_value(bias_value), .valid_bias(valid_bias),
    .neuron_layer_no(layer_layer_no), .neuron_neuron_no(neuron_neuron_no),
    .valid_output(valid_output[9]),
    .neuron_out(neuron_out[9*data_width +: data_width])
);
endmodule