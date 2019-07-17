### Script för att uppdatera rdweb-filerna på S200 ###
### Kör med adminrättigheter ###
### /Joakim Johnson 2019-05-21 ###


### Stoppa tjänsten "Tieto Component Manager Service" om den är igång.
$ServiceName = 'Tieto Component Manager Service'
$arrService = Get-Service -Name $ServiceName

while ($arrService.Status -eq 'Running')
{
    Stop-Service $ServiceName
    write-host $arrService.status
    write-host 'Service stopping'
    Start-Sleep -seconds 60
    $arrService.Refresh()
    if ($arrService.Status -eq 'Stopped')
    {
        Write-Host 'Service is now Stopped'
    }
}

### Döp om mapp om den finns
$MmmFolder = "C:\mmm"
$FileExists = Test-Path $MmmFolder
If ($FileExists -eq $True) {
        $date = (Get-Date).ToString("yyyy-MM-dd")
        Rename-Item -Path "C:\mmm" -NewName "mmm backup $date" -ErrorAction Stop
        Write-Verbose "Renamed folder C:\mmm to mmm backup $date" -Verbose
    }
Else {Write-Verbose "No Mmm folder at C:\ - Moving on create one and copy files" -Verbose}

### Kopiera över filer | Saknar behörighet efter domain admin-roll är borta
### Copy-Item -Path "\\S390\d$\Lifecare\mmm" -Destination "C:\mmm" -recurse -force -verbose