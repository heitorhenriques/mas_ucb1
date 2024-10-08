import time
import numpy as np
from sklearn.cluster import MiniBatchKMeans
import matplotlib.pyplot as plt
import test

# Step 1: Real-time data simulation (Replace this with real-time data in practice)
def generate_real_time_data():
    np.random.seed(42)
    while True:
        data1 = np.random.normal(loc=0, scale=1, size=20)  # Segment 1
        data2 = np.random.normal(loc=5, scale=1, size=20)  # Segment 2
        data3 = np.random.normal(loc=-3, scale=1, size=20)  # Segment 3
        for point in np.concatenate([data1, data2, data3]):
            yield point

# Step 2: Real-time sliding window processing
class RealTimeSlidingWindow:
    def __init__(self, window_size):
        self.window_size = window_size
        self.window = []

    def add_point(self, point):
        self.window.append(point)
        if len(self.window) > self.window_size:
            self.window.pop(0)

    def get_features(self):
        if len(self.window) == self.window_size:
            mean = np.mean(self.window)
            std = np.std(self.window)
            return [mean, std]
        return None

# Step 3: Real-time change point detection using MiniBatchKMeans
def real_time_change_detection(window_size, n_clusters=3):
    sliding_window = RealTimeSlidingWindow(window_size)
    kmeans = MiniBatchKMeans(n_clusters=n_clusters, random_state=0, batch_size=window_size)

    change_points = []
    current_cluster = None
    time_series = []
    feature_buffer = []  # Buffer to accumulate features

    index = 0
    while True:
        time.sleep(5)
        # Step 1: Get real-time perception data
        action, avg_time = test.getPerceptionData()
        index += 1
        time_series.append(avg_time)

        # Step 2: Update sliding window and get features
        sliding_window.add_point(avg_time)
        features = sliding_window.get_features()

        if features is not None:
            feature_buffer.append(features)

            # Step 3: Check if we have enough samples to perform clustering
            if len(feature_buffer) >= n_clusters:
                # Fit the model incrementally
                kmeans.partial_fit(feature_buffer)

                # Predict the cluster for the current segment
                predicted_cluster = kmeans.predict([features])[0]

                # Step 4: Detect cluster change
                if current_cluster is None:
                    current_cluster = predicted_cluster
                elif current_cluster != predicted_cluster:
                    # Change point detected
                    change_points.append(index - window_size)
                    current_cluster = predicted_cluster
                    print(f"Change point detected at index: {index - window_size}")
        test.add_to_list(index)
        # Optional: Stop after a fixed number of points for demonstration (adjust as needed)
        if index > 50:  # Adjust or remove this limit for a longer run
            break

    return time_series, change_points

# Step 4: Visualize the detected change points in real-time
def plot_real_time_change_points(time_series, change_points, window_size):
    plt.figure(figsize=(12, 6))
    plt.plot(time_series, label='Time Series')
    for cp in change_points:
        plt.axvline(x=cp + window_size, color='red', linestyle='--', label='Change Point' if cp == change_points[0] else "")
    plt.legend()
    plt.title('Real-Time Change Point Detection')
    plt.show()

# Main Execution
if __name__ == '__main__':
    window_size = 10  # Set the window size
    # Run real-time change detection
    time_series, change_points = real_time_change_detection(window_size, n_clusters=3)

    # Plot the detected change points
    plot_real_time_change_points(time_series, change_points, window_size)
