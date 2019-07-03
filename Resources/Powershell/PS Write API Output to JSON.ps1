# USER CONFIGURATION
$timestamp = get-date -format "yyyyMMddHHmmss"
$libname = "DBAChecks"
$extension = "json"
$filename = "GET_ContentLibraries_$timestamp.$extension"
$outputroot = "C:\Users\Jesse\Documents\Repo\QSContentlib\Resources\LocalContentLibrary"
$method = "get"
$path = "$outputroot/$filename"

# REQUEST AUTHENTICATION & AUTHORISATION
$xrfkey = "Xrfkey=12345678qwertyui"
$hdrs = @{}
$hdrs.add("X-Qlik-xrfkey", "12345678qwertyui")
$hdrs.Add("X-Qlik-User","UserDirectory=JWIS;UserId=Jesse")
$hdrs.add("Accept", "application/json")
$cert = Get-childitem -Path "Cert:\CurrentUser\My" | where {$_.Subject -like '*QlikClient*'}
$endpoint = "contentlibrary?$xrfkey"
$url = "https://JWIS07QS:4242/qrs/$endpoint"

# GET ENDPOINTS
Write-host "[INFO] Making call with URL $url" -ForegroundColor yellow
$response = Invoke-RestMethod -Uri $url -method $method -headers $hdrs -ContentType 'application/json' -Certificate $cert

# PROCESS RESPONSE

Write-host "[INFO] Writing response to output file $path with timestamp $timestamp" -ForegroundColor cyan
$response | ConvertTo-JSON | Write-Output | OUT-file -filepath $path 
Write-host "[OPERATION COMPLETE]" -ForegroundColor green