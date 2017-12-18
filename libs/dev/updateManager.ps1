function updateManger()
{
    param(
        [string[]]$baselineName,
        [string[]]$hostname,
        [switch][parameter(ValueFromPipeline=$true)]$updatehost
    )


    # switch value or use config file value
    if($baselineName -eq $null)
    {
        $baselineName = $global:config.baseline_name;
    }else
    {
        $baselineName = $baselineName;
    }

    if($updatehost -eq $true){
    
        # code to update host here
        Get-VMHost -Name $hostname | Set-PatchBaseline -Name $baselineName

    }
}