# Re-importing the necessary libraries due to environment reset
import time
import matplotlib.pyplot as plt
import numpy as np
import networkx as nx
import requests
from scipy.spatial.distance import euclidean

base_url = "http://192.168.3.7"
base_port = 3500

# Function to get perception data
def getPerceptionData():
    response = requests.get(f"{base_url}:{base_port}/ucb/perception-data")
    while response.content.decode('utf-8') == "NOT FOUND":
        response = requests.get(f"{base_url}:{base_port}/ucb/perception-data")
        time.sleep(0.1)
    action, average_response_time = response.content.decode('utf-8').split(",")
    return action, float(average_response_time)

# Normalize the time series data using Min-Max scaling
def normalize_data(data):
    min_val = np.min(data)
    max_val = np.max(data)
    return [(x - min_val) / (max_val - min_val) for x in data]

# Function to detect change points in real time
def detect_change_points(real_time_data, window_size, threshold):
    # Normalize the real-time data
    normalized_data = normalize_data(real_time_data)

    # Create sliding windows
    windows = [normalized_data[i:i + window_size] for i in range(len(normalized_data) - window_size)]
    
    if len(windows) < window_size:
        return None, []  # Not enough data to calculate yet
    
    # Rebuild the graph and compute densities
    densities = []
    for i in range(len(windows) - window_size):
        subgraph = nx.Graph()
        for w in range(i, i + window_size):
            subgraph.add_node(w, value=windows[w])
        
        for w1 in range(i, i + window_size):
            for w2 in range(w1 + 1, i + window_size):
                dist = euclidean(windows[w1], windows[w2])
                if dist < threshold:
                    subgraph.add_edge(w1, w2, weight=dist)
        
        # Calculate graph density
        density = nx.density(subgraph)
        densities.append(density)
    
    # Detect real-time change points
    change_points = [i for i in range(1, len(densities)) if abs(densities[i] - densities[i - 1]) > 0.2]
    
    return densities, change_points

# Real-time perception data collection and change point detection
def real_time_monitoring(data_length, window_size, threshold):
    real_time_data = []
    graph_densities = []
    change_points = set()
    
    # Set up the plot for real-time updates
    fig, ax = plt.subplots(2, 1, figsize=(12, 8))
    
    for i in range(data_length):
        time.sleep(5)
        # Get new data point
        _, avg_response_time = getPerceptionData()
        real_time_data.append(avg_response_time)
        
        print(f"Step {i + 1}: Collected data point - {avg_response_time} ms")  # Show collected data
        
        # Detect change points in real-time
        densities, new_change_points = detect_change_points(real_time_data, window_size, threshold)
        
        if densities:
            graph_densities = densities
            print(f"Graph Density at step {i + 1}: {densities[-1]}")  # Show current graph density
        
        if new_change_points:
            change_points.update(new_change_points)
            print(f"Change Points detected at steps: {new_change_points}")  # Show detected change points
        
        # Update the plots in real-time
        ax[0].clear()
        ax[1].clear()

        # Plot Time Series and Change Points
        ax[0].plot(normalize_data(real_time_data), label='Time Series')

        # Track if the label for "Density Change Point" was added
        label_added = False

        for cp in sorted(change_points):
            if not label_added:  # Add label only for the first change point
                ax[0].axvline(x=cp + window_size, color='green', linestyle='--', label='Density Change Point')
                label_added = True
            else:
                ax[0].axvline(x=cp + window_size, color='green', linestyle='--')

        ax[0].set_title('Time Series with Real-Time Graph Density Change Points')
        ax[0].legend()

        # Plot Graph Densities over Time
        if graph_densities:
            ax[1].plot(range(window_size, len(graph_densities) + window_size), graph_densities, marker='o', label='Graph Density')

        for cp in sorted(change_points):
            ax[1].axvline(x=cp + window_size, color='green', linestyle='--')

        ax[1].set_title('Graph Density over Time')
        ax[1].set_xlabel('Time (Window Index)')
        ax[1].set_ylabel('Graph Density')
        ax[1].legend()

        
        # plt.pause(0.1)  # Pause to allow the plot to update

        # Print status message at the end of each loop iteration
        print(f"Real-time data length: {len(real_time_data)}")
        print(f"Current Change Points: {change_points}")
        print("-------------------------------")
        
        plt.tight_layout()
        plt.savefig('real_time_sharding_workload.png')
    # plt.show()

# Parameters
window_size = 6
threshold = 0.9
data_length = 90  # Number of data points to collect in real-time

# Start real-time monitoring and detection
real_time_monitoring(data_length, window_size, threshold)
