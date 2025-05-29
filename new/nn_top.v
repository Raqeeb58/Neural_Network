`include "include.v"

// Top-level module for a multi-layer neural network
module nn_top (
    clk, rst, my_input, valid_input, weight_value, valid_weight, bias_value, valid_bias,
    layer_no, neuron_no, valid_out, nn_output
);
    // Clock and reset signals
    input clk, rst;
    // Input data and control signals
    input [`data_width-1:0] my_input;
    input valid_input;
    input [31:0] weight_value;
    input valid_weight;
    input [31:0] bias_value;
    input valid_bias;
    input [31:0] layer_no;
    input [31:0] neuron_no;
    // Output signals
    output valid_out;
    output [`data_width-1:0] nn_output;

    // ===== Layer 1 =====
    // Wires and registers for layer 1 outputs and control
    wire [`no_neuron_layer1-1:0] valid_out_layer1;
    wire [`no_neuron_layer1*`data_width-1:0] neuron_1_out;
    reg [`no_neuron_layer1*`data_width-1:0] hold_data_1;
    reg [`data_width-1:0] out_data_1;
    reg out_data_1_valid;

    // Instantiation of layer 1 module
    layer_1 #(
        .no_neuron(`no_neuron_layer1),
        .num_weights(`no_weights_layer1),
        .data_width(`data_width),
        .layer_no(1),
        .weight_sigmoid_in_width(`weight_sigmoid_in_width),
        .weightintwidht(`weightintwidht),
        .activation(`Layer1ActType)
    ) l1 (
        .clk(clk),
        .rst(rst),
        .my_input(my_input),
        .valid_input(valid_input),
        .weight_value(weight_value),
        .bias_value(bias_value),
        .valid_weight(valid_weight),
        .valid_bias(valid_bias),
        .neuron_neuron_no(neuron_no),
        .layer_layer_no(layer_no),
        .valid_output(valid_out_layer1),
        .neuron_out(neuron_1_out)
    );

    // FSM states for output serialization
    localparam IDLE = 1'b0, SEND = 1'b1;
    reg state_1;
    integer count_1;

    // Output serialization for layer 1
    always @(posedge clk) begin
        if (rst) begin
            state_1 <= IDLE;
            count_1 <= 0;
            out_data_1_valid <= 1'b0;
        end else begin
            case(state_1)
                IDLE: begin
                    count_1 <= 0;
                    out_data_1_valid <= 1'b0;
                    // Wait for valid output from layer 1
                    if (valid_out_layer1[0] == 1'b1) begin
                        hold_data_1 <= neuron_1_out;
                        state_1 <= SEND;
                    end
                end
                SEND: begin
                    // Output serialized neuron data
                    out_data_1 <= hold_data_1[`data_width-1:0];
                    hold_data_1 <= hold_data_1 >> `data_width;
                    count_1 <= count_1 + 1;
                    out_data_1_valid <= 1'b1;
                    // Reset after all neurons are sent
                    if (count_1 == `no_neuron_layer1) begin
                        count_1 <= 0;
                        state_1 <= IDLE;
                        out_data_1_valid <= 1'b0;
                    end
                end
            endcase
        end
    end

    // ===== Layer 2 =====
    wire [`no_neuron_layer2-1:0] valid_out_layer2;
    wire [`no_neuron_layer2*`data_width-1:0] neuron_2_out;
    reg [`no_neuron_layer2*`data_width-1:0] hold_data_2;
    reg [`data_width-1:0] out_data_2;
    reg out_data_2_valid;

    // Instantiation of layer 2 module
    layer_2 #(
        .no_neuron(`no_neuron_layer2),
        .num_weights(`no_weights_layer2),
        .data_width(`data_width),
        .layer_no(2),
        .weight_sigmoid_in_width(`weight_sigmoid_in_width),
        .weightintwidht(`weightintwidht),
        .activation(`Layer2ActType)
    ) l2 (
        .clk(clk),
        .rst(rst),
        .my_input(out_data_1),
        .valid_input(out_data_1_valid),
        .weight_value(weight_value),
        .bias_value(bias_value),
        .valid_weight(valid_weight),
        .valid_bias(valid_bias),
        .neuron_neuron_no(neuron_no),
        .layer_layer_no(layer_no),
        .valid_output(valid_out_layer2),
        .neuron_out(neuron_2_out)
    );

    reg state_2;
    integer count_2;

    // Output serialization for layer 2
    always @(posedge clk) begin
        if (rst) begin
            state_2 <= IDLE;
            count_2 <= 0;
            out_data_2_valid <= 1'b0;
        end else begin
            case(state_2)
                IDLE: begin
                    count_2 <= 0;
                    out_data_2_valid <= 1'b0;
                    if (valid_out_layer2[0] == 1'b1) begin
                        hold_data_2 <= neuron_2_out;
                        state_2 <= SEND;
                    end
                end
                SEND: begin
                    out_data_2 <= hold_data_2[`data_width-1:0];
                    hold_data_2 <= hold_data_2 >> `data_width;
                    count_2 <= count_2 + 1;
                    out_data_2_valid <= 1'b1;
                    if (count_2 == `no_neuron_layer2) begin
                        count_2 <= 0;
                        state_2 <= IDLE;
                        out_data_2_valid <= 1'b0;
                    end
                end
            endcase
        end
    end

    // ===== Layer 3 =====
    wire [`no_neuron_layer3-1:0] valid_out_layer3;
    wire [`no_neuron_layer3*`data_width-1:0] neuron_3_out;
    reg [`no_neuron_layer3*`data_width-1:0] hold_data_3;
    reg [`data_width-1:0] out_data_3;
    reg out_data_3_valid;

    // Instantiation of layer 3 module
    layer_3 #(
        .no_neuron(`no_neuron_layer3),
        .num_weights(`no_weights_layer3),
        .data_width(`data_width),
        .layer_no(3),
        .weight_sigmoid_in_width(`weight_sigmoid_in_width),
        .weightintwidht(`weightintwidht),
        .activation(`Layer3ActType)
    ) l3 (
        .clk(clk),
        .rst(rst),
        .my_input(out_data_2),
        .valid_input(out_data_2_valid),
        .weight_value(weight_value),
        .bias_value(bias_value),
        .valid_weight(valid_weight),
        .valid_bias(valid_bias),
        .neuron_neuron_no(neuron_no),
        .layer_layer_no(layer_no),
        .valid_output(valid_out_layer3),
        .neuron_out(neuron_3_out)
    );

    reg state_3;
    integer count_3;

    // Output serialization for layer 3
    always @(posedge clk) begin
        if (rst) begin
            state_3 <= IDLE;
            count_3 <= 0;
            out_data_3_valid <= 1'b0;
        end else begin
            case(state_3)
                IDLE: begin
                    count_3 <= 0;
                    out_data_3_valid <= 1'b0;
                    if (valid_out_layer3[0] == 1'b1) begin
                        hold_data_3 <= neuron_3_out;
                        state_3 <= SEND;
                    end
                end
                SEND: begin
                    out_data_3 <= hold_data_3[`data_width-1:0];
                    hold_data_3 <= hold_data_3 >> `data_width;
                    count_3 <= count_3 + 1;
                    out_data_3_valid <= 1'b1;
                    if (count_3 == `no_neuron_layer3) begin
                        count_3 <= 0;
                        state_3 <= IDLE;
                        out_data_3_valid <= 1'b0;
                    end
                end
            endcase
        end
    end

    // ===== Layer 4 =====
    wire [`no_neuron_layer4-1:0] valid_out_layer4;
    wire [`no_neuron_layer4*`data_width-1:0] neuron_4_out;
    reg [`no_neuron_layer4*`data_width-1:0] hold_data_4;
    reg [`data_width-1:0] out_data_4;
    reg out_data_4_valid;

    // Instantiation of layer 4 module
    layer_4 #(
        .no_neuron(`no_neuron_layer4),
        .num_weights(`no_weights_layer4),
        .data_width(`data_width),
        .layer_no(4),
        .weight_sigmoid_in_width(`weight_sigmoid_in_width),
        .weightintwidht(`weightintwidht),
        .activation(`Layer3ActType)
    ) l4 (
        .clk(clk),
        .rst(rst),
        .my_input(out_data_3),
        .valid_input(out_data_3_valid),
        .weight_value(weight_value),
        .bias_value(bias_value),
        .valid_weight(valid_weight),
        .valid_bias(valid_bias),
        .neuron_neuron_no(neuron_no),
        .layer_layer_no(layer_no),
        .valid_output(valid_out_layer4),
        .neuron_out(neuron_4_out)
    );

    reg state_4;
    integer count_4;

    // Output serialization for layer 4
    always @(posedge clk) begin
        if (rst) begin
            state_4 <= IDLE;
            count_4 <= 0;
            out_data_4_valid <= 1'b0;
        end else begin
            case(state_4)
                IDLE: begin
                    count_4 <= 0;
                    out_data_4_valid <= 1'b0;
                    if (valid_out_layer4[0] == 1'b1) begin
                        hold_data_4 <= neuron_4_out;
                        state_4 <= SEND;
                    end
                end
                SEND: begin
                    out_data_4 <= hold_data_4[`data_width-1:0];
                    hold_data_4 <= hold_data_4 >> `data_width;
                    count_4 <= count_4 + 1;
                    out_data_4_valid <= 1'b1;
                    if (count_4 == `no_neuron_layer4) begin
                        count_4 <= 0;
                        state_4 <= IDLE;
                        out_data_4_valid <= 1'b0;
                    end
                end
            endcase
        end
    end

    // ===== Output Layer (Max Finder) =====
    // Finds the maximum value among the outputs of the last layer
    max_finder #(
        .data_width(`data_width),
        .no_inputs(`no_neuron_layer4)
    ) mf (
        .clk(clk),
        .rst(rst),
        .my_input(neuron_4_out),
        .valid_input(valid_out_layer4),
        .data_out(nn_output),
        .valid_output(valid_out)
    );

endmodule
