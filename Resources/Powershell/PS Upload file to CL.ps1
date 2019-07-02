# USER CONFIGURATION
$libname = "DBAChecks"
$outputroot = "C:\Users\Jesse\Documents\Repo\QSContentlib\Resources\LocalContentLibrary"
$method = "POST"

# REQUEST AUTHENTICATION & AUTHORISATION
$xrfkey = "Xrfkey=12345678qwertyui"
$hdrs = @{}
$hdrs.add("X-Qlik-xrfkey", "12345678qwertyui")
$hdrs.Add("X-Qlik-User","UserDirectory=JWIS;UserId=Jesse")
$hdrs.add("Accept", "application/json")
$cert = Get-childitem -Path "Cert:\CurrentUser\My" | where {$_.Subject -like '*QlikClient*'}

$url = "https://JWIS07QS:4242/qrs/$endpoint"

Get-ChildItem $outputroot -recurse | where {$_.extension -eq ".json"} | 
Foreach-Object {
    $content = $_.basename + $_.Extension
    write-host $content -ForegroundColor yellow
    $url = "https://JWIS07QS:4242/qrs/contentlibrary/$libname/uploadfile?externalpath=$content&$xrfkey"
    write-host $url -ForegroundColor yellow
    $response = Invoke-RestMethod -Uri $url -method $method -headers $hdrs -ContentType 'application/json' -Certificate $cert -verbose
}

