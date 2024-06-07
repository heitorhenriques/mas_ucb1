import csv

def calculate_average_current_action_time(csv_filename):
    current_action_times = []

    with open(csv_filename, mode='r') as file:
        reader = csv.reader(file)
        for row in reader:
            if row[0] == "Current Action Time":
                current_action_times.append(float(row[2]))

    if current_action_times:
        average_time = sum(current_action_times) / len(current_action_times)
        return average_time
    else:
        return None

# Usage example:
csv_filename = './datasets/ucb (loop add).csv'
average_current_action_time = calculate_average_current_action_time(csv_filename)
print(f'The average Current Action Time is: {average_current_action_time}')
