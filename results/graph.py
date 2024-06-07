import pandas as pd
import matplotlib.pyplot as plt
import os

csv_files = [
    './datasets/local (loop add).csv',
    './datasets/sharding (loop add).csv',
    './datasets/ucb (loop add).csv',
    './datasets/agents (loop add).csv'
]

plt.figure(figsize=(10, 6))

for file in csv_files:
    # Extract the file name without the path and get the first word
    file_name = os.path.basename(file).split(' ')[0]
    
    # Read the CSV data into a DataFrame
    df = pd.read_csv(file)
    
    # Filter the data for 'Current Action Time'
    current_action_df = df[df['Series'] == 'Current Action Time']
    
    # Plot the data
    plt.plot(current_action_df['Iteration'], current_action_df['Average Time (ms)'], marker='.', label=file_name)

# Set the title and labels
plt.title('Current Action Time vs Iteration')
plt.xlabel('Iteration')
plt.ylabel('Response Time (ms)')

# Add a legend
plt.legend()

# Add a grid for better readability
plt.grid(True)

plt.savefig('./images/current_action_time_plot.png')  # You can change the filename and format as needed

# Show the plot
plt.show()
