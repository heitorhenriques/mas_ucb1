#!/bin/bash

# Initialize variables
name=""
age=""
city=""
country=""
email=""

# Parse arguments
while [[ "$#" -gt 0 ]]; do
    case $1 in
        --name)
            name="$2"
            shift 2
            ;;
        --age)
            age="$2"
            shift 2
            ;;
        --city)
            city="$2"
            shift 2
            ;;
        --country)
            country="$2"
            shift 2
            ;;
        --email)
            email="$2"
            shift 2
            ;;
        *)
            echo "Unknown parameter passed: $1"
            shift
            ;;
    esac
done

# Output the variables
echo "Name: $name"
echo "Age: $age"
echo "City: $city"
echo "Country: $country"
echo "Email: $email"
