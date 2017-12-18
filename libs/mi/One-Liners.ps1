#=========
#Exchange
#=========

# https://technet.microsoft.com/en-us/library/bb124403(v=exchg.160).aspx
# ADD SEND-AS Permissions
Get-Mailbox '<name>' | % { Add-ADPermission -Identity $_.Name -ExtendedRights "Send As" -User '<User To Have Access>' -Confirm:$false -Verbose }

# Retrieve Send-As permissions for a particalar user
Get-Mailbox -Identity "<Name>" | Get-ADPermission -User '<User search Access>' | FL *