function retrieveSuitableHost()
{
    # ----------------------------\
    # CREATE ARRAY TO HOLD OBJECTS
    # ----------------------------/
    $vmHostMemoryHash = @()

    ##################################################################################\
    ## FOR LOOP
    # Loop through vm's in cluster and select the one with heighest avalable memory
    ##################################################################################/
    Get-Cluster -Name $global:config.vmhost_cluster_name | Get-VMHost | % { 
																			$vmHostFreeMemory = $_.MemoryTotalGB - $_.MemoryUsageGB ; $vmHostMemoryHash += New-Object -TypeName PSObject -Property @{ 
																						
																																																		VMHostName = $_.name; 
																																																		VMHostFreeMemory = $vmHostFreeMemory 
																																																	}
																		  }
    
    ##########################\
    # RETURN [0] In array list
    ##########################/
    return ($vmHostMemoryHash | Sort-Object -Descending)[0]

    $vmHostMemoryHash = $null
}




