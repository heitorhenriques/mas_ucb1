# Re-importing the necessary libraries due to environment reset
import matplotlib.pyplot as plt
import numpy as np
import networkx as nx
import pandas as pd
from scipy.spatial.distance import euclidean

def read_csv_data(file_path):
    data = pd.read_csv(file_path)
    return data["Average Time (ms)"].astype(float).tolist()

# Simulate a change point scenario by combining two CSV datasets
def simulate_combined_data(local_file, sharding_file):
    local_data = read_csv_data(local_file)
    sharding_data = read_csv_data(sharding_file)
    return sharding_data[:45] + local_data[45:90]
    #return sharding_data[:90]
# Normalize the time series data using Min-Max scaling
def normalize_data(data):
    min_val = np.min(data)
    max_val = np.max(data)
    return [(x - min_val) / (max_val - min_val) for x in data]

# File paths for datasets
local_file = r"C:\Users\heiit\Documents\np1.2\mas_ucb1\results\datasets\case2\Local.csv"
local_file_big = r"C:\Users\heiit\Documents\np1.2\mas_ucb1\results\datasets\case3\Local.csv"
sharding_file = r"C:\Users\heiit\Documents\np1.2\mas_ucb1\results\datasets\case2\Sharding.csv"
sharding_file_big = r"C:\Users\heiit\Documents\np1.2\mas_ucb1\results\datasets\case3\Sharding.csv"

# Step 1: Load and normalize the combined data
combined_time_series = simulate_combined_data(sharding_file_big, sharding_file)
normalized_time_series = normalize_data(combined_time_series)

# Regenerate sample time series data
np.random.seed(42)
time_series = np.sin(np.linspace(0, 10, 100)) + np.random.normal(0, 0.1, 100)

# Parameters
window_size = 6
threshold = 0.9

# Create a sliding window representation of the time series
windows = [normalized_time_series[i:i + window_size] for i in range(len(normalized_time_series) - window_size)]

# Rebuild the graph and compute densities over time
graph_densities = []
for i in range(len(windows) - window_size):
    # Create a new subgraph with sliding windows
    subgraph = nx.Graph()
    for w in range(i, i + window_size):
        subgraph.add_node(w, value=windows[w])
    
    # Add edges based on similarity
    for w1 in range(i, i + window_size):
        for w2 in range(w1 + 1, i + window_size):
            dist = euclidean(windows[w1], windows[w2])
            if dist < threshold:
                subgraph.add_edge(w1, w2, weight=dist)
    
    # Calculate graph density
    density = nx.density(subgraph)
    graph_densities.append(density)

# Detect change points where density drops sharply
density_change_points = [i for i in range(1, len(graph_densities)) if abs(graph_densities[i] - graph_densities[i - 1]) > 0.2]

# Plotting the time series with graph density change points
fig, ax = plt.subplots(2, 1, figsize=(12, 8))

# Plot Time Series and Change Points
ax[0].plot(normalized_time_series, label='Time Series')
for cp in density_change_points:
    ax[0].axvline(x=cp + window_size, color='green', linestyle='--', label='Density Change Point' if cp == density_change_points[0] else "")
ax[0].set_title('Time Series with Graph Density Change Points')
ax[0].legend()

# Plot Graph Densities over Time
ax[1].plot(range(window_size, len(graph_densities) + window_size), graph_densities, marker='o', label='Graph Density')
for cp in density_change_points:
    ax[1].axvline(x=cp + window_size, color='green', linestyle='--')
ax[1].set_title('Graph Density over Time')
ax[1].set_xlabel('Time (Window Index)')
ax[1].set_ylabel('Graph Density')
ax[1].legend()

plt.tight_layout()
plt.savefig('sharding_workload.png')
plt.show()