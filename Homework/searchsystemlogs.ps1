#Storyline: USing the script of searching through the security log our task
 #was to add a prompt that asked a user to search for a specific keyword/phrase
 #from the security log that they needed to focus on

# Directory to save files
$myDir ="C:\Users\ryan.morrissey-adm\Desktop"

#List all the available windows event logs
Get-EventLog -list

# Create a prompt to allow the user to select the log to view
$readLog = Read-Host -Prompt "Please select a log to review from the list above"

# Create a prompt to allow the user to search for what they want
$searchLog = Read-Host -Prompt "Please specify a keyword or phrase from the message"

# Print the results for the log 
Get-Eventlog -LogName $readLog -Newest 40 | where{$_.Message -ilike "*$searchLog*"}|  export-csv -NoTypeInformation `
-Path "$myDir\securitylog.csv"
