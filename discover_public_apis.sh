#!/bin/bash

# Define the main domain and output files
DOMAIN="example.com"
SUBDOMAINS_FILE="subdomains.txt"
ENDPOINTS_FILE="endpoints.txt"
RESULTS_FILE="public_endpoints_results.txt"
WORDLIST="api-wordlist.txt" # Customize this with a wordlist containing common API paths

# Ensure files are empty before starting
> $SUBDOMAINS_FILE
> $ENDPOINTS_FILE
> $RESULTS_FILE

echo "Starting API discovery and accessibility check on domain: $DOMAIN"

# Step 2: Find Subdomains using Subfinder
echo "Discovering subdomains for $DOMAIN..."
subfinder -d $DOMAIN -silent > $SUBDOMAINS_FILE
echo "Subdomains saved to $SUBDOMAINS_FILE"

# Step 3: Enumerate API Endpoints on Each Subdomain
echo "Enumerating API endpoints..."
while read -r subdomain; do
    echo "Scanning endpoints for subdomain: $subdomain"
    
  # Check if the wordlist file exists and has content
if [ ! -s "$WORDLIST" ]; then
    echo "Wordlist file $WORDLIST is missing or empty. Please ensure it has API paths."
    exit 1
fi

# Run FFUF with verbose output to see if it's working correctly
ffuf -u "https://$subdomain/FUZZ" -w "$WORDLIST" -mc 200,401 -o tmp_endpoints.json -of json -v

# Check if FFUF produced any results
if [ -s tmp_endpoints.json ]; then
    echo "FFUF completed. Extracting results from tmp_endpoints.json..."

    # Extract the endpoints from FFUF's JSON output
    jq -r '.results[] | .url' tmp_endpoints.json >> $ENDPOINTS_FILE

    # Confirm extraction and print the results
    if [ -s "$ENDPOINTS_FILE" ]; then
        echo "Accessible endpoints found on $SUBDOMAIN and saved to $ENDPOINTS_FILE"
        cat $ENDPOINTS_FILE
    else
        echo "No accessible endpoints were found on $SUBDOMAIN."
    fi
else
    echo "FFUF did not find any accessible endpoints on $SUBDOMAIN."
fi

# Clean up temporary JSON file
rm -f tmp_endpoints.json

done < $SUBDOMAINS_FILE
echo "Endpoint enumeration completed and saved to $ENDPOINTS_FILE"

# Step 4: Check Access Level of Each Endpoint
echo "Checking accessibility of endpoints..."
while read -r endpoint; do
    echo "Checking: $endpoint"
    
    # Send a GET request to check if the endpoint is publicly accessible
    response=$(curl -s -o /dev/null -w "%{http_code}" "$endpoint")
    
    # Log accessible endpoints based on HTTP status code
    if [ "$response" -eq 200 ]; then
        echo "Publicly accessible: $endpoint" | tee -a $RESULTS_FILE
    else
        echo "Restricted access: $endpoint (Status Code: $response)" >> $RESULTS_FILE
    fi
done < $ENDPOINTS_FILE

echo "Public API endpoint discovery completed. Results saved to $RESULTS_FILE"

