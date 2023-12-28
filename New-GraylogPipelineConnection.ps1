Function New-GraylogPipelineConnection {
    [cmdletbinding()]
    param(
        [parameter(Mandatory)][pscredential]$Credentials,
        [parameter(Mandatory)][String]$Server,
        [parameter(Mandatory)][String]$JSON
    )
    <#
urn:jsonschema:org:graylog:plugins:pipelineprocessor:rest:PipelineReverseConnections {
stream_ids (array[string], optional),
pipeline_id (string, optional)
}
#>
    $Header = @{
        "X-Requested-By" = $Env:COMPUTERNAME
    }
    $URI = [URIBuilder]::New("HTTPS", $Server, 443, "/api/system/pipelines/connections/to_pipeline")
    $Out = Invoke-RestMethod -Method "POST" -URI $URI.URI -ContentType "Application/json" -Credential $Credentials -Headers $Header -Body $JSON
    return $Out
}