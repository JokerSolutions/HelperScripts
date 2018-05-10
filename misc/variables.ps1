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

#Some Housekeeping stuff
#Update-Help
if ($Host.UI.RawUI.WindowTitle -like "*administrator*") {
    $Host.UI.RawUI.ForegroundColor = "Red"
}

#Setup Subst options
#The origin location of the work folder.
$global:substDir = "z:\work"
#The newly created drive letter that we (temporarily) use for working in
$global:substDrive = "W"

#Find the bitness of the (Windows) OS and store it in env var AddressWidth
$isWin64=[System.Environment]::Is64BitOperatingSystem
$global:addressWidth = $null
if ($isWin64) {
	$addressWidth = 64;
} else {
	$addressWidth = 32;
}

subst "$global:substDrive`:" "$($global:substDir)"
Get-PSDrive | Out-Null
Push-Location
Push-Location -Path "$global:substDrive`:"
Pop-Location