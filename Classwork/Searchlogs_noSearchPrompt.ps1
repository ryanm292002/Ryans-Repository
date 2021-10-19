#Storyline: Reviewing the Security Event Log

# Directory to save files
$myDir ="C:\Users\ryan.morrissey-adm\Desktop"

#List all the available windows event logs
Get-EventLog -list

# Create a prompt to allow the user to select the log to view
$readLog = Read-Host -Prompt "Please select a log to review from the list above"


# Print the results for the log 
Get-Eventlog -LogName $readLog -Newest 40 | where {$_.Message -ilike "*special privileges*"} |  export-csv -NoTypeInformation `
-Path "$myDir\securitylog.csv"
