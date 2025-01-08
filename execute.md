# How to Run the Project

## Prerequisites
- <a href="/docker-installation.md">Docker</a>

## Running with Docker
The project uses the `run.sh` script to simplify the execution of the required containers. You can run different services and clients using specific commands. Follow the instructions below based on your operating system.

### Linux
1. **Grant execution permission to the `run.sh` script**:
   ```bash
   chmod +x run.sh
   ```

2. **Run the script with the following command**:
   ```bash
   ./run.sh <command> [options]
   ```

3. **Available commands**:
    - `build`: Builds the required Docker images.
        ```bash
        ./run.sh build
        ```
    - `distributor`: Runs the distributor container.
        ```bash
        ./run.sh distributor -remote1_ip <ip> -remote2_ip <ip> -read_factor <value>
        ```
    - `remote1`: Runs the `remote1` container.
        ```bash
        ./run.sh remote1 -distributor_ip <ip>
        ```
    - `remote2`: Runs the `remote2` container.
        ```bash
        ./run.sh remote2 -distributor_ip <ip>
        ```
    - `clientadd`: Executes the client that adds two items.
        ```bash
        ./run.sh clientadd -distributor_ip <ip>
        ```
    - `clientadd3`: Executes the client that adds thirty-eight items.
        ```bash
        ./run.sh clientadd3 -distributor_ip <ip>
        ```
    - `clientadd4`: Executes the client that adds ninety items.
        ```bash
        ./run.sh clientadd4 -distributor_ip <ip>
        ```
    - `clientget`: Executes the client that performs a read operation.
        ```bash
        ./run.sh clientget -distributor_ip <ip>
        ```
    - `agents`: Runs the agents container.
        ```bash
        ./run.sh agents -distributor_ip <ip> -observation_window <value> -add_remove <value>
        ```

## Explanation of `run.sh` Commands

### 1. **distributor**
The `distributor` command starts the **main distributor** container. This is the central server responsible for managing all client requests and distributing the processing to remote distributors (`remote1` and `remote2`) if configured.

- **Parameters**: 
  - `-remote1_ip`: IP address of the `remote1` distributor.
  - `-remote2_ip`: IP address of the `remote2` distributor.
  - `-read_factor`: A read factor value that simulates processing by performing prime number calculations.

> **Note:** The `read_factor` controls the amount of processing done for each request, simulating heavier or lighter loads depending on the configured value. The higher the `read_factor`, the longer it takes to process a request.

**Example**:
```bash
./run.sh distributor -remote1_ip 192.168.0.2 -remote2_ip 192.168.0.3 -read_factor 3
```

### 2. **remote1** and **remote2**
The `remote1` and `remote2` commands start the remote distributors. These act as **helpers** to the main distributor, offloading part of the processing workload. This improves the system's scalability by allowing the main distributor to delegate tasks to these nodes.

- **Parameters**:
  - `-distributor_ip`: IP address of the main distributor.

> **Note:** You need to run both remote distributors for the program's remote configuration to work.

**Example**:
```bash
./run.sh remote1 -distributor_ip 192.168.0.1
```

### 3. **clientadd**, **clientadd3**, **clientadd4**
These commands run clients that **add items** to the system.

- `clientadd`: Adds 2 items.
- `clientadd3`: Adds 38 items.
- `clientadd4`: Adds 90 items.

- **Parameters**:
  - `-distributor_ip`: IP address of the main distributor to which the requests will be sent.

> **Note:** These clients send POST requests to the main distributor, adding new items to be processed.

**Example**:
```bash
./run.sh clientadd -distributor_ip 192.168.0.1
```

### 4. **clientget**
This command runs a client that **performs GET requests** in a loop, retrieving already stored items.

- **Parameters**:
  - `-distributor_ip`: IP address of the main distributor.

> **Note:** This client must be running for response time data to be accessible when running the agents.

**Example**:
```bash
./run.sh clientget -distributor_ip 192.168.0.1
```

### 5. **agents**
Agents are responsible for **monitoring and automatically adjusting the main distributor** based on response times.

- **Parameters**:
  - `-distributor_ip`: IP address of the main distributor.
  - `-observation_window`: Observation window for measuring response time (in milliseconds).
  - `-add_remove`: Configures whether agents will add (1) or remove (2) items from the list. If set to `0`, no action is taken.

> **Note:** Agents monitor request response times and can adjust the system's configuration to improve performance, dynamically optimizing the distributor's behavior.

**Example**:
```bash
./run.sh agents -distributor_ip 192.168.0.1 -observation_window 5000 -add_remove 1
```

### 6. **build**
The `build` command builds the Docker images required for the project.

- **No additional parameters**.

> **Note:** Run this command whenever you make changes to the code or Docker configuration to ensure the images are up-to-date.

**Example**:
```bash
./run.sh build
```

### Windows
On Windows, you need to run the script using **Git Bash**, **PowerShell**, or **WSL** (if enabled). Follow these steps:

1. **Open your terminal (Git Bash, PowerShell, or WSL)**.
2. **Navigate to the directory where `run.sh` is located**:
   ```powershell
   cd path\to\mas_ucb1
   ```

3. **Run the script with the following command**:
   ```bash
   ./run.sh <command> [options]
   ```

