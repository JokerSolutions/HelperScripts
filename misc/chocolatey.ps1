# download and save installation script, then check signature
$url = 'https://chocolatey.org/install.ps1'
$outPath = "$env:temp\installChocolatey.ps1"
Invoke-WebRequest -UseBasicParsing -Uri $url -OutFile $outPath

# test signature
$result = Get-AuthenticodeSignature -FilePath $outPath
if ($result.Status -ne 'Valid')
{
    Write-Warning "Installation Script Damaged/Malware?"
    exit 1
}

# install chocolatey for current user
$env:ChocolateyInstall='w:\apps\chocolatey'

Start-Process -FilePath powershell -ArgumentList "-noprofile -noExit -ExecutionPolicy Bypass -File ""$outPath""" -Wait

# clean up
Remove-Item -Path $outPath