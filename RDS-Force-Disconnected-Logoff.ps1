$connectionbroker="rdconnectionbroker.domain.com"

$rdSessions=Get-RDUserSession -ConnectionBroker $connectionBroker

 $rdSessions|foreach{
 $userName=$_.username
 $appType=$_.applicationtype
 $hostServer=$_.hostserver
 $domain=$_.domainname
 $activeServer=$_.servername
 $sessionID=$_.sessionID
 $unifiedSession=$_.unifiedSessionId
 $createTime=$_.createTime
 $disconnectTime=$_.disconnectTime
 $sessionState=$_.sessionState
 $collectionName=$_.collectionName

 if ($appType -eq 'rdpinit.exe' -and $activeServer -notlike 'VDI*') {
   $appType='RemoteApp'
 } elseif ($activeServer -notlike '*VDI*') {
   $appType='Remote Desktop'
 } else {
  $appType='VDI'
 }

 
 $objSession=[pscustomobject]@{
  userName=$userName
  domain=$domain
  userType=$appType
  hostServer=$hostServer
  activeServer=$activeServer  #This should be the connection broker for RemoteApps and RDP Sessions
  collectionName=$collectionName
  sessionID=$sessionID
  unifiedSessionID=$unifiedSession
  connectTime=$createTime
  disconnectTime=$disconnectTime
  sessionState=$sessionState
 }
 
 if ($objSession.Sessionstate -eq "STATE_DISCONNECTED") {
  write-hot "Logging $($objSession.UserName) off of $($objSession.hostServer)..."
  Invoke-RDUserLogoff -HostServer $objSession.hostServer -UnifiedSessionId $objession.unifiedSessionID -Force
 }

}
