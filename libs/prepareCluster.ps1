function prepareCluster()
{
       
        #-------------------------------------
        # Retreive list of host within cluster
        #-------------------------------------
        $global:cluster_VMHost_list = Get-Cluster -Name $global:config.vmhost_cluster_name | Get-VMHost

        <#
         Prepare cluster for Host Migration this Checks that HA EVC DRS is enabled 
         if enabled disable append to VM Notes  
         Finding dvswitch attached to cluster: Get-Cluster -name <cluster name> | Get-VMHost | Get-VDSwitch
                                               Get-Cluster -name <cluster name> | Get-VMHost | Get-VDSwitch | Get-VDPortgroup
         Add VM Host to DV Switch              Add-VDSwitchVMHost 
         Remove VM host from DV Switch         Remove-VDSwitchVMHost                 
        #>
        
        $clusterObject = Get-Cluster -Name $global:config.vmhost_cluster_name
        ############################################################\
        # Check if DRS Mode is enabled & disables if $true          #
        ############################################################/
        WRITE-SEGLINE -action -firstline 'Checking DrsMode for Cluster: ' -secondline $clusterObject -numlines 2 -color yellow
        if($clusterObject.DrsEnabled -eq $true)
        { 
            WRITE-SEGLINE -action -firstline 'DrsMode Enabled on Cluster ' -secondline $clusterObject -thirdline 'Disabling for VMHost Migration' -numlines 3 -color red
            if($global:config.running_mode -eq 'live')
            { 
                get-Cluster -Name $global:config.vmhost_cluster_name | Set-Cluster -DrsEnabled $false -Verbose -Confirm:$false
            }
        }
        ########################################################\
        # Check if HA Mode is enabled & disables if $true       #
        ########################################################/     
        WRITE-SEGLINE -action -firstline 'Checking HAMode for Cluster: ' -secondline $clusterObject -numlines 2 -color yellow
        if($clusterObject.HAEnabled -eq $true)
        { 
            WRITE-SEGLINE -action -firstline 'HAMode Enabled on Cluster ' -secondline $clusterObject -thirdline 'Disabling for VMHost Migration' -numlines 3
             if($global:config.running_mode -eq 'live')
             { 
                get-Cluster -Name $global:config.vmhost_cluster_name | Set-Cluster -HAEnabled $false -Verbose -Confirm:$false
             }
        }
        ########################################################\
        # Check if EVCMode is enabled & disables if $true       #
        ########################################################/   
        WRITE-SEGLINE -action -firstline 'Checking HAMode for Cluster: ' -secondline $clusterObject -numlines 2 -color yellow
        if($clusterObject.EVCMode -ne $null)
        {
            WRITE-SEGLINE -action -firstline 'EVCMode Enabled on Cluster ' -secondline $clusterObject -thirdline 'Disabling for VMHost Migration' -numlines 3            
            if($global:config.running_mode -eq 'live')
            { 
                get-Cluster -Name $global:config.vmhost_cluster_name | Set-Cluster -EVCMode $null -Confirm:$false -Verbose 
            }
        }
                
        WRITE-SEGLINE -action -firstline 'Listing VMHosts Affected by Preperation for Cluster' -secondline $global:config.vmhost_cluster_name -numlines 2 -color yellow
        Write-Host -BackgroundColor cyan -ForegroundColor Black '--##############################################--'
        Write-Host -BackgroundColor cyan -ForegroundColor Black '--############### Affected Hosts ###############--'
        $global:cluster_VMHost_list | FT -AutoSize
        Write-Host -BackgroundColor cyan -ForegroundColor Black '--##############################################--'
    #---------------------------------------------------------------------
    ########################################################/

    ## STATUS #####
    Write-Host -BackgroundColor cyan -ForegroundColor Black "--## Migration Status: $global:config.prepared_status ##--"
    Write-Host -BackgroundColor cyan -ForegroundColor Black '--################### CLUSTER STATUS ###################--'

    get-Cluster -Name $global:config.vmhost_cluster_name | select Name,DrsEnabled,EVCMode,HAEnabled | FL

    Write-Host -BackgroundColor cyan -ForegroundColor Black '--######################################################--'
    ###############


        ################
        $clusterObject = Get-Cluster -Name $global:config.vmhost_cluster_name
        if($clusterObject.EVCMode -eq $null -and $clusterObject.DrsEnabled -eq $false -and $clusterObject.HAEnabled -eq $false)
        {
            WRITE-SEGLINE -action -numlines 3 -firstline 'Setting global variable' -secondline '$global:config.prepared_status value' -thirdline 'prepared'
            $global:config.prepared_status = 'prepared';
        }
        else
        {
            WRITE-SEGLINE -error -numlines 3 -firstline 'PrepareCluster Could not complete' -secondline '$global:config.prepared_status value' -thirdline 'partially' -color red
            $global:config.prepared_status = 'partially';
        }
        ################

}