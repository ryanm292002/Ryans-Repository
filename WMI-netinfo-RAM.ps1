# Get-WmiObject -List | where { $_.Name -ilike "Win32_[n]*" } | sort-object (Code to find out which Class to use, looking for network info so sorted by n)
 #Get-WmiObject -Class Win32_NetworkAdapter | Get-Member -MemberType Property (This wasnt the right class, at least I couldnt find anything useful but I kept it here anyways)
#Get-WmiObject -Class Win32_NetworkAdapterConfiguration | Get-Member -MemberType Property (Gave class list for network adapter config, looked for required classes)
Get-WmiObject -Class Win32_NetworkAdapterConfiguration | select IPAddress, DefaultIPGateway, DHCPServer, DNSServerSearchorder
