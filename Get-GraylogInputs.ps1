Function Get-GraylogInputs {
    [cmdletbinding()]
    param(
        [parameter(Mandatory)][pscredential]$Credentials,
        [parameter(Mandatory)][String]$Server,
        [parameter()][int]$Port,
        [parameter()][switch]$HTTP
    )
    switch ($HTTP) {
        $True { $URI = [URIBuilder]::New("HTTP", $Server, 9000, "/api/system/inputs") }
        $False { $URI = [URIBuilder]::New("HTTPS", $Server, 443, "/api/system/inputs") }
    }
    if ($Port) { $URI.Port = $Port }
    $Out = Invoke-RestMethod -Method "GET" -URI $URI.URI -ContentType "Application/json" -Credential $Credentials
    return $Out.Inputs
}