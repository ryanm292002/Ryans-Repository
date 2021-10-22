# STORY LINE:
# These are some examples of how Get-WmiObject can be useful when using powershell, you can use it to find information such as
# properties of your network adapter

#Code to find out which Class to use, looking for network info so sorted by n
# Get-WmiObject -List | where { $_.Name -ilike "Win32_[n]*" } | sort-object 

(This wasnt the right class, at least I couldnt find anything useful but I kept it here anyways)
 #Get-WmiObject -Class Win32_NetworkAdapter | Get-Member -MemberType Property 
 
 #(Gave class list for network adapter config, looked for required classes)
#Get-WmiObject -Class Win32_NetworkAdapterConfiguration | Get-Member -MemberType Property 

#Choose specifically what properties you want to look at of the adapter configuration from the code above
Get-WmiObject -Class Win32_NetworkAdapterConfiguration | select IPAddress, DefaultIPGateway, DHCPServer, DNSServerSearchorder 
