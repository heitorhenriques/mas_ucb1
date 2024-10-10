from matplotlib import pyplot as plt
import numpy as np
import networkx as nx
import pandas as pd
from scipy.spatial.distance import euclidean

# Function to read CSV data
def read_csv_data(file_path):
    data = pd.read_csv(file_path)
    return data["Average Time (ms)"].astype(float).tolist()

# Simulate a change point scenario by combining two CSV datasets
def simulate_combined_data(local_file, sharding_file):
    local_data = read_csv_data(local_file)
    sharding_data = read_csv_data(sharding_file)
    return sharding_data[:45] + local_data[45:90]

# Normalize the time series data using Min-Max scaling
def normalize_data(data):
    min_val = np.min(data)
    max_val = np.max(data)
    return [(x - min_val) / (max_val - min_val) for x in data]

# File paths for datasets
local_file = r"C:\Users\heiit\Documents\np1.2\mas_ucb1\results\datasets\case3\Local.csv"
sharding_file = r"C:\Users\heiit\Documents\np1.2\mas_ucb1\results\datasets\case3\Sharding.csv"

# Step 1: Load and normalize the combined data
combined_time_series = simulate_combined_data(local_file, sharding_file)
normalized_time_series = normalize_data(combined_time_series)

# Parameter Fine-Tuning Settings
window_sizes = [1,2,3]             # Different window sizes to test
thresholds = [0.25,0.5,0.75]          # Thresholds for similarity
degree_sensitivities = [10,15,20]      # Degree sensitivity thresholds

# Function to build graph and detect change points based on current parameters
def detect_change_points(time_series, window_size, threshold, degree_sensitivity):
    # Create sliding windows
    windows = [time_series[i:i + window_size] for i in range(len(time_series) - window_size)]
    
    # Create a similarity graph
    G = nx.Graph()
    for i, window in enumerate(windows):
        G.add_node(i, value=window)

    # Add edges based on Euclidean similarity
    for i in range(len(windows)):
        for j in range(i + 1, len(windows)):
            dist = euclidean(windows[i], windows[j])
            if dist < threshold:
                G.add_edge(i, j, weight=dist)

    # Analyze graph structure using node degrees
    node_degrees = [G.degree(n) for n in G.nodes]
    change_points = [i for i in range(1, len(node_degrees)) if abs(node_degrees[i] - node_degrees[i - 1]) > degree_sensitivity]

    return change_points, node_degrees

# Fine-tuning Loop
fig, axes = plt.subplots(len(window_sizes), len(thresholds), figsize=(15, 12))
fig.suptitle('Change Point Detection for Different Parameters', fontsize=16)

for i, window_size in enumerate(window_sizes):
    for j, threshold in enumerate(thresholds):
        # Detect change points for each parameter set
        change_points, node_degrees = detect_change_points(normalized_time_series, window_size, threshold, degree_sensitivities[i])

        # Plot the results
        ax = axes[i, j]
        ax.plot(normalized_time_series, label='Normalized Time Series')
        for cp in change_points:
            ax.axvline(x=cp + window_size // 2, color='red', linestyle='--')
        ax.set_title(f'Window Size={window_size}, Threshold={threshold}')
        ax.legend()

plt.tight_layout(rect=[0, 0, 1, 0.96])  # Adjust layout to fit the main title
plt.show()
