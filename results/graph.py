import pandas as pd
import matplotlib.pyplot as plt
import os

csv_files = [
    './datasets/case4/Local.csv',
    './datasets/case4/Sharding.csv',
    './datasets/case4/agents3.csv',
    # './datasets/case4/UCB.csv',
]

plt.rcParams.update({'font.size': 18})  # Update the default font size for all elements

plt.figure(figsize=(10, 6))

for file in csv_files:
    # Extract the file name without the path and get the first word
    file_name = os.path.basename(file).replace('.csv', '')
    
    # Read the CSV data into a DataFrame
    df = pd.read_csv(file)
    
    # Filter the data for 'Current Action Time'
    current_action_df = df[(df['Series'] == 'Current Action Time') & ( df['Iteration'] <= 85)]
    
    # Plot the data
    plt.plot(current_action_df['Iteration'], current_action_df['Average Time (ms)'], marker='.', label=file_name)

# Set the title and labels
# plt.title('Current Action Time vs Iteration')
plt.xlabel('Step')
plt.ylabel('Response Time (ms)')

# Add a legend
plt.legend()

# Add a grid for better readability
plt.grid(True)

plt.savefig('./images/current_action_time_plot.pdf', format="pdf")  # You can change the filename and format as needed

# Show the plot
plt.show()
