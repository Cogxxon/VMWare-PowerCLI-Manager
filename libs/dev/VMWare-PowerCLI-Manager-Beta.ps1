#------------------
# Import and Cache Vmware powerCLI for use with vmware
# Garvey Snow 11/09/2017
# HELP: https://blogs.vmware.com/PowerCLI/2013/03/back-to-basics-connecting-to-vcenter-or-a-vsphere-host.html
# COMMNAND-LETS: https://pubs.vmware.com/vsphere-51/index.jsp?topic=%2Fcom.vmware.powercli.cmdletref.doc%2FConnect-VIServer.html

# MAP Working folder
$network_UNC = '\\vprddfs01.calvarycare.local\NDC\Home\Garvey.Snow'
Write-host -ForegroundColor Cyan "Mapping PS-Drive NTFS DS Location:: " -NoNewline; write-host -ForegroundColor Green $network_UNC
New-PSDrive -Name 'VMWARE-DS-MAN' -PSProvider FileSystem -Root $network_UNC
#------------------
# DEPENDANCIES
#------------------
. 'VMWARE-DS-MAN:\write-segline.ps1'
#------------------
# DEP: Write-Seglin
#------------------


if(Find-Module -Name 'VMware.PowerCLI')
{
    # Install Module
    WRITE-SEGLINE -action -firstline 'Finding Module' -secondline 'VMware.PowerCLI' -numlines 2
    write-host -ForegroundColor Cyan 'Found Module VMware.PowerCLI'
    write-host -ForegroundColor Cyan 'Intalling VMware.PowerCLI for current user'
    Install-Module -Name VMware.PowerCLI –Scope CurrentUser

    # Save Mudule and cache to local folder
    write-host -ForegroundColor Cyan 'Saving module for offline use - Cache Folder - D:\vmware-powerhshell-offline-cache'
    Save-Module -Name VMware.PowerCLI -Path D:\vmware-powerhshell-offline-cache

    # import the module command line
    write-host -ForegroundColor Green 'Importing Module Vmware.PowerCLI'
    Import-Module VMware.PowerCLI
}
else
{

    

}

# Get all vm's with in a cluster
Get-Cluster -Name 'PRD Cluster' | Get-vm
# get All Host within a cluster 
Get-Cluster -Name 'PRD Cluster' | Get-vmhost

Get-Cluster | % { Get-VMHost }
Get-Cluster -name 'CCC Mt Waverly' | % { Get-VMHost }




# VMWARE-POWERSHELL-CLI-Manager
# Auther: Garvey Snow
# Company: CalvaryCare NDC
# Version: 1.0a
# --------------------------------------------------------
# VM ENV
# --------------------------------------------------------
# Find VMHost Count number of VM's And Memory 
#------------------
# VARS Pulled
#------------------
# Stats to Retrieve
# Name
# ConnectionState           
# PowerState
# NumCpu
# CpuUsageMhz
# CpuTotalMhz
# MemoryUsageGB
# MemoryTotalGB
# Version
# Model
# IsStandalone

write-host -ForegroundColor Cyan "Listing Hosts and VMS for [CLUSTER]: CCC Mt Waverly"
$CLUST_Get_CCC_Mt_Waverly = Get-Cluster -name 'CCC Mt Waverly' |  Get-VMHost FL *

$CLUST_Get_CCC_Mt_Waverly | % { 

    


}

#---------------------
# Clean-up
#---------------------
# Remove Datastore
Set-Location c:
Remove-PSDrive -Name 'VMWARE-DS-MAN' -Verbose



