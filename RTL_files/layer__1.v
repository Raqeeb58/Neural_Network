// ============================================================================
// Module: layer_1
// Description: This module implements a single neural network layer consisting
//              of 30 parallel neuron instances. Each neuron receives the same
//              input but has its own set of weights and biases.
// Parameters:
//   - no_neuron: Number of neurons in this layer (default 30)
//   - num_weights: Number of weights per neuron (default 784)
//   - data_width: Bit-width of input/output data (default 16)
//   - layer_no: Layer number (default 1)
//   - weight_sigmoid_in_width: Width for weight sigmoid input (default 10)
//   - weightintwidht: Integer width for weight (default 4)
//   - activation: Activation function type (string)
// Ports:
//   - clk, rst: Clock and reset signals
//   - my_input: Input data to all neurons
//   - valid_input: Valid signal for input data
//   - weight_value, bias_value: Values for weights and biases (for loading)
//   - valid_weight, valid_bias: Valid signals for weight and bias updates
//   - neuron_neuron_no, layer_layer_no: Identifiers for neuron/layer selection
//   - valid_output: Valid output signals from each neuron
//   - neuron_out: Concatenated outputs from all neurons
// ============================================================================

module layer_1 #(
    parameter no_neuron = 30,
    num_weights = 784,
    data_width = 16,
    layer_no = 1,
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
// Instantiating 30 neurons for this layer.
// Each neuron receives the same input but has its own weights, biases, and
// memory files. The outputs are concatenated into neuron_out, and each neuron
// produces a valid_output signal.
// --------------------------------------------------------------------------

// Neuron 1
neuron #(
    .data_width(data_width), .num_weights(num_weights), .layer_no(layer_no), .neuron_no(1),
    .weight_file("w_1_0.mif"), .bias_file("b_1_0.mif"),
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
    .weight_file("w_1_1.mif"), .bias_file("b_1_1.mif"),
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
    .weight_file("w_1_2.mif"), .bias_file("b_1_2.mif"),
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
    .weight_file("w_1_3.mif"), .bias_file("b_1_3.mif"),
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
    .weight_file("w_1_4.mif"), .bias_file("b_1_4.mif"),
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
    .weight_file("w_1_5.mif"), .bias_file("b_1_5.mif"),
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
    .weight_file("w_1_6.mif"), .bias_file("b_1_6.mif"),
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
    .weight_file("w_1_7.mif"), .bias_file("b_1_7.mif"),
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
    .weight_file("weights\\w_1_8.mif"), .bias_file("b_1_8.mif"),
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
    .weight_file("w_1_9.mif"), .bias_file("b_1_9.mif"),
    .weight_sigmoid_in_width(weight_sigmoid_in_width), .activation(activation), .weightintwidht(weightintwidht)
) n_10 (
    .clk(clk), .rst(rst), .my_input(my_input), .valid_input(valid_input),
    .weight_value(weight_value), .valid_weight(valid_weight),
    .bias_value(bias_value), .valid_bias(valid_bias),
    .neuron_layer_no(layer_layer_no), .neuron_neuron_no(neuron_neuron_no),
    .valid_output(valid_output[9]),
    .neuron_out(neuron_out[9*data_width +: data_width])
);

// Neuron 11
neuron #(
    .data_width(data_width), .num_weights(num_weights), .layer_no(layer_no), .neuron_no(11),
    .weight_file("w_1_10.mif"), .bias_file("b_1_10.mif"),
    .weight_sigmoid_in_width(weight_sigmoid_in_width), .activation(activation), .weightintwidht(weightintwidht)
) n_11 (
    .clk(clk), .rst(rst), .my_input(my_input), .valid_input(valid_input),
    .weight_value(weight_value), .valid_weight(valid_weight),
    .bias_value(bias_value), .valid_bias(valid_bias),
    .neuron_layer_no(layer_layer_no), .neuron_neuron_no(neuron_neuron_no),
    .valid_output(valid_output[10]),
    .neuron_out(neuron_out[10*data_width +: data_width])
);

