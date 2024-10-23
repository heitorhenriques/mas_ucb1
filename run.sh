#!/bin/bash

# Default values for variables
distributor_ip="localhost"
remote1_ip="localhost"
remote2_ip="localhost"
read_factor="2"
observation_window="5000"
add_remove="0"

# Display usage instructions
usage() {
  echo "Usage: $0 <command> [options] <value>"
  echo ""
  echo "Commands and Required Options:"
  echo "  distributor         Run the distributor container (requires: -remote1_ip, -remote2_ip, -read_factor)"
  echo "  remote1             Run the remote1 container (requires: -distributor_ip)"
  echo "  remote2             Run the remote2 container (requires: -distributor_ip)"
  echo "  clientadd           Run the client that adds two itens on the list (requires: -distributor_ip)"
  echo "  clientadd3          Run the client that adds thirty eight itens on the list (requires: -distributor_ip)"
  echo "  clientadd4          Run the client that adds ninety itens on the list (requires: -distributor_ip)"
  echo "  clientget           Run the client get container (requires: -distributor_ip)"
  echo "  agentes             Run the agentes container (requires: -distributor_ip, -observation_window, -add_remmove)"
  echo "  build               Build the necessary Docker images (no additional arguments required)"
  echo ""
  echo "Options:"
  echo "  -distributor_ip      IP of the distributor (default: localhost)"
  echo "  -remote1_ip          IP of remote1 (default: localhost)"
  echo "  -remote2_ip          IP of remote2 (default: localhost)"
  echo "  -read_factor         Read factor (default: 2)"
  echo "  -observation_window  Observation window (default: 5000)"
  echo "  -add_remove          Variable to set if the agentes are going to 1 add or 2 remove in the list, set 0 to set neither (default: 0)"
  exit 1
}

# Check if no command is provided
if [ -z "$1" ]; then
  echo "Error: No command provided."
  usage
fi

# Assign the first argument to PARAM
PARAM=$1
shift # Remove the first argument, so only options remain

# Parse options
while [[ "$#" -gt 0 ]]; do
  case "$1" in
    -distributor_ip)
      distributor_ip="$2"
      shift 2
      ;;
    -remote1_ip)
      remote1_ip="$2"
      shift 2
      ;;
    -remote2_ip)
      remote2_ip="$2"
      shift 2
      ;;
    -read_factor)
      read_factor="$2"
      shift 2
      ;;
    -observation_window)
      observation_window="$2"
      shift 2
      ;;
    -add_remove)
      add_remove="$2"
      shift 2
      ;;
    *)
      echo "Unknown option: $1"
      usage
      ;;
  esac
done

# Execute the corresponding command
case "$PARAM" in
  distributor)
    echo "Running the distributor container..."
    docker run -it --rm -e REMOTE1_IP="$remote1_ip" -e REMOTE2_IP="$remote2_ip" -e READ_FACTOR="$read_factor" \
      -p 8080:8080 -p 3500:3500 -w "/app/distributor" dana -sp "../server;../readn" Distributor.o
    ;;
  remote1)
    echo "Running the remote1 container..."
    docker run -it --rm -e DISTRIBUTOR_IP="$distributor_ip" -w "/app/distributor" -p 2010:2010 -p 8081:8081 \
      dana -sp ../readn RemoteDist.o
    ;;
  remote2)
    echo "Running the remote2 container..."
    docker run -it --rm -e DISTRIBUTOR_IP="$distributor_ip" -w "/app/distributor" -p 2011:2011 -p 8082:8082 \
      dana -sp ../readn RemoteDist.o 8082 2011
    ;;
  clientadd)
    echo "Running the client add container..."
    docker run -it --rm -e DISTRIBUTOR_IP="$distributor_ip" -w "/app/client" dana Add.o
    ;;
  clientadd3)
    echo "Running the client add container..."
    docker run -it --rm -e DISTRIBUTOR_IP="$distributor_ip" -w "/app/client" dana AddCase3.o
    ;;
  clientadd4)
    echo "Running the client add container..."
    docker run -it --rm -e DISTRIBUTOR_IP="$distributor_ip" -w "/app/client" dana AddCase4.o
    ;;
  clientget)
    echo "Running the client get container..."
    docker run -it --rm -e DISTRIBUTOR_IP="$distributor_ip" -w "/app/client" dana Get.o
    ;;
  agentes)
    echo "Running the agentes container..."
    docker run -e OBSERVATION_WINDOW="$observation_window" -e DISTRIBUTOR_IP="$distributor_ip" -e ADD_REMOVE="$add_remove" -it --rm -v .:/app agentes
    ;;
  build)
    echo "Building Docker images..."
    docker build -t agentes .
    cd self_distributing_system
    docker build -t dana .
    cd ..
    ;;
  *)
    echo "Unknown command: $PARAM"
    usage
    ;;
esac