import time
import requests
import pandas as pd

base_url = "http://localhost"
base_port = 3500

def getActions():
    response = requests.get(f"{base_url}:{base_port}/ucb/init")
    arms = int(response.content.decode('utf-8'))
    print(f"There are: {str(arms)} compositions! From 0 to {str(arms-1)}.")

def getPerceptionData():
    response = requests.get(f"{base_url}:{base_port}/ucb/perception-data")
    if (response.content.decode('utf-8') == "NOT FOUND"):
        print("Something went wrong!")
    action, average_response_time = response.content.decode('utf-8').split("|")
    print(f"Action {action} with average response time {average_response_time}")
    return average_response_time

def setComposition(index):
    requests.post(f"{base_url}:{base_port}/ucb/composition", data=str(index))

if __name__ == "__main__":
    data = []
    while True:
        time.sleep(5)
        avg_time = getPerceptionData()
        data.append(avg_time)
        series = pd.Series(data)
        series.to_csv('teste1.csv')

        

        