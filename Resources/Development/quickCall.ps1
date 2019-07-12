## USER CONFIGURATION
$qsServer = "JWIS07QS"                                                                    # Computer name or proxy address of the QS Server
$inputfolder = "C:\Users\Jesse\Documents\Repo\QSContentlib\Resources\LocalContentLibrary" # Local folder path for input
$libname = "DBAChecks"                                                                    # Name of existing QS content library to store output

## AUTHENTICATION & AUTHORISATION
$hdrs = @{}                                                                               # Creation of request headers hashtable
$xrfkey = "Xrfkey=12345678qwertyui"                                                       # XrfKey request url parameter
$hdrs.add("X-Qlik-xrfkey", "12345678qwertyui")                                            # XrfKey header
$hdrs.add("Accept", "application/json")

## GETTING AND STORING SESSION COOKIE FOR POST/DELETE REQUESTS USING WINDOWS AUTHENTICATION
$getUrl = "https://jwis07qs/content/DBAChecks/GET_ContentLibraries_20190704131111.json?xrfkey=12345678qwertyui"
Invoke-RestMethod -verbose -UseDefaultCredentials -Uri $geturl -ContentType "application/json" -Method Get -Headers $hdrs -OutFile "C:/users/jesse/desktop/test.json" -PassThru


<#
$cookies = $websession.Cookies.GetCookies($geturl)
$session = New-Object Microsoft.PowerShell.Commands.WebRequestSession
$session.Cookies.Add($cookies);
if($session) {write-host "[INFO] SESSION COOKIE STORED" -foregroundcolor green}
#>