// Neuron 12
neuron #(
    .data_width(data_width), .num_weights(num_weights), .layer_no(layer_no), .neuron_no(12),
    .weight_file("w_1_11.mif"), .bias_file("b_1_11.mif"),
    .weight_sigmoid_in_width(weight_sigmoid_in_width), .activation(activation), .weightintwidht(weightintwidht)
) n_12 (
    .clk(clk), .rst(rst), .my_input(my_input), .valid_input(valid_input),
    .weight_value(weight_value), .valid_weight(valid_weight),
    .bias_value(bias_value), .valid_bias(valid_bias),
    .neuron_layer_no(layer_layer_no), .neuron_neuron_no(neuron_neuron_no),
    .valid_output(valid_output[11]),
    .neuron_out(neuron_out[11*data_width +: data_width])
);

// Neuron 13
neuron #(
    .data_width(data_width), .num_weights(num_weights), .layer_no(layer_no), .neuron_no(13),
    .weight_file("w_1_12.mif"), .bias_file("b_1_12.mif"),
    .weight_sigmoid_in_width(weight_sigmoid_in_width), .activation(activation), .weightintwidht(weightintwidht)
) n_13 (
    .clk(clk), .rst(rst), .my_input(my_input), .valid_input(valid_input),
    .weight_value(weight_value), .valid_weight(valid_weight),
    .bias_value(bias_value), .valid_bias(valid_bias),
    .neuron_layer_no(layer_layer_no), .neuron_neuron_no(neuron_neuron_no),
    .valid_output(valid_output[12]),
    .neuron_out(neuron_out[12*data_width +: data_width])
);

// Neuron 14
neuron #(
    .data_width(data_width), .num_weights(num_weights), .layer_no(layer_no), .neuron_no(14),
    .weight_file("w_1_13.mif"), .bias_file("b_1_13.mif"),
    .weight_sigmoid_in_width(weight_sigmoid_in_width), .activation(activation), .weightintwidht(weightintwidht)
) n_14 (
    .clk(clk), .rst(rst), .my_input(my_input), .valid_input(valid_input),
    .weight_value(weight_value), .valid_weight(valid_weight),
    .bias_value(bias_value), .valid_bias(valid_bias),
    .neuron_layer_no(layer_layer_no), .neuron_neuron_no(neuron_neuron_no),
    .valid_output(valid_output[13]),
    .neuron_out(neuron_out[13*data_width +: data_width])
);

// Neuron 15
neuron #(
    .data_width(data_width), .num_weights(num_weights), .layer_no(layer_no), .neuron_no(15),
    .weight_file("w_1_14.mif"), .bias_file("b_1_14.mif"),
    .weight_sigmoid_in_width(weight_sigmoid_in_width), .activation(activation), .weightintwidht(weightintwidht)
) n_15 (
    .clk(clk), .rst(rst), .my_input(my_input), .valid_input(valid_input),
    .weight_value(weight_value), .valid_weight(valid_weight),
    .bias_value(bias_value), .valid_bias(valid_bias),
    .neuron_layer_no(layer_layer_no), .neuron_neuron_no(neuron_neuron_no),
    .valid_output(valid_output[14]),
    .neuron_out(neuron_out[14*data_width +: data_width])
);

// Neuron 16
neuron #(
    .data_width(data_width), .num_weights(num_weights), .layer_no(layer_no), .neuron_no(16),
    .weight_file("w_1_15.mif"), .bias_file("b_1_15.mif"),
    .weight_sigmoid_in_width(weight_sigmoid_in_width), .activation(activation), .weightintwidht(weightintwidht)
) n_16 (
    .clk(clk), .rst(rst), .my_input(my_input), .valid_input(valid_input),
    .weight_value(weight_value), .valid_weight(valid_weight),
    .bias_value(bias_value), .valid_bias(valid_bias),
    .neuron_layer_no(layer_layer_no), .neuron_neuron_no(neuron_neuron_no),
    .valid_output(valid_output[15]),
    .neuron_out(neuron_out[15*data_width +: data_width])
);

