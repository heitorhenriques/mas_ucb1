import time
import networkx as nx
from matplotlib import pyplot
import requests

base_url = "http://192.168.3.7"
base_port = 3500

def getPerceptionData():
    response = requests.get(f"{base_url}:{base_port}/ucb/perception-data")
    while response.content.decode('utf-8') == "NOT FOUND":
        response = requests.get(f"{base_url}:{base_port}/ucb/perception-data")
        time.sleep(0.1)
    action, average_response_time = response.content.decode('utf-8').split(",")
    return action,float(average_response_time)

def setComposition(index):
    requests.post(f"{base_url}:{base_port}/ucb/composition", data=str(index))

def remove_from_list(char_to_remove:int):
    
    url = f"http://192.168.3.7:8080/remove"
    
    response = requests.post(url, data=str(char_to_remove))

def add_to_list(char_to_add:int):
    
    url = f"http://192.168.3.7:8080/add"
    
    response = requests.post(url, data=str(char_to_add))


# avgs_time = []
# char_to_remove = 3
# while char_to_remove < 91:
#     time.sleep(5)
#     action,avg_time = getPerceptionData()
#     avgs_time.append(float(avg_time))
#     g = nx.visibility_graph(avgs_time)
#     print(f"Graph Degree of node {len(avgs_time)-1}: {g.degree[len(avgs_time) - 1]}")
    
#     #remove_from_list(char_to_remove)
#     add_to_list(char_to_remove)
#     char_to_remove += 1

#     # Create a bar plot
#     x_indices = list(range(len(avgs_time)))  # Create an index list for the x-axis labels (e.g., 0, 1, 2, ...)
#     fig, ax = pyplot.subplots()
#     bars = ax.bar(x_indices, avgs_time, color='skyblue')

#     # Adding labels and title for the bar plot
#     ax.set_xlabel('Index')
#     ax.set_ylabel('Average Time')
#     ax.set_title('Bar Plot with Overlayed Network Graph')
#     ax.set_xticks(x_indices)  # Ensure x-axis labels are correctly placed

#     # Overlaying the network graph
#     # Calculate positions for the nodes, placing them above each bar
#     bar_heights = [bar.get_height() for bar in bars]
#     pos = {i: (i, bar_heights[i] + 0.5) for i in range(len(avgs_time))}

#     # Draw nodes and labels on top of the bar plot
#     labels = {i: f"{i}" for i in range(len(avgs_time))}
#     nx.draw_networkx_nodes(g, pos, ax=ax, node_size=300, node_color='orange', edgecolors='black')
#     nx.draw_networkx_labels(g, pos, labels=labels, ax=ax)

#     # Draw edges with a curved style to connect nodes above the bars
#     nx.draw_networkx_edges(g, pos, ax=ax, arrows=True, connectionstyle='arc3,rad=-0.5')

#     # Save the combined figure
#     pyplot.savefig('combined_bar_and_network_plot.png')
#     pyplot.close()

# pyplot.show()
# for s in series_list:
#     g = nx.visibility_graph(s)
#     print(g)
#     # Uncomment the following lines to plot the graph
#     pos = [[x, 0] for x in range(len(s))]
#     labels = nx.get_node_attributes(g, 'value')
#     nx.draw_networkx_nodes(g, pos)
#     nx.draw_networkx_labels(g, pos, labels=labels)
#     nx.draw_networkx_edges(g, pos, arrows=True, connectionstyle='arc3,rad=-1.57079632679')
#     pyplot.show()