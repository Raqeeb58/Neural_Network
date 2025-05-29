import sys

outputPath = "./testData/"
headerFilePath = "./testData/"
import os

# 💡 Create output directory if it doesn't exist
os.makedirs(outputPath, exist_ok=True)

# 💡 Handle Python 2/3 compatibility for pickle
try:
    import cPickle as pickle
except:
    import pickle

import gzip
import numpy as np

# 💡 Fixed-point configuration parameters
dataWidth = 16                   # Total bits per data point
IntSize = 1                      # Integer bits (including sign)

# 💡 Get test image index from command line or default to 3
try:
    testDataNum = int(sys.argv[1])
except:
    testDataNum = 3

def DtoB(num,dataWidth,fracBits):
    """
    💡 Convert floating-point number to fixed-point two's complement integer
    Args:
        num: Input value (float)
        dataWidth: Total bit width (int)
        fracBits: Fractional bits (int)
    Returns:
        Integer representation in two's complement format
    """
    if num >= 0:
        num = num * (2**fracBits)
        d = int(num)
    else:
        num = -num
        num = num * (2**fracBits)        # Scale to integer
        num = int(num)
        if num == 0:
            d = 0
        else:
            # 💡 Calculate two's complement for negative numbers
            d = 2**dataWidth - num
    return d

def load_data():
    """💡 Load MNIST dataset from compressed pickle file"""
    f = gzip.open('mnist.pkl.gz', 'rb')  # MNIST data location
    try:
        # 💡 Python 3 compatibility with latin1 encoding
        training_data, validation_data, test_data = pickle.load(f,encoding='latin1')
    except:
        # 💡 Python 2 fallback
        training_data, validation_data, test_data = pickle.load(f)
    f.close()
    return (training_data, validation_data, test_data)

def genTestData(dataWidth,IntSize,testDataNum):
    """💡 Generate test files for single MNIST image"""
    dataHeaderFile = open(headerFilePath+"dataValues.h","w")
    dataHeaderFile.write("int dataValues[]={")
    tr_d, va_d, te_d = load_data()

    # 💡 Reshape image to 784x1 vector (28x28 pixels)
    test_inputs = [np.reshape(x, (1, 784)) for x in te_d[0]]
    x = len(test_inputs[0][0])
    d=dataWidth-IntSize  # Calculate fractional bits

    # 💡 Create output files:
    count = 0
    fileName = 'test_data.txt'            # Binary pixel values
    f = open(outputPath+fileName,'w')
    fileName = 'visual_data'+str(te_d[1][testDataNum])+'.txt'  # ASCII art
    g = open(outputPath+fileName,'w')
    k = open('testData.txt','w')          # Raw decimal values

    for i in range(0,x):
        # 💡 Write raw decimal values
        k.write(str(test_inputs[testDataNum][0][i])+',')

        # 💡 Convert to fixed-point
        dInDec = DtoB(test_inputs[testDataNum][0][i],dataWidth,d)
        myData = bin(dInDec)[2:]  # Convert to binary string

        # 💡 Write to header file (C array format)
        dataHeaderFile.write(str(dInDec)+',')

        # 💡 Write binary to file (LSB first)
        f.write(myData+'\n')

        # 💡 Create visual representation (threshold at 0)
        if test_inputs[testDataNum][0][i]>0:
            g.write(str(1)+' ')
        else:
            g.write(str(0)+' ')

        count += 1
        if count%28 == 0:  # Newline every 28 pixels
            g.write('\n')

    # 💡 Close all files and write footer
    k.close()
    g.close()
    f.close()
    dataHeaderFile.write('0};\n')
    dataHeaderFile.write('int result='+str(te_d[1][testDataNum])+';\n')
    dataHeaderFile.close()

def genAllTestData(dataWidth,IntSize):
    """💡 Generate test files for ALL MNIST test images"""
    tr_d, va_d, te_d = load_data()
    test_inputs = [np.reshape(x, (1, 784)) for x in te_d[0]]
    x = len(test_inputs[0][0])
    d=dataWidth-IntSize

    for i in range(len(test_inputs)):
        # 💡 Create zero-padded filenames
        if i < 10:
            ext = "000"+str(i)
        elif i < 100:
            ext = "00"+str(i)
        elif i < 1000:
            ext = "0"+str(i)
        else:
            ext = str(i)

        fileName = 'test_data_'+ext+'.txt'
        f = open(outputPath+fileName,'w')

        for j in range(0,x):
            # 💡 Convert and write pixel values
            dInDec = DtoB(test_inputs[i][0][j],dataWidth,d)
            myData = bin(dInDec)[2:]
            f.write(myData+'\n')

        # 💡 Append label as binary at end of file
        f.write(bin(DtoB((te_d[1][i]),dataWidth,0))[2:])
        f.close()

if __name__ == "__main__":
    # 💡 Generate single test case (index 1) and all test data
    genTestData(dataWidth,IntSize,testDataNum=1)
    genAllTestData(dataWidth,IntSize)

# 💡 Package output files for download
import shutil
shutil.make_archive("test_data", 'zip', "./testData/")
