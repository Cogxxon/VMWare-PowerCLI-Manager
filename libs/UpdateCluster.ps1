#-------------------------------
# Upgrade Cluster - builds a list from the cluster name provided and updates
# the list of host with-in that cluster allowing selected update
#------------------------------
function updateCluster {
    
        if($global:config.prepared_status -eq 'prepared')
        {
            ### ENABLE 
            ### DRS ON CLUSTER
            if((Get-Cluster -Name $global:config.vmhost_cluster_name).DrsEnabled -eq $false)
            {
                Get-Cluster -Name $global:config.vmhost_cluster_name | Set-Cluster -DrsEnabled $true -Confirm:$false -Verbose
            }

            foreach($vmhost in $global:cluster_VMHost_list)
            {
                    #--------------------------------------------------------
                    # Check VMHost Verion against version provided in config
                    # If VMHost is new version then skip and add to the report  
                    #--------------------------------------------------------
                    if($vmhost.Version -eq $global:config.esxi_upgrade_version)
                    {
                        WRITE-SEGLINE -action -firstline 'Checking if ' -secondline $vmhost.name -thirdline ' is in Maintenance Mode' -numlines 3
                        WRITE-SEGLINE -action -firstline 'Putting VMHost ' -secondline $vmhost.name -thirdline ' Into Maintenance Mode' -numlines 3
                        write-host -ForegroundColor yellow '--------------------[ Live Migrating VMs off - '$vmhost
                        write-host -ForegroundColor yellow '--------------------[ Current Esxi Version: '$vmhost.Version
                        
                        # list host affected my migration
                        # -------------------------------
                        Get-VMHost $vmhost | Get-VM | FT -AutoSiz
                        write-host -ForegroundColor yellow '------------------------------------------------------'                        
                        
                        
                        Get-VMHost $vmhost.name | Get-VM | ? { $_.PowerState -eq 'poweredon' } | % {
                        
                                                                                                    # get suitible Host for migration
                                                                                                    $esxi_server_viable = retrieveSuitableHost($vmhost.name)
                                                                                                    $esxi_server_viable
                                                                                                    # Move-VM -VM $_.Name -Server $esxi_server_viable.VMHostName
                        
                                                                                                  }

                        #---------------------------------------------------------------------
                        #  migrate off VMHost to undergo upgrade
                        #---------------------------------------------------------------------
                        # -------------------------------------------------------------------------
                        #Get-VMHost -Name $vmhost | Set-VMHost -state "Maintenance" -Confirm:$false
                        # -------------------------------------------------------------------------

                    }       
            } # END FOREACH

        } # END IF
    
}



#for($vmhc = 0; $vmhc -le ($global:cluster_VMHost_list).count; $vmhc++)
#{
#   
#   $global:cluster_VMHost_list[$vmhc]
#}