<#
.DESCRIPTION

Date        Updated By  Details
08/23/2021      BW      Initial Creation.  Stores Credential in a file, along with a key file of 32 bytes.

#>
Param(
    #This is the file where the credential will be saved
    [Parameter(Mandatory = $true)] [string] $credFile,
    [Parameter(Mandatory = $false)] [string] $keyFile="$credFile.key",
    [Parameter(Mandatory = $false)] [switch] $readCreds
)

if ($readCreds -eq $false) {
    #Create a 32Byte key
    $keyData=New-Object Byte[] 32

    [Security.Cryptography.RNGCryptoServiceProvider]::Create().GetBytes($keyData)

    set-content -path $keyFile $keyData

    $stCred=Get-Credential

    $myPassSecure=$stCred.password

    $myPass=$myPassSecure | convertfrom-securestring -key $keyData


    set-content $credFile $stCred.UserName
    add-content $credFile $myPass

    write-host "Credential Stored in $credFile"
    write-host "Key Stored in $keyFile"
}

if ($readCreds -eq $true) {

    $keyData = get-content $keyFile
    
    $credData=get-content $credFile

    $username=$credData[0]
    $password = $credData[1] | convertto-securestring -key $keyData

    $objCred=new-object System.Management.automation.pscredential -ArgumentList $username,$password

    write-host "Credential Info:"

    $objCred.UserName
    $objCred.GetnetworkCredential().Password


}
