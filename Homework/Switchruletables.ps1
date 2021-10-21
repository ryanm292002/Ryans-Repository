#This script extracts IPs from websites containing threat intel, from 3 different websites we extracted IPs and then made a file that contained all those IPs.
#Using the parsed IPs from the various sites we then created some rulesets
#Created a switch statement that contained a prompt that asks the user what rule set theyd like to generate, coded in rulesets for IPtables, Cisco Deny and Windows Firewall
# dir .\filename to find if a file was created from script
# type .\filename to view contents of file

#array of websites containing threat intel
$drop_urls = @('https://rules.emergingthreats.net/blockrules/emerging-botcc.rules' , `
'https://rules.emergingthreats.net/blockrules/compromised-ips.txt', 'https://feodotracker.abuse.ch/downloads/ipblocklist_recommended.txt')

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

# start of switch statement
   $roles = @('IPtable','Cisco Deny', 'Windows Firewall')
   
   #variables that connected the prompt and switch statment so the input actually correlates with 
   #the switch stament rather than just running all 3
   $IP = 'IPtable'
   $CISCO = 'Cisco Deny'
   $WINDOWS = 'Windows Firewall' 

#Prompt to ask user what rule set of of the 3 provided theyd like, used variables so the prompt actually worked 
#(instead of just adding all 3 at once it now adds specifically what the user inputs)
   $roles = Read-Host -Prompt "Please specify a rule set you'd like to use between $IP, $CISCO and $WINDOWS"

#start of switch statement to differ between rules
    switch ( $roles ) {
    
    ##Get the IP discovered, loop through and replace the beginning of the line with the IPtables syntax 
   #after the IP adresses, add the remaining IPtables syntax and save the results to a file
   #iptables -A INPUT -s 103.109.247.8 -j DROP
    
        'IPtable'   {  (Get-Content -Path ".\ips-bad.tmp") | % `
   {$_ -replace "^", "iptables -A  INPUT -s " -replace "$", " -j DROP"} | `
   Out-File -FilePath "iptables.bash" }
   
   #cisco ruleset
   #syntax = access-list 1 deny host 192.168.10.1

        'Cisco Deny'        { (Get-Content -Path ".\ips-bad.tmp") | % `
   {$_ -replace "^", "access-list 1 deny host"} | `
   Out-File -FilePath "ciscodeny.bash" }

#windows ruleset
#syntax = netsh advfirewall firewall add rule name="IP Block" dir=in interface=any action=block remoteip=<IP_Address>/32

        'Windows Firewall' { (Get-Content -Path ".\ips-bad.tmp") | % `
   {$_ -replace "^", "netsh advfirewall firewall add rule name = 'IP Block' dir=in interface=any action=block "} | `
   Out-File -FilePath "windows.bash" remoteip= }
    }
 
   


