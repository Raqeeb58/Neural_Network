`timescale 1ns/1ps
//`include "neuron.v"

module tb_layer;
    parameter no_neuron = 30;
    parameter data_width = 16;
    parameter num_weights = 784;
    parameter weight_sigmoid_in_width = 10;
    parameter weightintwidht = 1;
    parameter layer_no = 1;
    

    // Inputs
    logic clk = 0, rst = 1;
    logic [data_width-1:0] my_input;
    logic valid_input = 0;
    logic [31:0] weight_value, bias_value;
    logic valid_weight = 0, valid_bias = 0;
    logic [31:0] layer_layer_no , neuron_neuron_no;

    // Outputs
    logic valid_output;
    logic [data_width-1:0] neuron_out;

    // Clock generation
    always #5 clk = ~clk;

    // DUT
    /*layer_1 #(
    .no_neuron(no_neuron),
    .num_weights(num_weights),
    .data_width(data_width),
    .layer_no(layer_no),
    .weight_sigmoid_in_width(weight_sigmoid_in_width),
    .weightintwidht(weightintwidht),
    .activation("sigmoid")
) uut(
    .clk(clk), .rst(rst), .my_input(my_input), .valid_input(valid_input),
        .weight_value(weight_value), .valid_weight(valid_weight),
        .bias_value(bias_value), .valid_bias(valid_bias),
        .layer_layer_no(layer_layer_no), .neuron_neuron_no(neuron_neuron_no),
        .valid_output(valid_output), .neuron_out(neuron_out)
);*/
 top_module uut(clk,rst,my_input,valid_input,weight_value,valid_weight,bias_value,valid_bias,layer_no,neuron_no,valid_out,nn_output);
input clk,rst;
input [`data_width-1:0]my_input;
input valid_input;
input [31:0]weight_value;
input valid_weight;
input [31:0]bias_value;
input valid_bias;
input [31:0]layer_no;
input [31:0]neuron_no;
output valid_out;
output [`data_width-1:0]nn_output;

















 // Input data array
 logic [data_width-1:0] input_data [0:num_weights-1];
    parameter int NEURONS_PER_LAYER = no_neuron;
    parameter int WEIGHTS_PER_NEURON = num_weights;
    // Task: load weights and bias
    task load_weights_and_biases();
        string wfile, bfile;
        integer wfd, bfd;
        integer wval, bval;
        for (int n = 0; n < NEURONS_PER_LAYER; n++)
        begin
            $display("Loading layer %0d, neuron %0d",1, n);
            wfile = $sformatf("C:\\Users\\raqeeb\\Downloads\\weights\\w_%0d_%0d.mif", layer_no,n);
            bfile = $sformatf("C:\\Users\\raqeeb\\Downloads\\bias\\b_%0d_%0d.mif", layer_no,n);
            $display("Opening weight file: %s", wfile);
            $display("Opening bias file: %s", bfile);
            wfd = $fopen(wfile, "r");
            bfd = $fopen(bfile, "r");
            if (wfd == 0 || bfd == 0) 
            begin
                $display("ERROR: Failed to open weight or bias file.");
                $finish;
            end
            layer_layer_no = 1;
            neuron_neuron_no = n+1;
            @(posedge clk);
            for (int w = 0; w < num_weights; w++) 
            begin
                if ($fscanf(wfd, "%b\n", wval) != 1) 
                begin
                    $display("ERROR reading weight at index %0d", w);
                    $finish;
                end
                weight_value = wval;
                valid_weight = 1;
                @(posedge clk);
            end
            valid_weight = 0;
            if ($fscanf(bfd, "%b\n", bval) != 1) 
            begin
                $display("ERROR reading bias");
                $finish;
            end
            bias_value = bval;
            valid_bias = 1;
            @(posedge clk);
            valid_bias = 0;

            $fclose(wfd);
            $fclose(bfd);
        end
    endtask    
    // Task: load input values
    task load_inputs();
        integer fd, status;
        fd = $fopen("C:\\Users\\raqeeb\\Downloads\\test_data\\test_data_0000.txt", "r");
        if (fd == 0) 
        begin
            $display("ERROR opening input file.");
            $finish;
        end

        for (int i = 0; i < num_weights; i++) begin
            status = $fscanf(fd, "%b\n", input_data[i]);
            if (status != 1) 
            begin
                $display("ERROR reading input at index %0d", i);
                $finish;
            end
        end
        $fclose(fd);
    endtask

    // Initial simulation flow
    initial begin
       // $display("Starting Neuron Testbench");
        //$dumpfile("tb_neuron.vcd");
        //$dumpvars(0, tb_layer);

        // Hold reset for a few cycles
         rst = 1;
        valid_input = 0;
        valid_weight = 0;
        valid_bias = 0;
        @(posedge clk); @(posedge clk);
        rst = 0;


        // Load weights, bias, and inputs
        load_weights_and_biases();
        load_inputs();

        // Feed inputs sequentially
        for (int i = 0; i < num_weights; i++) begin
            @(posedge clk);
            my_input <= input_data[i];
            valid_input <= 1;
        end

        // Deassert input
        @(posedge clk);
        valid_input <= 0;

        // Wait for output    
    end

endmodule



