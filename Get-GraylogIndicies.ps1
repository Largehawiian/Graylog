Function Get-GraylogIndicies {
    [cmdletbinding()]
    param(
        [parameter(Mandatory)][pscredential]$Credentials,
        [parameter(Mandatory)][String]$Server,
        [parameter()][int]$Port,
        [parameter()][switch]$HTTP
    )
    switch ($HTTP) {
        $True { $URI = [URIBuilder]::New("HTTP", $Server, 9000, "/api/system/indices/index_sets") }
        $False { $URI = [URIBuilder]::New("HTTPS", $Server, 443, "/api/system/indices/index_sets") }
    }
    if ($Port) { $URI.Port = $Port }
    $URI.Query = "skip=0&limit=0&stats=false"
    $Out = Invoke-RestMethod -Method "GET" -URI $URI.URI -ContentType "Application/json" -Credential $Credentials
    return $Out.index_sets
}
