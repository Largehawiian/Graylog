Function New-GraylogGROK {
    [cmdletbinding()]
    param(
        [parameter(Mandatory)][pscredential]$Credentials,
        [parameter(Mandatory)][String]$Server,
        [parameter(Mandatory)][String]$JSON,
        [parameter()][int]$Port,
        [parameter()][switch]$HTTP
    )
    switch ($HTTP) {
        $True { $URI = [URIBuilder]::New("HTTP", $Server, 9000, "/api/system/grok") }
        $False { $URI = [URIBuilder]::New("HTTPS", $Server, 443, "/api/system/grok") }
    }
    if ($Port) { $URI.Port = $Port }
    <#
urn:jsonschema:org:graylog2:grok:GrokPattern {
name (string, Mandatory),
pattern (string, Mandatory),
id (string, optional),
content_pack (string, optional)
}
#>
    $Header = @{
        "X-Requested-By" = $Env:COMPUTERNAME
    }
    $Out = Invoke-RestMethod -Method "POST" -URI $URI.URI -ContentType "application/json" -Credential $Credentials -Headers $Header -Body $JSON
    return $Out
}