4. **Available commands**:
   - `build`: Builds the required Docker images.
     ```bash
     ./run.sh build
     ```
   - `distributor`: Runs the distributor container.
     ```bash
     ./run.sh distributor -remote1_ip <ip> -remote2_ip <ip> -read_factor <value>
     ```
   - `remote1`: Runs the `remote1` container.
     ```bash
     ./run.sh remote1 -distributor_ip <ip>
     ```
   - `remote2`: Runs the `remote2` container.
     ```bash
     ./run.sh remote2 -distributor_ip <ip>
     ```
   - `clientadd`: Executes the client that adds two items.
     ```bash
     ./run.sh clientadd -distributor_ip <ip>
     ```

### Building Docker Images
To build the Docker images, run the following command:

```bash
./run.sh build
```

## Prerequisites for Running Without Docker
- [Dana Installation Guide](self_distributing_system/dana-installation.md)  
- [JaCaMo Installation Guide](src/jacamo-installation.md)

## How to Run the Project

### Compilation
Before running the server components, you need to compile them in Dana.

#### Linux
To compile the project using Dana, follow these steps:
1. Navigate to the `self_distributing_system` directory using:  
   ```bash
   cd self_distributing_system
   ```
2. Grant execution permissions to the `compile.sh` file:  
   ```bash
   chmod +x ./compile.sh
   ```
3. Execute the script:  
   ```bash
   ./compile.sh
   ```

#### Windows
On Windows, manually run all the commands from the `compile.sh` script by executing the following:

```bash
cd server
dnc . -v -sp ../distributor
cd ..
cd distributor
dnc . -sp ../server -v
dnc Distributor.dn -sp ../server -v
dnc RemoteDist.dn
dnc RemoteList.dn
dnc ./monitoring -sp ../server -v
dnc ./util  -v
dnc ./proxy -sp ../readn -v
cd ..
cd client
dnc . -v
cd ..
cd readn
dnc . -sp ../ -v
cd ../readn-writen
dnc . -sp ../ -v
cd ../writen
dnc . -sp ../ -v
cd ../constant
dnc . -sp ../ -v
cd ..
```

### Running (Without Docker)
With the Dana components compiled, the project can now be executed. Start by running the distributors for the `self_distributing_system` project. Open three terminals and navigate to the `self_distributing_system/distributor` directory.

In the first terminal, run:  

```bash
dana -sp "../server;../readn" Distributor.o
```

In the second terminal, run:  

```bash
dana -sp ../readn RemoteDist.o
```

In the third terminal, run:  

```bash
dana -sp ../readn RemoteDist.o 8082 2011
```

After the distributors are running, you need to add elements to the list before making requests with the client. Open another terminal, navigate to the `self_distributing_system/client` directory, and execute:

```bash
dana Add.o
```

Then, to run the client and make requests, use:

```bash
dana Get.o
```

Finally, you need to run the JaCaMo project. Open another terminal in the base project directory, where the `gradlew` file is located, and execute:

```bash
./gradlew run
```

If this is the first time running the project, you may need to grant permission to the `gradlew` file. If so, execute:

```bash
chmod +x gradlew
```

## Selecting Which Agents to Run

### Running UCB1
To run the UCB1 algorithm, uncomment the following block in the `mas_ucb1.jcm` file:
```java
agent ucb: ucb_agent.asl.asl {
    focus: c1
}

workspace w {
   artifact c1: example.Counter("ucb", 0)
}
```

In `Counter()`, there are two attributes: the names of the graph and CSV to be generated, and a number indicating whether the algorithm will modify the list during execution. Use:
- `0` for a constant list,  
- `1` to add an element per iteration, or  
- `2` to remove an element per iteration.


### Running Single Composition
To test a single composition, uncomment the following block:
```java
agent onecomposition: onecomposition.asl {
    beliefs: action("0", "local", 0)
    // beliefs: action("1","propagate", 0)
    // beliefs: action("2","alternate", 0)
    // beliefs: action("3","sharding", 0)
}
```

Then uncomment only the composition to be tested in the `beliefs` section.

### Running Agents
To run the intelligent agents, uncomment the following block:
```java
agent bob: self_distributing_agent.asl {
    focus: c1
    beliefs:    number(0)
                action("0")                    
}

agent maria: self_distributing_agent.asl {
    focus: c1
    beliefs:    number(1)
                action("3")
}                  
 
workspace w {
   artifact c1: example.Actions("agents", 0)
}
```

To select between keeping the list constant, incrementing, or decrementing during execution, change the number (0, 1, or 2) in the line:
```java
artifact c1: example.Actions("agents", 0)
```

## Analyzed Cases
| Case  | READ_FACTOR | Items in List         | List Modification                   | UCB (Min) | UCB (Max) | Agent Error |
|-------|-------------|-----------------------|-------------------------------------|-----------|-----------|-------------|
| 1     | 2           | Starts with 2, +1 per iteration | 1 item added per iteration         | 3 ms      | 3500 ms   | 1.3         |
| 2     | 2           | 2 fixed items        | None                                | 3 ms      | 120 ms    | N/A         |
| 3     | 8           | 38 fixed items       | None                                | 2700 ms   | 3700 ms   | N/A         |
| 4     | 2           | 90, -1 per iteration | 1 item removed per iteration        | 1 ms      | 5000 ms   | N/A         |