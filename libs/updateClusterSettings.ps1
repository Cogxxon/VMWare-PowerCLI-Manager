################################
# http://json.org/example.html #
################################
function rakeClusterSettings()
{

    param (
        
        [string[]]$clusterName
    
    )
    
    if($clusterName -eq $null)
    {
        try
        {
            WRITE-SEGLINE -action -numlines 2 -firstline 'Searching for cluster' -secondline $Global:config.vmhost_cluster_name
            WRITE-SEGLINE -response -numlines 2 -firstline 'Attempting to Rake settings from Cluster' -secondline $Global:config.vmhost_cluster_name -color green
            $cluster_object = Get-Cluster -Name $Global:config.vmhost_cluster_name -ErrorAction stop
        }
        catch
        {
            Write-Host -ForegroundColor red '=============[ ERROR EXCEPTION ]=============================='
            Write-Host -ForegroundColor red 'Unable to Locate cluster with provided name: ' -NoNewline; Write-Host -ForegroundColor Cyan $Global:config.vmhost_cluster_name
            Write-Host -ForegroundColor yellow 'please check the configuration settings location in ' -NoNewline; Write-Host -ForegroundColor Cyan 'vmware-cli-manager.ps1'
        }
    }
    else
    {
        try
        {
            WRITE-SEGLINE -action -numlines 2 -firstline 'Searching for clustere' -secondline $clusterName  
            $cluster_object = Get-Cluster -Name $Global:config.vmhost_cluster_name -ErrorAction stop
            WRITE-SEGLINE -response -numlines 2 -firstline 'Attempting to Rake settings from cluster' -secondline $cluster_object.Name -color green
        }
        catch
        {
            Write-Host -ForegroundColor red '=============[ ERROR EXCEPTION ]=============================='
            Write-Host -ForegroundColor red 'Unable to Locate cluster with provided name: ' -NoNewline; Write-Host -ForegroundColor Cyan $cluster_name
            Write-Host -ForegroundColor yellow 'please check the config settings location in ' -NoNewline; Write-Host -ForegroundColor Cyan 'vmware-cli-manager.ps1'
        }
    }
        



    $date = Get-Date;  $f_date = $date -replace '/','-' -replace ' ','-' -replace ':','-'

    $json_openpath = $Global:config.psdrive_name_friendly_name + 'data\cluster_settings\cluster_settings_default.json'
    $jsonFile_savePath =   $Global:config.psdrive_name_friendly_name + 'data\cluster_settings\cached\' + $Global:config.vmhost_cluster_name + '-cluster_settings-'+$f_date+'.json'
    $jsonFile_name = $Global:config.vmhost_cluster_name + '-cluster_settings-'+$f_date+'.json'

    if($clustername -like "OneClus"){}

    #########################
    # INJECT INTO JSON FILE #
    # --------------------- #
    #########################
    WRITE-SEGLINE -action -numlines 2 -firstline 'Importing Default JSON File' -secondline $json_openpath -color green
    $raw_json_cluster_data = Get-Content -Path $json_openpath | ConvertFrom-Json

    WRITE-SEGLINE -action -numlines 2 -firstline 'Injecting Data into JSON File' -secondline $jsonFile_name
    $raw_json_cluster_data.clusterObject.clusterName = $Global:config.vmhost_cluster_name
     $raw_json_cluster_data.clusterObject.DrsAutomationLevel = ($cluster_object.DrsAutomationLevel).ToString()
      $raw_json_cluster_data.clusterObject.DrsEnabled = $cluster_object.DrsEnabled
       $raw_json_cluster_data.clusterObject.DRSMode = ($cluster_object.DrsMode).ToString()
        $raw_json_cluster_data.clusterObject.EVCMode = $cluster_object.EVCMode
         $raw_json_cluster_data.clusterObject.HAFailoverLevel = ($cluster_object.HAFailoverLevel).ToString()
         $raw_json_cluster_data.clusterObject.DrsEnabled = $cluster_object.DrsEnabled
          $raw_json_cluster_data.clusterObject.HARestartPriority = $cluster_object.HARestartPriority
           $raw_json_cluster_data.clusterObject.VMSwapfilePolicy = ($cluster_object.VMSwapfilePolicy).ToString()
            $raw_json_cluster_data.clusterObject.used = ""
             $raw_json_cluster_data.clusterObject.updated = (Get-Date).DateTime
              $raw_json_cluster_data.clusterObject.servers_in_cluster = ($cluster_object | Get-VMHost).name


    #############################
    # OUTPUT MODIFIED JSON FILE #
    # ------------------------- #
    #############################
    
    $raw_json_cluster_data | ConvertTo-Json | Out-File $jsonFile_savePath

}


