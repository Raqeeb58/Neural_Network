Verilog-Based Multi-Layer Neural Network Inference Core

This project implements a 4-layer feedforward neural network in Verilog, designed for hardware inference on FPGAs or ASICs. The network supports runtime loading of weights and biases, includes activation functions, and features a max-finder output module for classification tasks.

Features

4 Sequential Neural Layers: Modular design with parameterized neuron count and activation function.

Runtime Configurability:

Load weights and biases per neuron using control signals.

Supports layer and neuron addressing.

Streaming Interface:

Inputs are serialized and processed layer by layer.

Output is the maximum-activated neuron value (classification index).

Layer Output Serialization: Each layer's outputs are serialized before being passed to the next.

Max Finder: Identifies the neuron with the highest activation in the final layer.

Python Integration for Testing:

Generate LUTs (Look-Up Tables) for sigmoid, weights, biases, and input test data using provided Python scripts.

Supports pretrained mode, where weights and biases are loaded from external files instead of input ports.


⚙️ Parameters (from include.v)
Define key hyperparameters like:

data_width: Bit width of data (e.g. 16 or 32)

no_neuron_layerX: Number of neurons in layer X

no_weights_layerX: Number of weights per neuron in layer X

LayerXActType: Activation type per layer (e.g. ReLU, sigmoid)


🚀 How It Works
Weight/Bias Loading: Use layer_no, neuron_no, and corresponding valid signals to feed weights and biases into the appropriate neuron.

Inference:

Input data is passed to the first layer.

Each layer serializes and forwards output to the next.

Layer outputs are registered and controlled using internal FSMs.

Classification Output:

The last layer's outputs go to max_finder, which selects the neuron with the highest activation.

The selected neuron’s index is output via nn_output.

🧪 Testing
Testbenches should simulate:

Sequential weight/bias loading.

Feeding a batch of input vectors.

Checking correctness of classification output.

📦 Files
nn_top.v: Top-level module connecting all layers and final classifier.

layer_X.v: Layer modules with configurable neurons and activation.

max_finder.v: Module to select the max-activated output.

include.v: Global parameter definitions.



