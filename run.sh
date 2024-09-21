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
  docker run -it --rm -e REMOTE1_IP="$remote1_ip" -e REMOTE2_IP="$remote2_ip" -e READ_FACTOR="$read_factor" -p 8080:8080 -p 3500:3500 -w "/app/distributor" dana -sp "../server;../readn" Distributor.o 
elif [ "$PARAM" == "remote1" ]; then
  docker run -it --rm -e DISTRIBUTOR_IP="$distributor_ip" -w "/app/distributor" -p 2010:2010 -p 8081:8081 dana -sp ../readn RemoteDist.o
elif [ "$PARAM" == "remote2" ]; then
  docker run -it --rm -e DISTRIBUTOR_IP="$distributor_ip" -w "/app/distributor" -p 2011:2011 -p 8082:8082 dana -sp ../readn RemoteDist.o 8082 2011
elif [ "$PARAM" == "clientadd" ]; then
  docker run -it --rm -e DISTRIBUTOR_IP="$distributor_ip" -w "/app/client" dana Add.o
elif [ "$PARAM" == "clientget" ]; then
  docker run -it --rm -e DISTRIBUTOR_IP="$distributor_ip" -w "/app/client" dana Get.o
elif [ "$PARAM" == "agentes" ]; then
  docker run -e OBSERVATION_WINDOW="$observation_window" -e DISTRIBUTOR_IP="$distributor_ip" -it --rm -v .:/app agentes
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
