<#
.SYNOPSIS
  File / Folder Auditing script to determine which users have permissions that are *NOT* inherited.

.DESCRIPTION
   Date UpdatedBy Details
   08/10/2017 BW  Initial coding.
#>

$path="C:\Program Files"
$outFile="myFolderInheritance.csv"

$nonInherited=new-object System.Collections.ArrayList

$folders=dir $path -Directory -recurse|get-acl|
select @{Label='Path';Expression={$_.PSPath.replace("Microsoft.PowerShell.Core\FileSystem::","")}},
@{Label='User';Expression={$_.Access.identityReference}},
@{Label='IsInherited';Expression={$_.Access.IsInherited}}|
where {$_.IsInherited -eq $false}

foreach ($item in $folders) {
 $pass=0
 write-host "Checking folder $($item.path)"
 foreach ($user in $item.user) {
  #$x=$nonInherited "$($item.Path), $($user),$($item.IsInherited[$pass])"
  $x=$noninherited.add("$($item.Path), $($user),$($item.IsInherited[$pass])")
  $pass=$pass++
 }
}

$nonInherited|out-file -FilePath $outFile


write-host "Done."