# Datastores Bronze
'V7K_Bronze_Storage_1 - No VMs Current Mounted on this DS'
'V7K_Bronze_Storage_2 - 4 VMs Mounted on DS' 
'V7K_Bronze_Storage_3 - no vms currently mounted'
'V7K_Bronze_Storage_4 - 4 vms mounted' 
'V7K_Bronze_Storage_5 - 1 vms mounted'
'V7K_Bronze_Storage_6 - 4 vms mounted'
'V7K_Bronze_Storage_7 - no'
'V7K_Bronze_Storage_8 - no'
'V7K_Bronze_Storage_9 - 2 vms'
'V7K_Bronze_Storage_10 - 3 vms ' 
'-------------------------------'
'TOTAL'
'18 vms'
'Naming convention'
'V7K_Bronze_Storage_C1'
'V7K_Bronze_Storage_C2'
'V7K_Bronze_Storage_C3'
'V7K_Bronze_Storage_C4'


# Datastores Silver
'V7K_Silver_Storage_1'
'V7K_Silver_Storage_10'
'V7K_Silver_Storage_3'
'V7K_Silver_Storage_4'
'V7K_Silver_Storage_5'
'V7K_Silver_Storage_7'
'V7K_Silver_Storage_9'
'S2200_Silver_DS1'
'S2200_Silver_DS2'
'S2200_Silver_DS3'
'S2200_Silver_DS4'
'S2200_Silver_ISOs'
'S2200_Silver_SysLogs'

# Move-VM
# https://pubs.vmware.com/vsphere-51/index.jsp?topic=%2Fcom.vmware.powercli.cmdletref.doc%2FMove-VM.html

# Datastores Gold               
'V7K_Gold_Storage_1'   
'V7K_Gold_Storage_10'   
'V7K_Gold_Storage_11'   
'V7K_Gold_Storage_12'   
'V7K_Gold_Storage_13'   
'V7K_Gold_Storage_14'   
'V7K_Gold_Storage_15'   
'V7K_Gold_Storage_2'    
'V7K_Gold_Storage_4'    
'V7K_Gold_Storage_5'    
'V7K_Gold_Storage_6'    
'V7K_Gold_Storage_7'    
'V7K_Gold_Storage_8'    
'V7K_Gold_Storage_9'    
'V7K_Gold_Storage_PVS_1'
'V7K_Gold_Storage_PVS_2'
'S2200_Gold_DS1'



# OBJECT 
$report_container = @()
$report_container_object = New-Object System.Object
# VARS
$datastores_array = @('V7K_Gold_Storage_1','V7K_Gold_Storage_10')
$active_vms_on_datastore = Get-Datastore $storage_name_1 | % { Get-VM -Datastore $_.Name }

foreach($ds in $datastores_array)
{
    Get-ChildItem vmstores:\VPRDVCN01.calvarycare.local@443\NDC\$ds | % { 
        # --------------------------------------------------------------------- #
        # Itterate through registered VM's on datastore registered on vCenter
        # And check against folder names with-in datastore
        # build and object and plush in HASH Table for output/export
        # --------------------------------------------------------------------- #
        foreach($avmods in $active_vms_on_datastore)
        {
                if($avmods.Name -like $_.Name) 
                {
                    # Build object properties
                    # -----------------------
                    # VM Name
                    $report_container_object | Add-Member -type NoteProperty -name 'VMName'  -Value $_.Name
                    # VM Status
                    $report_container_object | Add-Member -type NoteProperty -name 'VMName'  -Value $_.Name
                    # VM Status
                    $report_container_object | Add-Member -type NoteProperty -name 'VMName'  -Value $_.Name
                    # VM Status
                    $report_container_object | Add-Member -type NoteProperty -name 'VMName'  -Value $_.Name
                    # VM Status
                    $report_container_object | Add-Member -type NoteProperty -name 'VMName'  -Value $_.Name                                        
                    
                    write-host 'Found mach'$_.Name
                }
                elseif($avmods.Name -notlike $_.Name)
                {
                    Write-Host -ForegroundColor Red 'Unsure Folder'
                    $_.Name
            
                }
        }

     }
 }

 # Object Example
 # https://technet.microsoft.com/en-us/library/ff730946.aspx?f=255&MSPPError=-2147217396
 # https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/add-member?view=powershell-5.1
 $objProp1 = @()
 $muobj = New-Object System.Object
 $muobj | Add-Member -type NoteProperty -name 'First_name'  -Value 'Myvalue'
 $muobj | Add-Member -Type NoteProperty -name 'First_Name_1' -Value 'Myvalue'
 $objProp1 +=  $muobj
 $objProp1



