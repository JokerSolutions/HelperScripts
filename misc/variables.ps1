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
$global:substDir = "z:\work"
Write-Host($substDir)
$global:substDrive = "W:"

#Find the bitness of the (Windows) OS and store it in env var AddressWidth
$global:isWin64=[System.Environment]::Is64BitOperatingSystem
$global:addressWidth = $null
if ($isWin64) {
	$addressWidth = 64;
} else {
	$addressWidth = 32;
}

Write-Host("The system is $($addressWidth)bit wide")