// Neuron 17
neuron #(
    .data_width(data_width), .num_weights(num_weights), .layer_no(layer_no), .neuron_no(17),
    .weight_file("w_1_16.mif"), .bias_file("b_1_16.mif"),
    .weight_sigmoid_in_width(weight_sigmoid_in_width), .activation(activation), .weightintwidht(weightintwidht)
) n_17 (
    .clk(clk), .rst(rst), .my_input(my_input), .valid_input(valid_input),
    .weight_value(weight_value), .valid_weight(valid_weight),
    .bias_value(bias_value), .valid_bias(valid_bias),
    .neuron_layer_no(layer_layer_no), .neuron_neuron_no(neuron_neuron_no),
    .valid_output(valid_output[16]),
    .neuron_out(neuron_out[16*data_width +: data_width])
);
// Neuron 18
neuron #(
    .data_width(data_width), .num_weights(num_weights), .layer_no(layer_no), .neuron_no(18),
    .weight_file("w_1_17.mif"), .bias_file("b_1_17.mif"),
    .weight_sigmoid_in_width(weight_sigmoid_in_width), .activation(activation), .weightintwidht(weightintwidht)
) n_18 (
    .clk(clk), .rst(rst), .my_input(my_input), .valid_input(valid_input),
    .weight_value(weight_value), .valid_weight(valid_weight),
    .bias_value(bias_value), .valid_bias(valid_bias),
    .neuron_layer_no(layer_layer_no), .neuron_neuron_no(neuron_neuron_no),
    .valid_output(valid_output[17]),
    .neuron_out(neuron_out[17*data_width +: data_width])
);

