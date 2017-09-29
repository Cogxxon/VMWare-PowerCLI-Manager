$maxQ = 100
$index = 0

while($index -ne $maxQ)
{
    $percent_c = $index++
    Write-Progress -Activity 'Searching Data Store' -Status 'Working' -PercentComplete $percent_c
    #Start-Sleep -Seconds 1  
}


for ($I = 1; $I -le 100; $I++ )
{
    Write-Progress -Activity "Search in Progress" -Status "$I% Complete:" -PercentComplete $I;
    Start-Sleep -Milliseconds 500
}


for($I = 1; $I -lt 101; $I++ )
{
    Write-Progress -Activity Updating -Status 'Progress->' -PercentComplete $I -CurrentOperation OuterLoop; `
    Start-Sleep -Milliseconds 500

    for($j = 1; $j -lt 101; $j++ )
    {
        Write-Progress -Id 1 -Activity Updating -Status 'Progress' - PercentComplete $j -CurrentOperation InnerLoop
    } 
}


$vms = Get-Cluster -Name 'PRD Cluster' | Get-VMHost | Get-VM

for($b = 0; $b -lt ($vms).count; $b++)
{
    $vms[$b]
    $status_string = 'Checking VM - ' + $vms[$b] + '- %' + $b 
    Write-Progress -Activity Interating -PercentComplete $b -Status $status_string
    Start-Sleep -Milliseconds 100
}
Clear-Variable($b)


function tsy{
$global:evn_status = New-Object -TypeName psobject
$global:evn_status | Add-Member -MemberType NoteProperty -Name 'prepare_status' -Value 'unprepared' # partially # unprepared
}


# Total time to sleep
$start_sleep = 120

# Time to sleep between each notification
$sleep_iteration = 30

Write-Output ( "Sleeping {0} seconds ... " -f ($start_sleep) )
for ($i=1 ; $i -le ([int]$start_sleep/$sleep_iteration) ; $i++) {
    Start-Sleep -Seconds $sleep_iteration
    Write-Progress -CurrentOperation ("Sleep {0}s" -f ($start_sleep)) ( " {0}s ..." -f ($i*$sleep_iteration) )
}
Write-Progress -CurrentOperation ("Sleep {0}s" -f ($start_sleep)) -Completed "Done waiting for X to finish"




$global:config = New-Object -TypeName psobject;
$global:config | Add-Member -MemberType NoteProperty -Name prepared_status -Value 'unprepared'
$global:config | Add-Member -MemberType All -Name log -Value @{}