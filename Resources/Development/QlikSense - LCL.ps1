<#
  POWERSHELL CONTENT LIBRARY UPLOADER V1.0 - README
  
  This script calls the Qlik Sense Engine API to upload files from a local folder to a content library.
  This script is mainly intended to enable the hosting of local JSON, HTML or other REST files on the Qlik Sense server without configuring an additional webserver.
  The script first gets API info to establish a user session. Then the existing contentlibrary is emptied and the files in the local storages are reuploaded.

  For this script to work, 3 variables need to be defined:
    
    1. $qsServer    -  The computer name or proxy path of your Qlik Sense server. 
    2. $inputFolder -  The path to the folder that serves as input for the content library.
    3. $libname     -  The name of an already existing Qlik Sense content library that serves as the destination.
     
#>

#  REQUEST CONFIGURATION

## USER CONFIGURATION
$qsServer = "<Servername>"                                                                # Computer name or proxy address of the QS Server
$inputfolder = "<Input path>"                                                             # Local folder path for input
$libname = "<Content library name>"                                                       # Name of existing QS content library to store output

## AUTHENTICATION & AUTHORISATION
$hdrs = @{}                                                                               # Creation of request headers hashtable
$xrfkey = "Xrfkey=12345678qwertyui"                                                       # XrfKey request url parameter
$hdrs.add("X-Qlik-xrfkey", "12345678qwertyui")                                            # XrfKey header
$hdrs.add("Accept", "application/json")

## GETTING AND STORING SESSION COOKIE FOR WINDOWS AUTHENTICATION
$getUrl = "https://$qsServer/qrs/about?$xrfkey"
Invoke-RestMethod -verbose -UseDefaultCredentials -Uri $geturl -Method Get -Headers $hdrs -SessionVariable websession
$cookies = $websession.Cookies.GetCookies($geturl)
$session = New-Object Microsoft.PowerShell.Commands.WebRequestSession
$session.Cookies.Add($cookies);
if($session) {write-host "[INFO] SESSION COOKIE STORED" -foregroundcolor green}          


# BUILD CONTENT LIBRARY

## GET LIST OF CURRENT CONTENT IN LIBRARY
$getUrl = "https://$qsServer/qrs/staticcontent/enumeratefiles?path=/content/$libname&$xrfkey"
$contentEnum = Invoke-RestMethod -verbose -Uri $getUrl -method get -headers $hdrs -ContentType  'application/json' -UseDefaultCredentials -websession $session 
if($contentEnum) {write-host "[INFO] CONTENT FETCHED FOR CONTENTLIBRARY $libname" -ForegroundColor Green }

## EMPTY CONTENT LIBRARY
foreach($i in $contentEnum){
    write-host $i.path -ForegroundColor Yellow
    $deleteContent = [System.io.path]::GetFileName($i.path)
    $deleteUrl = "https://$qsServer/qrs/contentlibrary/$libname/deletecontent?externalpath=$deletecontent&$xrfkey"
    if($deletecontent -and $posturl) {write-host "[INFO] FILE $deleteContent successfully deleted" -ForegroundColor magenta }
    Invoke-RestMethod -verbose -Uri $deleteurl -method delete -headers $hdrs  -ContentType  'application/json' -UseDefaultCredentials -websession $session
}

# UPLOAD FILES FROM INPUT FOLDER TO CONTENTLIBRARY
Get-ChildItem $inputfolder | where {($_.extension -eq ".json") -and !($_.BaseName -eq "content")} | 
Foreach-Object {
    $postContent = $_.basename + $_.Extension
    $postUrl = "https://$qsServer/qrs/contentlibrary/$libname/uploadfile?externalpath=$postContent&overwrite=true&$xrfkey"
    if($postContent -and $postUrl) {write-host "[INFO] URL CREATED FOR FILE $CONTENT" -ForegroundColor Green }
    else {write-host "[ERROR] COULD NOT CREATE URL OR CONTENT" -foregroundcolor red}         
    Invoke-RestMethod -verbose -Uri $postUrl -method post -headers $hdrs -Infile $postcontent -ContentType  'application/json' -UseDefaultCredentials -websession $session
}

