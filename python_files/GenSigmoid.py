import math

def sigmoid(x):
    """Compute sigmoid function with overflow protection.

    Args:
        x (float): Input value

    Returns:
        float: Sigmoid value between 0-1
    """
    try:
        return 1 / (1 + math.exp(-x))
    except OverflowError:  # Handle extreme values
        return 0.0 if x < 0 else 1.0  # Saturate at boundaries

def DtoB(num, dataWidth, fracBits):
    """Convert floating-point number to fixed-point binary (Q-format).

    Args:
        num (float): Value to convert (0-1 range expected)
        dataWidth (int): Total bit width
        fracBits (int): Fractional bits (determines Q-format)

    Returns:
        str: Binary string in two's complement format
    """
    scale = 1 << fracBits  # 2^fracBits scaling factor
    fixed_val = int(round(num * scale))  # Quantize to integer

    # Clamp to valid Q-format range
    min_val = -(1 << (dataWidth - 1))
    max_val = (1 << (dataWidth - 1)) - 1
    fixed_val = max(min(fixed_val, max_val), min_val)

    # Two's complement conversion for negative numbers
    if fixed_val < 0:
        fixed_val = (1 << dataWidth) + fixed_val  # Wrap around

    return format(fixed_val, f'0{dataWidth}b')  # Zero-padded binary

def genSigContent(dataWidth, sigmoidSize, weightIntSize, inputIntSize):
    """Generate sigmoid LUT for hardware implementation.

    Args:
        dataWidth (int): Total bits per entry (16 = Q1.15)
        sigmoidSize (int): Address bits (10 → 1024 entries)
        weightIntSize (int): Weight integer bits
        inputIntSize (int): Input integer bits
    """
    num_entries = 1 << sigmoidSize  # 2^sigmoidSize entries
    total_int_bits = weightIntSize + inputIntSize  # Max 5 bits (4+1)
    fracBits = dataWidth - 1  # Q1.15 format (1 int, 15 frac)

    # Input range covers all possible combinations
    min_input = - (2 ** (total_int_bits - 1))  # -16 for 5 bits
    max_input = (2 ** (total_int_bits - 1))    # +16 for 5 bits
    step_size = (max_input - min_input) / num_entries  # 0.03125 step

    with open("sigContent.mif", "w") as f:
        for i in range(num_entries):
            # Centered sampling: x = -16 + (i+0.5)*0.03125
            x = min_input + (i + 0.5) * step_size
            y = sigmoid(x)
            bin_str = DtoB(y, dataWidth, fracBits)
            f.write(bin_str + '\n')

    # Note: Actual middle index (512) is at x=0.015625, not exactly 0
    print(f"Generated sigContent.mif with {num_entries} entries. Index {num_entries//2} = sigmoid(0).")

if __name__ == "__main__":
    # Generates 1024-entry LUT for 5-bit integer inputs (4 weight + 1 input)
    # Output format: 16-bit Q1.15 (1 sign, 15 fractional bits)
    genSigContent(dataWidth=16, sigmoidSize=10, weightIntSize=4, inputIntSize=1)

    # Google Colab specific: Download generated file
    from google.colab import files
    files.download("sigContent.mif")