// Neuron 19
neuron #(
    .data_width(data_width), .num_weights(num_weights), .layer_no(layer_no), .neuron_no(19),
    .weight_file("w_1_18.mif"), .bias_file("b_1_18.mif"),
    .weight_sigmoid_in_width(weight_sigmoid_in_width), .activation(activation), .weightintwidht(weightintwidht)
) n_19 (
    .clk(clk), .rst(rst), .my_input(my_input), .valid_input(valid_input),
    .weight_value(weight_value), .valid_weight(valid_weight),
    .bias_value(bias_value), .valid_bias(valid_bias),
    .neuron_layer_no(layer_layer_no), .neuron_neuron_no(neuron_neuron_no),
    .valid_output(valid_output[18]),
    .neuron_out(neuron_out[18*data_width +: data_width])
);
// Neuron 20
neuron #(
    .data_width(data_width), .num_weights(num_weights), .layer_no(layer_no), .neuron_no(20),
    .weight_file("w_1_19.mif"), .bias_file("b_1_19.mif"),
    .weight_sigmoid_in_width(weight_sigmoid_in_width), .activation(activation), .weightintwidht(weightintwidht)
) n_20 (
    .clk(clk), .rst(rst), .my_input(my_input), .valid_input(valid_input),
    .weight_value(weight_value), .valid_weight(valid_weight),
    .bias_value(bias_value), .valid_bias(valid_bias),
    .neuron_layer_no(layer_layer_no), .neuron_neuron_no(neuron_neuron_no),
    .valid_output(valid_output[19]),
    .neuron_out(neuron_out[19*data_width +: data_width])
);
// Neuron 21
neuron #(
    .data_width(data_width), .num_weights(num_weights), .layer_no(layer_no), .neuron_no(21),
    .weight_file("w_1_20.mif"), .bias_file("b_1_20.mif"),
    .weight_sigmoid_in_width(weight_sigmoid_in_width), .activation(activation), .weightintwidht(weightintwidht)
) n_21 (
    .clk(clk), .rst(rst), .my_input(my_input), .valid_input(valid_input),
    .weight_value(weight_value), .valid_weight(valid_weight),
    .bias_value(bias_value), .valid_bias(valid_bias),
    .neuron_layer_no(layer_layer_no), .neuron_neuron_no(neuron_neuron_no),
    .valid_output(valid_output[20]),
    .neuron_out(neuron_out[20*data_width +: data_width])
);
// Neuron 22
neuron #(
    .data_width(data_width), .num_weights(num_weights), .layer_no(layer_no), .neuron_no(22),
    .weight_file("w_1_21.mif"), .bias_file("b_1_21.mif"),
    .weight_sigmoid_in_width(weight_sigmoid_in_width), .activation(activation), .weightintwidht(weightintwidht)
) n_22 (
    .clk(clk), .rst(rst), .my_input(my_input), .valid_input(valid_input),
    .weight_value(weight_value), .valid_weight(valid_weight),
    .bias_value(bias_value), .valid_bias(valid_bias),
    .neuron_layer_no(layer_layer_no), .neuron_neuron_no(neuron_neuron_no),
    .valid_output(valid_output[21]),
    .neuron_out(neuron_out[21*data_width +: data_width])
);
// Neuron 23
neuron #(
    .data_width(data_width), .num_weights(num_weights), .layer_no(layer_no), .neuron_no(23),
    .weight_file("w_1_22.mif"), .bias_file("b_1_22.mif"),
    .weight_sigmoid_in_width(weight_sigmoid_in_width), .activation(activation), .weightintwidht(weightintwidht)
) n_23 (
    .clk(clk), .rst(rst), .my_input(my_input), .valid_input(valid_input),
    .weight_value(weight_value), .valid_weight(valid_weight),
    .bias_value(bias_value), .valid_bias(valid_bias),
    .neuron_layer_no(layer_layer_no), .neuron_neuron_no(neuron_neuron_no),
    .valid_output(valid_output[22]),
    .neuron_out(neuron_out[22*data_width +: data_width])
);

// Neuron 24
neuron #(
    .data_width(data_width), .num_weights(num_weights), .layer_no(layer_no), .neuron_no(24),
    .weight_file("w_1_23.mif"), .bias_file("b_1_23.mif"),
    .weight_sigmoid_in_width(weight_sigmoid_in_width), .activation(activation), .weightintwidht(weightintwidht)
) n_24 (
    .clk(clk), .rst(rst), .my_input(my_input), .valid_input(valid_input),
    .weight_value(weight_value), .valid_weight(valid_weight),
    .bias_value(bias_value), .valid_bias(valid_bias),
    .neuron_layer_no(layer_layer_no), .neuron_neuron_no(neuron_neuron_no),
    .valid_output(valid_output[23]),
    .neuron_out(neuron_out[23*data_width +: data_width])
);

// Neuron 25
neuron #(
    .data_width(data_width), .num_weights(num_weights), .layer_no(layer_no), .neuron_no(25),
    .weight_file("w_1_24.mif"), .bias_file("b_1_24.mif"),
    .weight_sigmoid_in_width(weight_sigmoid_in_width), .activation(activation), .weightintwidht(weightintwidht)
) n_25 (
    .clk(clk), .rst(rst), .my_input(my_input), .valid_input(valid_input),
    .weight_value(weight_value), .valid_weight(valid_weight),
    .bias_value(bias_value), .valid_bias(valid_bias),
    .neuron_layer_no(layer_layer_no), .neuron_neuron_no(neuron_neuron_no),
    .valid_output(valid_output[24]),
    .neuron_out(neuron_out[24*data_width +: data_width])
);

