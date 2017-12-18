<#
    AUTHER      : Garvey Snow
    VERSION     : 1.2
    DESCRIPTION : Iterate's through datastore within a datacenter within vCenter and check inventory VM's
                  against VM's loaded onto storage, returns a report with active vs orpahned vm's
    DEPENDANCIES: Connection Instance to vCenter Server
    LICENCE     : GNU GENERAL PUBLIC LICENSE
#>
function storageReport()
{
    # --------------------------------------------------------------------- #
    # Iterate's through datastore within a datacenter within vCenter and check inventory VM's
    # against VM's loaded onto storage, returns a report with active vs orpahned vm's
    # --------------------------------------------------------------------- #
    
    #VARS
    #====
    $data_center = 'NDC'

    # OBJECT 
    # ------
    $report_container = @()

    # Start Loop
    # ----------
    foreach($datastore in (Get-Datastore))
    {     
            #=QUERY STRING=#
            $ds_fpath = 'vmstores:\' + $global:defaultVIServer[0].Name + '@443\' + $data_center + '\' + $datastore.Name
            Write-Host -f Yellow 'Building Query-String for Datastore -[( ' -NoNewline; Write-Host -f Cyan $datastore.Name -NoNewline; Write-Host -F DarkCyan "--[( $ds_fpath"
            #==============#
            
            #=GET CHILD ELEMENTS OF DATASTORE=#
            Write-Host -f Yellow 'Interating Datastore -[( ' -NoNewline; Write-Host -f Cyan $datastore.Name
            $dataStore_contents = Get-ChildItem $ds_fpath
            #=================================#

            foreach($content in $dataStore_contents)
            { 

                    if($vm_result = Get-VM -Name $content.Name -ErrorAction SilentlyContinue)
                    {
                       Write-Host -F Gray 'Checking VM Folder --' -NoNewline; write-host -F Yellow $vm_result.Name +' on '+ $datastore

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

                                                                                     }
                   }

            }
          

    }
    $report_container | FT
    $report_container | Export-Csv 'H:\Reports\VMWare Reports\NDC-Storage-Report-orphaned-vms.csv'
    
}