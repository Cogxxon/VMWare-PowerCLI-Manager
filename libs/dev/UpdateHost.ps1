# Upgrade Cluster - builds a list from the cluster name provided and updates
# the list of host with-in that cluster allowing selected update
#------------------------------
if($prepareCluster -eq $true)
{


}

if($upgradeCluster -eq $true)
{
    foreach($vmhost in $cluster_VMHost_list)
    {
            #--------------------------------------------------------
            # Check VMHost Verion against version provided in config
            # If VMHost is new version then skip and add to the report  
            #--------------------------------------------------------
            if($vmhost.Version -like $ESXI_Upgrade_Version)
            {
                WRITE-SEGLINE -action -firstline 'Putting VMHost ' -secondline $vmhost.name -thirdline ' Into Maintenance Mode' -numlines 3
                write-host -ForegroundColor yellow 'Live Migrating VMs off - '$vmhost
                write-host -ForegroundColor yellow '--------------'
                $vmhost | Get-VM | FT -AutoSize

                #---------------------------------------------------------------------
                # Put VMHost into Maintenance Mode and Wait While VM's are migrate off
                #---------------------------------------------------------------------
                # Set-VMHost -VMHost $vmhost.Name -State Maintenance -Confirm:$false
                while(Get-VMHost -Name $vmhost.State -like 'Maintenance')
                {
                   #-------------------------
                   # Update Host Only
                   #-------------------------  
                }

            }       
    } # END FOREACH

} # END IF

if($vcenterMigration -eq $true)
{
    
}

