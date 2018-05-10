function AskYN {
    param([string]$Question)
    Write-Host $Question -foregroundcolor Yellow; $Answer = Read-Host " ( y / n ) "
    switch ($Answer)
    {
        Y {Write-Host "Yes, overwrite powershell profile"; return $Answer}
        N {Write-Host "No, profile not altered, and the shell will NOT be opened!"; return $Answer}
        Default {Write-Host "Default, overwrite powershell profile"; return $Answer}
    }
}

function CompareFile {
    param( [string]$File1, [string]$File2 )
    if ((Get-FileHash($File1)) -eq (Get-FileHash($File2))) {
        return $true
    } else {
        return $false
    }
}

#Check if there is a PowerShell profile and if not create one
if (test-path $PROFILE) {
    if (CompareFile -File1 $PROFILE -File2 "$PSScriptRoot\variables.ps1") {
        #do nothing
    }
    else {
        $userConfirm = AskYN("This will overwrite your default powershell profile $($PROFILE)")
        if ($userConfirm -eq "y") {
            Copy-Item -Path $PSScriptRoot\variables.ps1 -Destination $PROFILE -Force
            Write-Host "profile override accepted"
        }
        elseif ($userConfirm -eq "n") {
            #do nothing
            Write-Host "This should be a 'simple' abort"
        }
    }
    
} else {
    Copy-Item -Path $PSScriptRoot\variables.ps1 -Destination $PROFILE
    Write-Host "new profile created"
}

#I'm still not convinced that this is the best way to get a bunch of variables together and have them available in my subst'ed environment
Try {
    $conemulocation = "$PSScriptRoot\..\apps\conemu\Conemu64.exe"
    # We don't want the current path to affect which "chef shell-init powershell" we run, so we need to set the PATH to include the current omnibus.
    $shellBin = (split-path $MyInvocation.MyCommand.Definition -Parent)
    Write-Host $shellBin
    $shellInit = '"$env:PATH = ''' + $shellBin + ';'' + $env:PATH; $env:DevEnv_FIX = 1"'
    $shellGreeting = "echo 'PowerShell $($PSVersionTable.psversion.tostring()) ($([System.Environment]::OSVersion.VersionString))';write-host -foregroundcolor darkyellow 'Ohai, welcome to the Development Shell!`n'"
    $shellCommand = "$shellInit;$shellGreeting"
    $shellTitle = "Administrator: DevEnv ($env:username)"

    Start-Sleep 2
    if ( test-path $conemulocation )
    {
        $proc = $(start-process $conemulocation -verb runas -PassThru -Wait -argumentlist '/title',"`"$shellTitle`"",'/cmd','powershell.exe','-noexit','-command',$shellCommand)
    }
    else
    {
        $proc = $(start-process powershell.exe -verb runas -PassThru -Wait -argumentlist '-noexit','-command',"$shellCommand; (get-host).ui.rawui.windowtitle = '$shellTitle'")
    }
    $proc | Wait-Process
}
Catch
{
    Start-Sleep 10
    Throw $_.Exception.Message
}
