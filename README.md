# powershell_vagrant_install
Powershell script to quickly install Vagrant, Oracle Virtualbox and Cygwin on Windows 7 Service Pack 1 or Windows 10

## Validate Execution Policy in Windows 10
in Windows 10 execution of scripts that are not signed is not permitted. The policies must be set correctly. 
back up the %PATH% variable
`echo %PATH`
save the output

check current policies
`Get-ExecutionPolicy -List`

Set execution policies to allow unsigned scripts
`Set-ExecutionPolicy -ExecutionPolicy RemoteSigned`
`Set-ExecutionPolicy -ExecutionPolicy Undefined -Scope LocalMachine`

more info at https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_execution_policies?view=powershell-6



