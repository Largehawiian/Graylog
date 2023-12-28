Function Get-GraylogPipelines {
    [cmdletbinding()]
    param(
        [parameter(Mandatory)][pscredential]$Credentials,
        [parameter(Mandatory)][String]$Server,
        [parameter()][String]$PipelineID,
        [parameter()][int]$Port,
        [parameter()][switch]$HTTP
    )
    switch ($HTTP) {
        $True { $URI = [URIBuilder]::New("HTTP", $Server, 9000, "/api/system/pipelines/pipeline") }
        $False { $URI = [URIBuilder]::New("HTTPS", $Server, 443, "/api/system/pipelines/pipeline") }
    }
    if ($Port) { $URI.Port = $Port }
    if ($PipelineID) {
        $URI.Path = ("{0}/{1}" -f $URI.Path, $PipelineID)
    }
    $Out = Invoke-RestMethod -Method "GET" -URI $URI.URI -ContentType "Application/json" -Credential $Credentials
    return $Out
}