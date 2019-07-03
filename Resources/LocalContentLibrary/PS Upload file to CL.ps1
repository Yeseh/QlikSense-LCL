<#
  POWERSHELL CONTENT LIBRARY UPLOADER - README
  
  This script calls the Qlik Sense Engine API to upload files from a local folder to a content library.
  This script is mainly intended to enable the hosting of local JSON, HTML or other REST files on the Qlik Sense server without configuring an additional webserver.
  
  For this script to work, 3 variables need to be defined:
    
    1. $qsServer    -  The computer name or proxy path of your Qlik Sense server 
    2. $inputFolder -  The path to the folder that serves as input for the 
    3. $libname     -  The name of an already existing Qlik Sense content library that serves as the destination.
    
  
    
#>

#  REQUEST CONFIGURATION

## USER CONFIGURATION
$qsServer = "JWIS07QS"                                                                    # Computer name or proxy address of the QS Server
$inputfolder = "C:\Users\Jesse\Documents\Repo\QSContentlib\Resources\LocalContentLibrary" # Local folder path for input
$libname = "DBAChecks"                                                                    # Name of existing QS content library to store output

## AUTHENTICATION & AUTHORISATION
$hdrs = @{}                                                                               # Creation of request headers
$xrfkey = "Xrfkey=12345678qwertyui"                                                       # XrfKey request url parameter
$hdrs.add("X-Qlik-xrfkey", "12345678qwertyui")                                            # XrfKey header


## GETTING AND STORING SESSION COOKIE FOR WINDOWS AUTHENTICATION
$getUrl = "https://$qsServer/qrs/about?$xrfkey"
Invoke-RestMethod -verbose -UseDefaultCredentials -Uri $geturl -Method Get -Headers $hdrs -SessionVariable websession
$cookies = $websession.Cookies.GetCookies($geturl)
$session = New-Object Microsoft.PowerShell.Commands.WebRequestSession
$session.Cookies.Add($cookies);
if($session) {write-host "[INFO] SESSION COOKIE STORED" -foregroundcolor green}              

# EMPTY CONTENT LIBRARY



# UPLOAD FILES FROM INPUT FOLDER TO CONTENTLIBRARY
Get-ChildItem $inputfolder | where {$_.extension -eq ".json"} | 
Foreach-Object {
    $content = $_.basename + $_.Extension
    $url = "https://$qsServer/qrs/contentlibrary/$libname/uploadfile?externalpath=$content&overwrite=true&$xrfkey"
    if($content -and $url) {write-host "[INFO] URL CREATED FOR FILE $CONTENT" -ForegroundColor Green }
    else {write-host "[ERROR] COULD NOT CREATE URL OR CONTENT" -foregroundcolor red}         
    $response = Invoke-RestMethod -verbose -Uri $url -method post -headers $hdrs -Infile $content -ContentType  'application/json' -UseDefaultCredentials -websession $session #-Certificate $cert
}

