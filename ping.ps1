# Create an array of IPs
$to_ping = @('10.0.5.2','10.0.5.3','10.0.5.5','10.0.5.6')

# Loop through the array
foreach ($ip in $to_ping) {

    # Ping each host
    $the_ping = Test-Connection -ComputerName $ip -quiet -Count 1

    # Check the status of the ping for each host
    if ($the_ping) {
    
        # Host is up
        write-host -BackgroundColor Green -ForegroundColor white "$ip is up."
    
    } else {
# Output the results if it is down, to a file
echo "$ip is down." | Out-File -Append -FilePath ".\host-down.txt"
    
    
    }

}

#check whether to send an email only
if (Test-Path ".\host-down.txt") {

#Send an email with the host-down.txt attachment
Send-MailMessage -From "noreply@ryan.local" -To "ryan@ryan.local" `
-Subject "Host Report." -Body "Attached report for hosts that are down" `
 -Attachments ".\host-down.txt." -SmtpServer 10.0.5.4

 if ($?) {
echo "Email sent!"


 }
 else {
    echo "Error: Email not Sent!"
 }

 #Delete host-down.txt
 Remove-Item ".\host-down.txt"

} #end of test-path