Function New-GraylogStream {
    [cmdletbinding()]
    param(
        [parameter(Mandatory)][pscredential]$Credentials,
        [parameter(Mandatory)][String]$Server,
        [parameter(Mandatory)][String]$JSON
    )
    <#
urn:jsonschema:org:graylog2:rest:resources:streams:requests:CreateStreamRequest {
index_set_id (string, optional),
matching_type (string, optional) = ['AND' or 'OR'],
remove_matches_from_default_stream (boolean, optional),
description (string, optional),
rules (array[CreateStreamRuleRequest], optional),
title (string, optional),
content_pack (string, optional)
}
urn:jsonschema:org:graylog2:rest:resources:streams:rules:requests:CreateStreamRuleRequest {
field (string, optional),
description (string, optional),
type (integer, optional),
inverted (boolean, optional),
value (string, optional)
}

#>
    $Header = @{
        "X-Requested-By" = $Env:COMPUTERNAME
    }
    $URI = [URIBuilder]::New("HTTPS", $Server, 443, "/api/streams/")
    $Out = Invoke-RestMethod -Method "POST" -URI $URI.URI -ContentType "Application/json" -Credential $Credentials -Headers $Header -Body $o
    return $Out
}