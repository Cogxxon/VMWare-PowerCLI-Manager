function vmwarecli
{
<#=============================================================================#>

<# 
 NAME: VMWareCLI Version 0.1b
 ------------------------------------
 DESCRIPTION : Script to Automate Migration, Upgrades & Patches through VMWare 
               Update Manager Reports On Environment 
               /\ Cluster /\ Single Hosts /\ vCenter Wide /\
 SOURCES For SCRIPT
 ------------------------------------
#>

<#
.SYNOPSIS  
		Synopsis goes here
.DESCRIPTION  
		Description goes here
.LINK  
    http://link.com
                
.NOTES  
#>

<#=============================================================================#>

param( 
             [switch][parameter(ValueFromPipeline=$true)]$reportOnly,
             [switch][parameter(ValueFromPipeline=$true)]$connectVI,
             [switch][parameter(ValueFromPipeline=$true)]$disconnectVI,
             [switch][parameter(ValueFromPipeline=$true)]$linked,
             [switch][parameter(ValueFromPipeline=$true)]$viewInstances,
             [switch][parameter(ValueFromPipeline=$true)]$prepareCluster,
             [switch][parameter(ValueFromPipeline=$true)]$upgradeCluster,
             [switch][parameter(ValueFromPipeline=$true)]$findSuitableHost
)

#################-INITIALIZE OBJECTS-############################\
# ---------------------------------------------------------------\  
if($global:config)
{
    Write-Host -ForegroundColor Yellow 'skipping object creation'
}
else
{
    $global:config = New-Object -TypeName psobject;
    $global:config | Add-Member -MemberType NoteProperty -Name running_mode -Value '';
    $global:config | Add-Member -MemberType NoteProperty -Name baseline_name -Value '';
    $global:config | Add-Member -MemberType NoteProperty -Name vmhost_cluster_name -Value ''; 
    $global:config | Add-Member -MemberType NoteProperty -Name module_cache -Value '';
    $global:config | Add-Member -MemberType NoteProperty -Name network_UNC_scriptpath -Value '';
    $Global:config | Add-Member -MemberType NoteProperty -Name vcenter_Servers -Value '';
    $global:config | Add-Member -MemberType NoteProperty -Name psdrive_name -Value '';
    $global:config | Add-Member -MemberType NoteProperty -Name data_center -Value '';
    $global:config | Add-Member -MemberType NoteProperty -Name datastore_array -Value '';
    $global:config | Add-Member -MemberType NoteProperty -Name target_vcenter_server -Value '';
    $global:config | Add-Member -MemberType NoteProperty -Name target_vcenter_server_creds -Value '';
    $global:config | Add-Member -MemberType NoteProperty -Name psdrive_name_friendly_name -Value '';
    $global:config | Add-Member -MemberType NoteProperty -Name libs -Value '';
    $global:config | Add-Member -MemberType NoteProperty -Name esxi_upgrade_version -Value ''
    $global:config | Add-Member -MemberType NoteProperty -Name esxi_upgraded_version -Value ''
    

}
# ---------------------------------------------------------------/ 
################################################################/

##################-RUNNING MODE-################################\
# ---------------------------------------------------------\  
$global:config.running_mode = 'live';
$global:config.esxi_upgrade_version ='5.1.0'
# ---------------------------------------------------------/ 
##### two Modes 'test' & 'live'
################################################################/

##################-Update Manager baseline Name-############################\
# ----------------------------------------------------------------------------\  
$global:config.baseline_name = 'Baseline esxi 5.1.0'; 
### You can find this by running the command:
### C:#> Get-Baseline | select name,TargetType,BaselineType,LastUpdateTime
### Or by login into vcenter desktop or web client and find the update manager
### may need to activate the plugin before you see this in the environtment
### once available you should be able to find the base line record name/groups
# ----------------------------------------------------------------------------/ 
############################################################################/     

        $global:config | Add-Member -MemberType NoteProperty -Name prepared_status -Value '';  
        ##################-PREPERATION STATUS-######################################\
        # ----------------------------------------------------------------------------\
        # < partially > < prepared > < unprepared >
        #### This property holds the settings for prepared status for a host/cluster
        #### a host/cluster cannot migrate or update if this status is not set to prepared
        #### The switch -prepareCluster & -prepareHost must be ran before 
        #### any migration of update occur.
        #### ----------------------
        #### SWITCHES THAT USE THIS
        #### ----------------------
        #### -updateCluster
        #### -updateHosts
        #### -updatehost
        # ----------------------------------------------------------------------------/
        ############################################################################/


##################-cluster name to update-##########################\
# -------------------------------------------------------------------\                                   
$global:config.vmhost_cluster_name = 'dev-cluster-1';
# -------------------------------------------------------------------/
####################################################################/

##################-Global Error action setting-##################################\
# --------------------------------------------------------------------------------\ 
$ErrorActionPreference= 'silentlycontinue';
# --------------------------------------------------------------------------------/
### GLOBAL Preference Silence errors for most functions, allowing the allocation
### of a error varilable -errorVariable $variablename
#################################################################################/

#***************************************************************************
# - Path to which the script Caches the VMWare.PowerCLI Module for later use
$global:config.module_cache = 'D:\vmware-powerhshell-offline-cache';

#***************************************************************************
# - The LOCAL/UNC path of the script file
$global:config.network_UNC_scriptpath = '\\vprddfs01.calvarycare.local\NDC\Home\Garvey.Snow\VMWare-PowerCLI-Manager';

#***************************************************************************
$Global:config.vcenter_Servers = @('ndc-vcen-tm2.calvarycare.local'); # EXAMPLE : $vCenter_Servers = @('Server1',"Server2","Server3")
# - List of vCenter's Not if more than one is provided
#   The Script Will Attched to connect in LINKED mode
#   vCenter Must be configured as a Child Node or maste
#***************************************************************************

$global:config.psdrive_name = 'VMWARE-DS-MAN';
$global:config.psdrive_name_friendly_name = $global:config.psdrive_name + ':\';
$global:config.libs = $global:config.psdrive_name_friendly_name + 'libs'; $global:lib_path = $global:config.libs

#***************************************************************************
######### TARGET vCenter Server ############

$Global:config.target_vcenter_server = '';
$Global:config.target_vcenter_server_creds = '';

#######

#######################################################
# - if the datastore_array is empty [Get-datastore] will pull all vCenter wide
# - if the datastore_datacenter string is left blank, script will pull all datastore containers vCenter Wide

$global:config.datastore_array = @()
$global:config.data_center = 'NDC'

######################################################


#$global:config.creds = Get-Credential -Message 'Please enter account with sufficiant access.' -UserName 'calvarycare\'
    
    
# MAP Working folder
# -----------------
# ? Known Issue ?
# https://stackoverflow.com/questions/26994265/new-psdrive-inside-a-module-doesnt-work
Write-host -ForegroundColor Cyan "Checking for PS-Drive " -NoNewline; write-host -ForegroundColor Green $global:config.psdrive_name
if( Test-Path $global:config.psdrive_name_friendly_name )
{ 
    Write-Host -ForegroundColor Cyan ("PS-Drive Matching", "-[ ",$global:config.psdrive_name, " ]-") -NoNewline; write-host -ForegroundColor Green 'Found'
    Remove-PSDrive -Name $global:config.psdrive_name -Confirm:$false -Verbose
    New-PSDrive -Name $global:config.psdrive_name -PSProvider FileSystem -Root $global:config.network_UNC_scriptpath -Verbose -Scope Global | FT -AutoSize
}
else
{
    Write-host -ForegroundColor Cyan "Mapping PS-Drive NTFS DS Location:: " -NoNewline; write-host -ForegroundColor Green $global:config.network_UNC_scriptpath
    New-PSDrive -Name $global:config.psdrive_name -PSProvider FileSystem -Root $global:config.network_UNC_scriptpath -Verbose -Scope Global | FT -AutoSize
}

# DEPENDANCIES & LIB
#-------------------
Write-Host -ForegroundColor yellow '-------------------------------- Importing Dependancies --------------------------------'

. $global:lib_path'\write-segline.ps1'
WRITE-SEGLINE -action -firstline 'Importing' -secondline '\libs\write-segline.ps1' -numlines 2 -color yellow

WRITE-SEGLINE -action -firstline 'Importing' -secondline '\libs\prepareCluster.ps1' -numlines 2 -color yellow
. $global:lib_path'\prepareCluster.ps1'

WRITE-SEGLINE -action -firstline 'Importing' -secondline '\libs\storageReport.ps1' -numlines 2 -color yellow
. $global:lib_path'\storageReport.ps1'

WRITE-SEGLINE -action -firstline 'Importing' -secondline '\libs\connectvi.ps1' -numlines 2 -color yellow
. $global:lib_path'\connectvi.ps1'

WRITE-SEGLINE -action -firstline 'Importing' -secondline '\libs\upgradeCluster.ps1' -numlines 2 -color yellow
. $global:lib_path'\upgradeCluster.ps1'

WRITE-SEGLINE -action -firstline 'Importing' -secondline '\libs\retrieveSuitableHost.ps1' -numlines 2 -color yellow
. $global:lib_path'\retrieveSuitableHost.ps1'

Write-Host -ForegroundColor yellow '-----------------------------------------------------------------------------------------'
Write-Host ''
Write-Host ''
Write-Host ''
Write-Host -ForegroundColor cyan '-------------------------------------- Global Config --------------------------------------'
$global:config | FL *
Write-Host -ForegroundColor cyan '-------------------------------------------------------------------------------------------'
#==================================================================================================================================================
#                                                                        FUNCTIONS
#==================================================================================================================================================


#*******************************************************#
#-------------------------------------------------------#
#  CONNECTVI - Connect to a vCenter server instance     #
#-------------------------------------------------------#
#*******************************************************#
if($connectVI -eq $true)
{
    connectvi;
}
#*******************************************************#
#-------------------------------------------------------#
#  disconnectVI - Kill a Server connection Instance     #
#-------------------------------------------------------#
#*******************************************************#
if($disconnectVI -eq $true)
{
    WRITE-SEGLINE -action -firstline 'Listing Connected vCenter Servers' -secondline 'VMware.PowerCLI Suspending script' -numlines 2 -color yellow 
    
    Write-Host '--------------------'
    $global:defaultVIServers | FT  -AutoSize
    Write-Host '--------------------'
    
    Disconnect-VIServer * -Confirm:$false -Verbose -ErrorAction SilentlyContinue
}
#*******************************************************#
#-------------------------------------------------------#
#  viewInstances - View Connect vServer instance        #
#-------------------------------------------------------#
#*******************************************************#
if($viewInstances -eq $true)
{
    WRITE-SEGLINE -action -firstline 'Finding Active Instances ' -numlines 1
    $global:defaultVIServers | FT  -AutoSize
}
#*******************************************************#
#-------------------------------------------------------#
#  prepareCluster - Prepare a Cluster for migration     #
#-------------------------------------------------------#
#*******************************************************#
if($prepareCluster -eq $true)
{
   # Located in */libs/
   prepareCluster;
}

#*******************************************************#
#-------------------------------------------------------#
#  findSuitableHost - Used in update host, allows
#                         the script to find the host in
#                         the cluster with the most free 
#                         memory and migrate vim's to it
#                         before migration and placement
#                         of host to be updated into
#                         Maintenace Mode for host
#                         update.  
#-------------------------------------------------------#
#*******************************************************#
if($findSuitableHost -eq $true)
{
    # Located in */libs/
    retrieveSuitableHost;
}


#*******************************************************#
#-------------------------------------------------------#
#  Upgrade Cluster                                      #
#-------------------------------------------------------#
#*******************************************************#
if($upgradeCluster -eq $true)
{
   # Located in */libs/upgradeCluster.ps1
   upgradeCluster;
}

} # END FUNCTION #



# Initialize Module on load
# vmarecli

