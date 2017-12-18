#-------------------------------
# Upgrade Cluster - builds a list from the cluster name provided and updates
# the list of host with-in that cluster allowing selected update
#------------------------------

function upgradeCluster 
{


        if($global:config.prepared_status -eq 'prepared')
        {
            ### ENABLE 
            ### DRS ON CLUSTER
            ### To allow live migration if not enable the 
            ### and EVCMode for CPU features Compatability
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
                        write-host -ForegroundColor yellow '--------------------[ Current Esxi Version: '$vmhost.Version
                        write-host -ForegroundColor yellow '--------------------[ Destination Host: '$vmhost.Name
                        write-host -ForegroundColor yellow '--------------------[ Live Migrating VMs off - '$vmhost.name' to' -NoNewline; write-host -ForegroundColor Cyan 
                        
                        # list host affected my migration
                        # -------------------------------
                        Get-VMHost $vmhost | Get-VM | FT -AutoSiz
                        write-host -ForegroundColor yellow '------------------------------------------------------'                        
                        
                        # MIGRATE VM
                        Get-VMHost $vmhost.name | Get-VM | ? { $_.PowerState -eq 'poweredon' } | % {
                        
                                                                                                        # --------------------------------
                                                                                                        # 1. Find suitible Host for migration
                                                                                                        # 2. If all poweredon vm's are migrated off
                                                                                                        #    places VMHost into M-Mode
                                                                                                        # 3. Upgrade host while in M-Mode
                                                                                                        # 4. once update and version matches $global:config.esxi_upgrade_version
                                                                                                        #    remove M-Mode and move the next host, upgrade host will be added
                                                                                                        #    back to the pool of suiteble hosts for VM migration
                                                                                                        # --------------------------------
                                                                                                        $esxi_server_viable = retrieveSuitableHost -currenthost $vmhost.name
                                                                                                        WRITE-SEGLINE -action -firstline 'Finding suitible Host server for Migration' -numlines 1 -color yellow
                                                                                                        WRITE-SEGLINE -response -firstline 'Found  -' -secondline $esxi_server_viable.VMHostName -color green -numlines 3 -thirdline "Free Memory - $esxi_server_viable.VMHostFreeMemory GB"
                                                                                                        
                                                                                                        if(Get-VMHost -Name $vmhost.name | Get-VM | ? {$_.PowerState -eq 'poweredon'})
                                                                                                        {
                                                                                                            #---------------------------------------------------------------------
                                                                                                            #  migrate off VMHost to undergo upgrade
                                                                                                            #---------------------------------------------------------------------
                                                                                                            Write-Host -ForegroundColor Yellow 'Migration VM > ' -NoNewline;
                                                                                                            Write-Host -ForegroundColor Cyan " $_ to > " -NoNewline;
                                                                                                            Write-Host -ForegroundColor Gray $esxi_server_viable.VMHostName
                                                                                                            Move-VM -VM $_.Name -Server ($esxi_server_viable).VMHostName -Verbose -Confirm:$false

                                                                                                        }
                        
                                                                                                    } <#END FOREACH#>
                        # please host into maintenance mode
                        # WRITE-SEGLINE -action -firstline 'Putting VMHost ' -secondline $vmhost.name -thirdline ' Into Maintenance Mode' -numlines 3                                        
                        # WRITE-SEGLINE -action -numlines 2 -firstline 'Placing Host into maintenace' -secondline $vmhost.name
                        # Get-VMHost -Name $vmhost.name | Set-VMHost -State "Maintenance" -Verbose -Confirm:$false  



                        # -------------------------------------------------------------------------
                        #Get-VMHost -Name $vmhost | Set-VMHost -state "Maintenance" -Confirm:$false
                        # -------------------------------------------------------------------------

                    }       
            } # END FOREACH

        } # END IF
        else 
        {  
            Write-Host -ForegroundColor red '-----------------------[ Cluster Status ]------------------------'
            Write-Host -ForegroundColor yellow 'Prepared Status' -NoNewline; Write-Host -ForegroundColor $global:config.prepared_status;
            Write-Host -ForegroundColor red '-----------------------[ Cluster Status ]------------------------'
        }
}



























