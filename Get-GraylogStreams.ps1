Function Get-GraylogStreams {
    [cmdletbinding()]
    param(
        [parameter(Mandatory)][pscredential]$Credentials,
        [parameter(Mandatory)][String]$Server,
        [parameter()][String]$StreamID,
        [parameter()][int]$Port,
        [parameter()][switch]$HTTP
    )
    switch ($HTTP) {
        $True { $URI = [URIBuilder]::New("HTTP", $Server, 9000, "/api/streams/") }
        $False { $URI = [URIBuilder]::New("HTTPS", $Server, 443, "/api/streams/") }
    }
    if ($Port) { $URI.Port = $Port }
    if ($StreamID) {
        $URI.Path = ("{0}{1}" -f $URI.Path, $StreamID)
    }
    $Out = Invoke-RestMethod -Method "GET" -URI $URI.URI -ContentType "Application/json" -Credential $Credentials
    if ($StreamID) {
        return $Out
    }
    else {
        return $Out.streams
    }
}
