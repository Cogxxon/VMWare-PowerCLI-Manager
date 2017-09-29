function retrieveSuitableHost()
{
    param ([string[]]$currenthost)
    # ----------------------------\
    # CREATE ARRAY TO HOLD OBJECTS
    # ----------------------------/
    $vmHostMemoryHash = @()

    ##################################################################################\
    ## FOR LOOP
    # Loop through vm's in cluster and select the one with heighest avalable memory
    ##################################################################################/
    Get-Cluster -Name $global:config.vmhost_cluster_name | Get-VMHost |  % { 
                                                                                if($_.Name -notlike $currenthost)
                                                                                {
                                                                                    $vmHostFreeMemory = $_.MemoryTotalGB - $_.MemoryUsageGB ; 
                                                                                    $vmHostMemoryHash += New-Object -TypeName PSObject -Property @{ VMHostName = $_.name; VMHostFreeMemory = $vmHostFreeMemory }
                                                                                } else
                                                                                {
                                                                                    # Do something here
                                                                                }
                                                                          }
    
    ##########################\
    # RETURN [0] In array list
    # Allowing the return of a single host
    # with the lowest memory usage
    ##########################/
    return ($vmHostMemoryHash | Sort-Object -Descending)[0]

    #########################
    # Reset Value $vmHostMemoryHash
    # So function can be called
    # with blank variables
    #########################
    $vmHostMemoryHash = $null
}