$report_container_object | Add-Member -type NoteProperty -name 'VMName'  -Value 'Myvalue'
 # ================================================================================




#EG DataStore Object
#---------------------
PSPath            : VMware.VimAutomation.Core\VimDatastore::\VPRDVCN01.calvarycare.local@443\NDC\V7K_Gold_Storage_8\.vSphere-HA
PSParentPath      : VMware.VimAutomation.Core\VimDatastore::\VPRDVCN01.calvarycare.local@443\NDC\V7K_Gold_Storage_8
PSChildName       : .vSphere-HA
PSDrive           : vmstores
PSProvider        : VMware.VimAutomation.Core\VimDatastore
PSIsContainer     : True
DatastoreId       : Datastore-datastore-3256
Datastore         : V7K_Gold_Storage_8
Name              : .vSphere-HA
FolderPath        : [V7K_Gold_Storage_8]
DatastoreFullPath : [V7K_Gold_Storage_8] .vSphere-HA
FullName          : vmstores:\VPRDVCN01.calvarycare.local@443\NDC\V7K_Gold_Storage_8\.vSphere-HA
ItemType          : Folder
LastWriteTime     : 9/13/2016 10:00:57 AM
Uid               : /VIServer=calvarycare\adm_gsnow@vprdvcn01.calvarycare.local:443/Datastore=Datastore-datastore-3256/DatastoreItem=[V7K_Gold_Storage_8] .vSphere-HA/
Client            : VMware.VimAutomation.ViCore.Impl.V1.VimClient

#EG VM Object
#---------------------
PowerState              : PoweredOn
Version                 : v8
Notes                   : 
Guest                   : SecurityScanner:Other 3.x or later Linux (64-bit)
NumCpu                  : 1
CoresPerSocket          : 1
MemoryMB                : 12288
MemoryGB                : 12
VMHostId                : HostSystem-host-3448
VMHost                  : pprdesx03.calvarycare.local
VApp                    : 
FolderId                : Folder-group-v3146
Folder                  : vm
ResourcePoolId          : ResourcePool-resgroup-3402
ResourcePool            : Resources
PersistentId            : 502de947-1d42-0caa-5500-418ce881e404
UsedSpaceGB             : 62.160420971922576427459716797
ProvisionedSpaceGB      : 62.160421445965766906738281250
DatastoreIdList         : {Datastore-datastore-3239, Datastore-datastore-3262}
HARestartPriority       : ClusterRestartPriority
HAIsolationResponse     : AsSpecifiedByCluster
DrsAutomationLevel      : AsSpecifiedByCluster
VMSwapfilePolicy        : Inherit
VMResourceConfiguration : CpuShares:Normal/1000 MemShares:Normal/122880
GuestId                 : debian6_64Guest
Name                    : SecurityScanner
CustomFields            : {}
ExtensionData           : VMware.Vim.VirtualMachine
Id                      : VirtualMachine-vm-3409
Uid                     : /VIServer=calvarycare\adm_gsnow@vprdvcn01.calvarycare.local:443/VirtualMachine=VirtualMachine-vm-3409/
Client                  : VMware.VimAutomation.ViCore.Impl.V1.VimClient



#========================================================
# Using PowerCLI to upgrade a host to ESXi 5.0 Update 1
# 
# Download and install PowerCLI.
# Upload the .zip file to a datastore accessible by the ESXi host by either SCP or the datastore browser.
# Extract the .zip file.
# Go to Start > Programs > VMware and open PowerCLI.
# Connect to the ESXi host you want to update by typing Connect-VIServer <hostname>.
# Place the host in maintenance mode with the command:

# Set-VMHost -state maintenance

# Run the file Install-VMHostPatch -HostPath /locationwhere/zipwas/extracted/metadata.zip.
# Reboot the server.

#========================================================