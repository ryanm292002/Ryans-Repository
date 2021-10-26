# send a file to  a remote system

#use the set-SCPItem to send a file to  a remote system
#you would use get-SCPItem file to download a file from a remote system
Set-SCPItem -ComputerName web01-ryan (Get-Credential ryan) -Destination '/home/ryan' -Path '.\tosend.txt'