
<#
.SYNOPSIS
  This folder will add AD User/group permissions to a folder tree where the folder names are the same as the AD Group names
.DESCRIPTION
   Date UpdatedBy Details
   08/10/2017 BW  Initial coding.

 .EXAMPLES
 Consider a folder structure
 C:\DeptShares\
               Accounting
               Business
               IT
               Auditors

Running this script on a computer connected to the CONTOSO Domain would grant full control to the user or groups as follows:
    CONTOSO\Accounting would get full control on C:\DeptShares\Accounting
    CONTOSO\Businesss would get full control on C:\DeptShares\Business
    CONTOSO\IT would get full control on C:\DeptShares\IT
    CONTOSO\Auditors would get full control on C:\DeptShares\Auditors

#>


$domain="YOUR_AD_DOMAIN"
$PrimaryPath="C:\test"
$folders=dir -directory $PrimaryPath


foreach ($folder in $folders) {
 write-host -foregroundcolor yellow "Getting ACL for $($folder.fullname)"
 #write-host $folder.name
 $ACL=get-acl -Path $folder.fullname

 $ADGroup="$domain\$($folder.name)"
 $permission="$ADGroup",'FullControl','ContainerInherit, ObjectInherit', 'None', 'Allow'
 $rule=new-object -typename System.Security.AccessControl.FileSystemAccessrule -ArgumentList $permission
 
 $acl.SetaccessRule($rule)

 write-host "AD Group is $ADGroup"
 write-host "Setting Folder ACL for $($folder.Name)"

 $acl.setAccessRuleProtection($false,$false)
 $acl|set-acl -Path $folder.fullname

 #To run more thaan just one folder, comment out the exit 0 line below.
 exit 0

}
