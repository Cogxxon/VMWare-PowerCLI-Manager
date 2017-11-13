function unRakeClusterSettings()
{
    # Retreive the lastes config file
    # -------------------------------
    $search_var = "*" + $global:config.vmhost_cluster_name + "*"
    $clust_build_latest = (Get-ChildItem -Recurse | ? { $_.name -like " $global:config.vmhost_cluster_name"} | Sort-Object -Property LastWriteTime)[0] | Get-Content | ConvertTo-Json | ConvertFrom-Json
}