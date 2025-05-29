import json
import os

# Fixed-point configuration parameters
dataWidth = 16           # Total bits for fixed-point representation
dataIntWidth = 1         # Integer bits for data (e.g., activations)
weightIntWidth = 4       # Integer bits for weights
inputFile = "/content/weightsandbiases.txt"  # Path to JSON with weights/biases

# Derived fixed-point parameters
dataFracWidth = dataWidth - dataIntWidth
weightFracWidth = dataWidth - weightIntWidth
biasIntWidth = dataIntWidth + weightIntWidth
biasFracWidth = dataWidth - biasIntWidth

# Output and header file paths
outputPath = "./w_b/"
headerPath = "./"

# Ensure output directory exists
os.makedirs(outputPath, exist_ok=True)

def DtoB(num, dataWidth, fracBits):
    """
    Convert a floating-point number to fixed-point two's complement integer.
    Args:
        num (float): Input value
        dataWidth (int): Total number of bits
        fracBits (int): Number of fractional bits
    Returns:
        int: Two's complement integer representation
    """
    if num >= 0:
        num = num * (2 ** fracBits)
        num = int(num)
        d = num
    else:
        num = -num
        num = num * (2 ** fracBits)
        num = int(num)
        if num == 0:
            d = 0
        else:
            d = 2 ** dataWidth - num  # Two's complement for negative numbers
    return d

def genWaitAndBias(dataWidth, weightFracWidth, biasFracWidth, inputFile):
    """
    Generate .mif files and C header files for weights and biases in fixed-point.
    Args:
        dataWidth (int): Total bits for representation
        weightFracWidth (int): Fractional bits for weights
        biasFracWidth (int): Fractional bits for biases
        inputFile (str): Path to JSON with weights and biases
    """
    weightIntWidth = dataWidth - weightFracWidth
    biasIntWidth = dataWidth - biasFracWidth

    # Load weights and biases from JSON file
    with open(inputFile, "r") as myDataFile:
        myData = myDataFile.read()
    myDict = json.loads(myData)
    myWeights = myDict['weights']
    myBiases = myDict['biases']

    # Prepare C header file for weights
    with open(headerPath + "weightValues.h", "w") as weightHeaderFile:
        weightHeaderFile.write("int weightValues[]={")
        for layer in range(len(myWeights)):
            for neuron in range(len(myWeights[layer])):
                fi = f'w_{layer+1}_{neuron}.mif'
                with open(outputPath + fi, 'w') as f:
                    for weight in range(len(myWeights[layer][neuron])):
                        # Handle extremely small values (scientific notation)
                        if 'e' in str(myWeights[layer][neuron][weight]):
                            p = '0'
                            wInDec = 0
                        else:
                            # Clamp weights to representable range
                            if myWeights[layer][neuron][weight] > 2 ** (weightIntWidth - 1):
                                myWeights[layer][neuron][weight] = 2 ** (weightIntWidth - 1) - 2 ** (-weightFracWidth)
                            elif myWeights[layer][neuron][weight] < -2 ** (weightIntWidth - 1):
                                myWeights[layer][neuron][weight] = -2 ** (weightIntWidth - 1)
                            wInDec = DtoB(myWeights[layer][neuron][weight], dataWidth, weightFracWidth)
                            p = bin(wInDec)[2:]  # Remove '0b' prefix
                        f.write(p + '\n')
                        weightHeaderFile.write(str(wInDec) + ',')
        weightHeaderFile.write('0};\n')  # End of array

    # Prepare C header file for biases
    with open(headerPath + "biasValues.h", "w") as biasHeaderFile:
        biasHeaderFile.write("int biasValues[]={")
        for layer in range(len(myBiases)):
            for neuron in range(len(myBiases[layer])):
                fi = f'b_{layer+1}_{neuron}.mif'
                p = myBiases[layer][neuron][0]
                if 'e' in str(p):  # Remove very small values with exponents
                    res = '0'
                    bInDec = 0
                else:
                    # Clamp bias to representable range
                    if p > 2 ** (biasIntWidth - 1):
                        p = 2 ** (biasIntWidth - 1) - 2 ** (-biasFracWidth)
                    elif p < -2 ** (biasIntWidth - 1):
                        p = -2 ** (biasIntWidth - 1)
                    bInDec = DtoB(p, dataWidth, biasFracWidth)
                    res = bin(bInDec)[2:]
                with open(outputPath + fi, 'w') as f:
                    f.write(res)
                biasHeaderFile.write(str(bInDec) + ',')
        biasHeaderFile.write('0};\n')  # End of array

if __name__ == "__main__":
    genWaitAndBias(dataWidth, weightFracWidth, biasFracWidth, inputFile)

import shutil

# Zip all generated .mif files for easy download
shutil.make_archive('w_b_files', 'zip', './w_b')

# For Google Colab: download the zip file
from google.colab import files
files.download('w_b_files.zip')