// Neuron 26
neuron #(
    .data_width(data_width), .num_weights(num_weights), .layer_no(layer_no), .neuron_no(26),
    .weight_file("w_1_25.mif"), .bias_file("b_1_25.mif"),
    .weight_sigmoid_in_width(weight_sigmoid_in_width), .activation(activation), .weightintwidht(weightintwidht)
) n_26 (
    .clk(clk), .rst(rst), .my_input(my_input), .valid_input(valid_input),
    .weight_value(weight_value), .valid_weight(valid_weight),
    .bias_value(bias_value), .valid_bias(valid_bias),
    .neuron_layer_no(layer_layer_no), .neuron_neuron_no(neuron_neuron_no),
    .valid_output(valid_output[25]),
    .neuron_out(neuron_out[25*data_width +: data_width])
);

// Neuron 27
neuron #(
    .data_width(data_width), .num_weights(num_weights), .layer_no(layer_no), .neuron_no(27),
    .weight_file("w_1_26.mif"), .bias_file("b_1_26.mif"),
    .weight_sigmoid_in_width(weight_sigmoid_in_width), .activation(activation), .weightintwidht(weightintwidht)
) n_27 (
    .clk(clk), .rst(rst), .my_input(my_input), .valid_input(valid_input),
    .weight_value(weight_value), .valid_weight(valid_weight),
    .bias_value(bias_value), .valid_bias(valid_bias),
    .neuron_layer_no(layer_layer_no), .neuron_neuron_no(neuron_neuron_no),
    .valid_output(valid_output[26]),
    .neuron_out(neuron_out[26*data_width +: data_width])
);

// Neuron 28
neuron #(
    .data_width(data_width), .num_weights(num_weights), .layer_no(layer_no), .neuron_no(28),
    .weight_file("w_1_27.mif"), .bias_file("b_1_27.mif"),
    .weight_sigmoid_in_width(weight_sigmoid_in_width), .activation(activation), .weightintwidht(weightintwidht)
) n_28 (
    .clk(clk), .rst(rst), .my_input(my_input), .valid_input(valid_input),
    .weight_value(weight_value), .valid_weight(valid_weight),
    .bias_value(bias_value), .valid_bias(valid_bias),
    .neuron_layer_no(layer_layer_no), .neuron_neuron_no(neuron_neuron_no),
    .valid_output(valid_output[27]),
    .neuron_out(neuron_out[27*data_width +: data_width])
);
// Neuron 29
neuron #(
    .data_width(data_width), .num_weights(num_weights), .layer_no(layer_no), .neuron_no(29),
    .weight_file("w_1_28.mif"), .bias_file("b_1_28.mif"),
    .weight_sigmoid_in_width(weight_sigmoid_in_width), .activation(activation), .weightintwidht(weightintwidht)
) n_29 (
    .clk(clk), .rst(rst), .my_input(my_input), .valid_input(valid_input),
    .weight_value(weight_value), .valid_weight(valid_weight),
    .bias_value(bias_value), .valid_bias(valid_bias),
    .neuron_layer_no(layer_layer_no), .neuron_neuron_no(neuron_neuron_no),
    .valid_output(valid_output[28]),
    .neuron_out(neuron_out[28*data_width +: data_width])
);

// Neuron 30
neuron #(
    .data_width(data_width), .num_weights(num_weights), .layer_no(layer_no), .neuron_no(30),
    .weight_file("w_1_29.mif"), .bias_file("b_1_29.mif"),
    .weight_sigmoid_in_width(weight_sigmoid_in_width), .activation(activation), .weightintwidht(weightintwidht)
) n_30 (
    .clk(clk), .rst(rst), .my_input(my_input), .valid_input(valid_input),
    .weight_value(weight_value), .valid_weight(valid_weight),
    .bias_value(bias_value), .valid_bias(valid_bias),
    .neuron_layer_no(layer_layer_no), .neuron_neuron_no(neuron_neuron_no),
    .valid_output(valid_output[29]),
    .neuron_out(neuron_out[29*data_width +: data_width])
);
endmodule

