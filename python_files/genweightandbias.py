import tensorflow as tf
import json

# Load and preprocess MNIST dataset
mnist = tf.keras.datasets.mnist
(x_train, y_train), (x_test,y_test) = mnist.load_data()
# Normalize pixel values to 0-1 range (original 0-255)
x_train = tf.keras.utils.normalize(x_train, axis=1)
x_test = tf.keras.utils.normalize(x_test, axis=1)

# Define model architecture
model = tf.keras.models.Sequential()
model.add(tf.keras.layers.Flatten())  # Convert 28x28 images to 784-element vectors
model.add(tf.keras.layers.Dense(30, activation=tf.nn.sigmoid))  # Hidden layer 1
model.add(tf.keras.layers.Dense(30, activation=tf.nn.sigmoid))  # Hidden layer 2
model.add(tf.keras.layers.Dense(10, activation=tf.nn.sigmoid))  # Output-like layer
model.add(tf.keras.layers.Dense(10, activation=tf.nn.sigmoid))  # Final output layer

# Compile model with appropriate settings
model.compile(
    optimizer='adam',  # Adaptive learning rate optimizer
    loss='sparse_categorical_crossentropy',  # For integer-encoded labels
    metrics=['accuracy']
)

# Train the model (consider adding validation split)
model.fit(x_train, y_train, epochs=20)  # 20 passes through entire dataset

# Evaluate model performance
(val_loss, val_accuracy) = model.evaluate(x_test, y_test)
print(f"\nTest Accuracy: {val_accuracy:.4f}, Test Loss: {val_loss:.4f}")

# Extract and process weights/biases
weightList = []
biasList = []
# Start from 1 to skip Flatten layer (no parameters)
for i in range(1, len(model.layers)):
    layer = model.layers[i]
    weights = layer.get_weights()[0]
    # Transpose weights for alternative format (output x input)
    weightList.append((weights.T).tolist())

    # Convert biases to list of single-element lists
    bias = [[float(b)] for b in layer.get_weights()[1]]
    biasList.append(bias)

# Save parameters to file
data = {
    "weights": weightList,
    "biases": biasList
}
with open('network_params.json', 'w') as f:  # Better to use .json extension
    json.dump(data, f, indent=4)  # Add indentation for readability

# For Google Colab download
from google.colab import files
files.download('network_params.json')
