#!/bin/bash

distributor_ip="localhost"
remote1_ip="localhost"
remote2_ip="localhost"
read_factor="2"
observation_window="5000"

# Check if a parameter is provided
if [ -z "$1" ]; then
  echo "No parameter provided. Please provide a parameter."
  echo "You can enter the following parameters:"
  echo "- distributor"
  echo "- remote1"
  echo "- remote2"
  echo "- clientadd"
  echo "- clientget"
  echo "- agentes"
  exit 1
fi

# Assign the parameter to a variable
PARAM=$1

# Parse arguments
while [[ "$#" -gt 0 ]]; do
    case $2 in
        -distributor_ip)
            distributor_ip="$3"
            shift 3
            ;;
        -remote1_ip)
            remote1_ip="$3"
            shift 3
            ;;
        -remote2_ip)
            remote2_ip="$3"
            shift 3
            ;;
        -read_factor)
            read_factor="$3"
            shift 3
            ;;
        -observation_window)
            observation_window="$3"
            shift 3
            ;;
        *)
    esac
done

# Use the parameter in an if clause
if [ "$PARAM" == "distributor" ]; then
  cd self_distributing_system
  docker run -it --rm -e REMOTE1_IP="localhost" -e REMOTE2_IP="localhost" -e READ_FACTOR="2" -w "/app/distributor" dana -sp "../server;../readn" Distributor.o 
elif [ "$PARAM" == "remote1" ]; then
  cd self_distributing_system
  docker run -it --rm -e DISTRIBUTOR_IP="192.168.3.7" -w "/app/distributor" -p 2010:2010 -p 8081:8081 dana -sp ../readn RemoteDist.o
elif [ "$PARAM" == "remote2" ]; then
  cd self_distributing_system
  docker run -it --rm -e DISTRIBUTOR_IP="192.168.3.7" -w "/app/distributor" -p 2011:2011 -p 8082:8082 dana -sp ../readn RemoteDist.o 8082 2011
elif [ "$PARAM" == "clientadd" ]; then
  cd self_distributing_system
  docker run -it --rm -e DISTRIBUTOR_IP="192.168.3.7" -w "/app/client" dana Add.o
elif [ "$PARAM" == "clientget" ]; then
  cd self_distributing_system
  docker build -f dockerfile.clientget -t clientget .
  docker run -e DISTRIBUTOR_IP="$distributor_ip" clientget
elif [ "$PARAM" == "agentes" ]; then
  docker build -t agentes .
  docker run -e OBSERVATION_WINDOW="5000" -e DISTRIBUTOR_IP="192.168.3.7" -it --rm -v .:/app agentes
else
  echo "Unknown parameter. Use 'start' or 'stop'."
  echo "You can enter the following parameters:"
  echo "- distributor"
  echo "- remote1"
  echo "- remote2"
  echo "- clientadd"
  echo "- clientget"
  echo "- agentes"
fi
