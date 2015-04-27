# ---------------------------------------------------
# Script: C:\Users\stefstr\Documents\GitHub\EvoHome\Get-EvoHomeTemperature.ps1
# Version: 0.1
# Author: Stefan Stranger
# Date: 04/27/2015 09:54:51
# Description: Retrieve Indoor and Outdoor Temperature from Honeywell evohome.
# Comments:
# Changes:  
# Disclaimer: 
# This example is provided “AS IS” with no warranty expressed or implied. Run at your own risk. 
# **Always test in your lab first**  Do this at your own risk!! 
# The author will not be held responsible for any damage you incur when making these changes!
# ---------------------------------------------------

Param
(
    # Evohome username
    [Parameter(Mandatory = $true)]
    $username,

    # Evohome username password
    [Parameter(Mandatory = $true)]
    $password

)


#region variables
$url = 'https://rs.alarmnet.com/TotalConnectComfort/WebAPI/api/Session'
$appid = '91db1612-73fd-4500-91b2-e63b069b185c'
#endregion 

$Body = "'Username':$username,'Password':$password,'ApplicationId':$appid"
$hashtable = @{
    'Username'    = $username
    'Password'    = $password
    'ApplicationId' = $appid
}

$Body = ConvertTo-Json -InputObject $hashtable
$call = Invoke-RestMethod -Uri $url -Method Post -Body $Body -ContentType application/json

#extract sessionid and userid
$userid = $call.userInfo.userID
$sessionid = $call.sessionId


$url2 = "https://rs.alarmnet.com/TotalConnectComfort/WebAPI/api/locations?userId=$userid&allData=True"
$devices = Invoke-RestMethod -Uri $url2 -Method GET -Headers @{
    'sessionid' = $sessionid
} -ContentType application/json

#indoor temperature
"Indoor temperature:`t`t $($devices[0].devices.thermostat.indoorTemperature)"

#Outdoor temperature
"Outdoor temperature:`t $($devices.weather.temperature)"