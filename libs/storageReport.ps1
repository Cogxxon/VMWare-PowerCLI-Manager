function storageReport()
{
    # --------------------------------------------------------------------- #
    # Iterate through registered VM's on datastore registered on vCenter
    # And check against folder names with-in datastore
    # build and object and plush in HASH Table for output/export
    # if mutilple vcenters are in use, the all-linked option can be used, 
    # however this has some issues if venter's are not linked to a parat
    # --------------------------------------------------------------------- #
    
    # OBJECT 
    # ------
    $report_container = @()

    # Start Loop
    # ----------
    foreach($datastore in $Global:datastore_array)
    {
        $dsMeta = Get-Datastore -Name $datastore
        if($dsMeta.Type -eq 'VMFS')
        {
            
            $dc_fpath = 'vmstores:\' + $Global:vCenter_Servers[0] + '@443\' + $Global:data_center + '\' + $datastore

            $dataStore_contents = Get-ChildItem $dc_fpath -verbose

            foreach($content in $dataStore_contents)
            { 
                       #=======[CALCULATE VM Folder contents Total Size]==========
                       # Note add Varibale for this string
                       $folder_path = $dc_fpath + '\' + $content.Name +'\'
                       $folders = Get-ChildItem -Recurse $folder_path -Verbose
                       $size = 0
                       foreach($folder in $folders)
                       {
                           $size += $folder.Length
                       }

                       $GBSize  = $size / 1GB; [math]::Round($GBSize);
                       #==========================================================

                    if($vm_result = Get-VM -Name $content.Name -ErrorAction SilentlyContinue)
                    {
                       $vm_result.Name +' on '+ $datastore

                       $report_container += New-Object -TypeName PSObject -Property @{
               
                                                                                       ConStat = 'In-Use-Active'
                                                                                       Container = $content.Name
                                                                                       VMName = $vm_result.Name
                                                                                       DataStore = $content.Datastore
                                                                                       PowerState = $vm_result.PowerState
                                                                                       VMVersion = $vm_result.Version
                                                                                       MemoryGB = $vm_result.MemoryGB
                                                                                       GuestId = $vm_result.GuestId
                                                                                       LastWriteTime = $content.LastWriteTime
                                                                                       UsedSpaceGB = [math]::Round($vm_result.UsedSpaceGB)
                                                                                       PSpaceGB = [math]::Round($vm_result.ProvisionedSpaceGB)
                                                                                       FolderSize = $GBSize 

                                                                                      }

                    } # END IF
                    else
                    {
                
                       $report_container += New-Object -TypeName PSObject -Property @{
               
                                                                                       ConStat = 'No-Matching-VM'
                                                                                       Container = $content.Name
                                                                                       VMName = '-------'
                                                                                       DataStore = $content.Datastore
                                                                                       PowerState = '-------'
                                                                                       VMVersion = '-------'
                                                                                       MemoryGB = '-------'
                                                                                       GuestId = '-------'
                                                                                       LastWriteTime = $content.LastWriteTime
                                                                                       UsedSpaceGB = '-------'
                                                                                       PSpaceGB = '-------'
                                                                                       FolderSize = $GBSize 

                                                                                     }
                   }

            }
          }

    }
    $report_container | FT
    
}