# SSH to a remote host and copy files to our remote host
#Find-Module *ssh*
#Install-Module Posh-SSH -Scope CurrentUser
#Get-Command -Module Posh-SSH

#create a new SSH session
New-SSHSession -ComputerName 'web01-ryan' -Credential (get-credential ryan)


#run infintley, instead of asking for password before each command
while ($true) {

#create a prompt for the command
$the_cmd = Read-Host -Prompt "Please enter a command"

# Look for the keyword exit and stop executing or itll keep running invoke-sshcommand
if ($the_cmd -eq "exit") {

break

}

#Run a command on the remote system
(Invoke-SSHCommand -index 0 $the_cmd).output

}