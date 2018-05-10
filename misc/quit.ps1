<#
.SYNOPSIS
   <A brief description of the script>
.DESCRIPTION
   <A detailed description of the script>
.PARAMETER <paramName>
   <Description of script parameter>
.EXAMPLE
   <An example of using the script>
#>

#Setup Subst options
#The origin location of the work folder.
$global:substDir = "z:\work"
#The newly created drive letter that we (temporarily) use for working in
$global:substDrive = "W"

Pop-Location
Get-PSDrive | Out-Null
subst "$global:substDrive`:" /d
Exit-PSHostProcess