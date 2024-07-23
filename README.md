# SolarWinds Serv-U FTP Server To AbuseIPDB
Sending Malicious IPs to AbuseIPDB from SolarWinds Serv-U FTP Server.

## Purpose
This manual provides detailed instructions on how to configure an event in SolarWinds Serv-U FTP Server to automatically report IP addresses involved in brute-force attempts to AbuseIPDB using a PowerShell script named `Serv-UToAbuseIPDB`. By automating this process, administrators can enhance their server's security by ensuring that malicious IP addresses are promptly reported and potentially blocked from further attacks.

## Steps to Create and Configure the Event

### 1. Access the Serv-U Management Console
- Open the Serv-U Management Console and log in with administrative credentials.

### 2. Navigate to the Events Section
- In the left-hand menu, click on `Events`.

### 3. Create a New Event
- Click the `Add` button to create a new event.

### 4. Configure Event Triggers
- In the Event dialog, specify the event type that will trigger the script. For example, select "Login Attempt" if you want to report failed login attempts.
- Set additional filters or conditions if necessary (e.g., report only failed login attempts).

### 5. Set Up the Action to Execute an External Program
- In the Actions section of the event configuration, select `Execute Command`.

### 6. Configure the Command Execution
- **Command:** Enter the path to the PowerShell executable, typically `powershell.exe` (C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe)
- **Arguments:** Enter the script path and the `$IP` variable. The complete argument string should look like this:
  ```plaintext
  -File "C:\Path\To\Serv-UToAbuseIPDB.ps1" -ipAddress "$IP"
  ```
  Ensure that the path to `Serv-UToAbuseIPDB.ps1` is correct and that the script has the necessary execution permissions.

### 7. Save the Event Configuration
- Click `Save` to create the event with the specified configuration.

## Detailed Example of the PowerShell Script

Here is the PowerShell script `Serv-UToAbuseIPDB.ps1` which will be executed by the event:

```powershell
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
```

## Testing the Configuration

1. Trigger the event manually or wait for it to occur naturally.
2. Verify that the PowerShell script runs as expected and reports the IP address to AbuseIPDB.
3. Check the logs in Serv-U and AbuseIPDB for successful execution and reporting.

## Conclusion

By following this manual, you have successfully configured SolarWinds Serv-U FTP Server to trigger a PowerShell script upon a specified event, reporting IP addresses involved in brute-force attempts to AbuseIPDB. This integration helps enhance your server's security by automating the reporting process.

### References
- [SolarWinds Serv-U Documentation](https://documentation.solarwinds.com)
- [AbuseIPDB API Documentation](https://docs.abuseipdb.com)

Feel free to reach out to SolarWinds support or consult the official documentation for more detailed configurations and troubleshooting steps.
