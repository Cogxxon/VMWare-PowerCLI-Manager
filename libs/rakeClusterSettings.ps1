<#################################################
o---|-Name: updateClusterSettings
o---|-Auther: Garvey Snow
o---|-Description: Rake and dump cluster settings into json file
                   location: script directory 
                   data\cluster_settings\cached\ " < clusterName-cluster-settings-data.json > "
                   adds it to the $global:defaultVIServers
o---|-Version: 0.1b
#################################################>
function rakeClusterSettings()
{

    param (
        
        [string[]]$clusterName,
        [string[]]$path
    
    )
    
    if($clusterName -eq $null)
    {
        try
        {
            WRITE-SEGLINE -action -numlines 2 -firstline 'Searching for cluster' -secondline $Global:config.vmhost_cluster_name -color white
            WRITE-SEGLINE -response -numlines 2 -firstline 'Attempting to Rake settings from Cluster $global:config.vmhost_cluster_name >>' -secondline $Global:config.vmhost_cluster_name -color yellow
            $cluster_object = Get-Cluster -Name $Global:config.vmhost_cluster_name -ErrorAction stop
            WRITE-SEGLINE -response -numlines 1 -firstline 'Settings Raked' -color green
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
            WRITE-SEGLINE -action -numlines 2 -firstline 'Searching for cluster' -secondline $clusterName  -color white
            $cluster_object = Get-Cluster -Name $clusterName -ErrorAction stop
            WRITE-SEGLINE -response -numlines 2 -firstline 'Attempting to Rake settings from cluster' -secondline $cluster_object.Name -color green
        }
        catch
        {
            Write-Host -ForegroundColor red '=============[ ERROR EXCEPTION ]=============================='
            Write-Host -ForegroundColor red 'Unable to Locate cluster with provided name: ' -NoNewline; Write-Host -ForegroundColor Cyan $cluster_name
            Write-Host -ForegroundColor yellow 'please check the config settings location in ' -NoNewline; Write-Host -ForegroundColor Cyan 'vmware-cli-manager.ps1'
        }
    }
        
    # Convert path to string[] format
    $str_path = $path.ToString()
  
    # Create var with file friendly [chars]
    $date = Get-Date;  $f_date = $date -replace '/','-' -replace ' ','-' -replace ':','-'

    # Create opening path string
    $json_openpath = $Global:config.psdrive_name_friendly_name + 'data\cluster_settings\cluster_settings_default.json'
    
    # Create savepath to use if -path [switch] is not provided
    $jsonFile_savePath =   $Global:config.psdrive_name_friendly_name + 'data\cluster_settings\cached\' + $Global:config.vmhost_cluster_name + '-cluster_settings-'+$f_date+'.json'
    
    # Create savepath custom to use if -path [switch] is provided
    $jsonFile_savePath_custom = path + $Global:config.vmhost_cluster_name + '-cluster_settings-'+$f_date+'.json'

    # Create var populated with the JSON file with filer/folder friendly Name
    $jsonFile_name = $Global:config.vmhost_cluster_name + '-cluster_settings-'+$f_date+'.json'

    #########################
    # INJECT INTO JSON FILE #
    # --------------------- #
    #########################
    WRITE-SEGLINE -action -numlines 2 -firstline 'Importing Default JSON File' -secondline $json_openpath -color green
    WRITE-SEGLINE -action -numlines 2 -firstline 'Converting JSON to Empty PSObject' -secondline $raw_json_cluster_data -color yellow
    $raw_json_cluster_data = Get-Content -Path $json_openpath | ConvertFrom-Json
    WRITE-SEGLINE -response -numlines 1 -firstline 'Coversion Successful' -color yellow

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

    if($path -eq $null)
    { 
        WRITE-SEGLINE -action -numlines 3 -firstline 'Injecting Data into JSON File' -secondline $jsonFile_name -thirdline $jsonFile_savePath
        #$raw_json_cluster_data | ConvertTo-Json | Out-File -FilePath $jsonFile_savePath 
    }
    else
    { 
        WRITE-SEGLINE -action -numlines 3 -firstline 'Injecting Data into JSON File' -secondline $jsonFile_name -thirdline $jsonFile_savePath_custom
        #$raw_json_cluster_data | ConvertTo-Json | Out-File -FilePath $jsonFile_savePath_custom
    }
    
    

}
