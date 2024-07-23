param (
    [string]$ipAddress
)

# Configure your AbuseIPDB API Key
$apiKey = "YOUR_API_KEY_HERE"

# Configure the URL for the AbuseIPDB API endpoint
$apiUrl = "https://api.abuseipdb.com/api/v2/report"

# Create the request body
$body = @{
    ip = $ipAddress
    categories = "5" # Category 5 for FTP Brute-Force
    comment = "FTP Server detected a brute-force attempt from IP $ipAddress"
}

# Convert the request body to JSON
$bodyJson = $body | ConvertTo-Json

# Send the POST request to AbuseIPDB
$response = Invoke-RestMethod -Uri $apiUrl -Method Post -ContentType "application/json" -Headers @{
    "Key" = $apiKey
    "Accept" = "application/json"
} -Body $bodyJson

# Display the response
$response
