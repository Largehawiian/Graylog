Function New-GraylogPipelineRule {
    [cmdletbinding()]
    param(
        [parameter(Mandatory)][pscredential]$Credentials,
        [parameter(Mandatory)][String]$Server,
        [parameter(Mandatory)][String]$JSON
    )
    <#
urn:jsonschema:org:graylog:plugins:pipelineprocessor:rest:RuleSource {
description (string, optional),
created_at (string, optional),
id (string, optional),
source (string, optional),
title (string, optional),
modified_at (string, optional),
errors (array[ParseError], optional)
}
#>  
    $Header = @{
        "X-Requested-By" = $Env:COMPUTERNAME
    }
    $URI = [URIBuilder]::New("HTTPS", $Server, 443, "/api/system/pipelines/rule")
    $Out = Invoke-RestMethod -Method "POST" -URI $URI.URI -ContentType "Application/json" -Credential $Credentials -Headers $Header -Body $o
    return $Out
}