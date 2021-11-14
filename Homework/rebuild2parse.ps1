  #This script extracts IPs from websites containing threat intel, from 3 different websites we extracted IPs and then made a file that contained all those IPs. We then created a ruleset 

#array of websites containing threat intel
$drop_urls = @('https://www.projecthoneypot.org/list_of_ips.php')

#loop through urls for the rules list
foreach ($u in $drop_urls) {

    #extract the file name
    $temp = $u.split("/")
    
    #the last element in array is the filename
    $file_name = $temp[-1]

    if (Test-Path $file_name) {

        continue

        } else { 



   #the last element in the array plucked off is the filename

   #download the rules list 
   Invoke-WebRequest -Uri $u -OutFile $file_name

  } #close the if statement
  


   } #close foreach loop

   #Array containing the file name 
   $input_paths = @('.\compromised-ips.txt','.\emerging-botcc.rules', '.\ipblocklist_recommended.txt')

   #extract the ip addresses
   #103.109.247.13
   $regex_drop = '\b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\b'

   #Append the Ip addresses to the temporary IP list
   select-string -Path $input_paths -Pattern $regex_drop |`
    ForEach-Object { $_.Matches } | ForEach-Object { $_.Value } | Sort-Object | Get-Unique | Out-File -FilePath "ips-bad.tmp"

 
   #Get the IP discovered, loop through and replace the beginning of the line with the IPtables syntax 
   #after the IP adresses, add the remaining IPtables syntax and save the results to a file
   #iptables -A INPUT -s 103.109.247.8 -j DROP

   

   # Create a prompt to allow the user to search for what they want


   $roles = @('IPtable','Cisco Deny', 'Windows Firewall')
   $IP = 'IPtable'
   $CISCO = 'Cisco Deny'
   $WINDOWS = 'Windows Firewall' 

   $roles = Read-Host -Prompt "Please specify a rule set you'd like to use between $IP, $CISCO and $WINDOWS"

    switch ( $roles ) {
        'IPtable'   {  (Get-Content -Path ".\ips-bad.tmp") | % `
   {$_ -replace "^", "iptables -A  INPUT -s " -replace "$", " -j DROP"} | `
   Out-File -FilePath "iptables.bash"
   
   
  
   
   
   
    }

        'Cisco Deny'        { (Get-Content -Path ".\ips-bad.tmp") | % `
   {$_ -replace "^", "access-list 1 deny host "} | `
    Out-File -FilePath "ciscodeny.bash" 
   
   
  
   }


        'Windows Firewall' { (Get-Content -Path ".\ips-bad.tmp") | % `
   {$_ -replace "^", "netsh advfirewall firewall add rule name = 'IP Block' dir=in interface=any action=block remoteip= "} | `
   Out-File -FilePath "windows.bash"
   
  
   
   
    }
    
    }
