<#
.SYNOPSIS
    Creates a new Graylog Input
.DESCRIPTION
    Creates a new Graylog Input using provided parameters using JSON either created manually or from New-GraylogInputConfiguration
.NOTES
    Mandatory values in this function are Credentials, Server and JSON
    If no port is specified HTTPS (default) will default to 443 and -HTTP will default to 9000
    Has been tested on Graylog 4.x and 5.x
    Inputs will be created, but not started. You must manually start the input in the web UI.

    constructor structure from Graylog's api browser

    urn:jsonschema:org:graylog2:rest:models:system:inputs:requests:InputCreateRequest {
    node (string, optional),
    configuration (object, optional),
    global (boolean, optional),
    title (string, Mandatory),
    type (string, Mandatory)
    }
.LINK

.EXAMPLE
    New-GraylogInput -Credentials (Get-Credential) -Server 192.168.1.100 -JSON $MyCustomJSON
    New-GraylogInputConfiguration -ExpandStructuredData $false -ReceiveBufferSize 262144 -Port 514 -NumberWorkerThreads 16 -CharSet UTF-8 -ForceRDNS $false -AllowOverrideDate $true -BindAddress 0.0.0.0 -StoreFullMessage $true -Global $false -Title "Test" -Type SyslogTCP | New-GraylogInput -Credentials (Get-Credential) -Server 192.168.1.100 -HTTP

#>
Function New-GraylogInput {
    [cmdletbinding()]
    param(
        [parameter(Mandatory)][pscredential]$Credentials,
        [parameter(Mandatory)][String]$Server,
        [parameter(Mandatory, ValueFromPipeline)][String]$JSON,
        [parameter()][int]$Port,
        [parameter()][switch]$HTTP
    )
    process {
        switch ($HTTP) {
            $True { $URI = [URIBuilder]::New("HTTP", $Server, 9000, "/api/system/inputs") }
            $False { $URI = [URIBuilder]::New("HTTPS", $Server, 443, "/api/system/inputs") }
        }
        if ($Port) { $URI.Port = $Port }
        $Header = @{
            "X-Requested-By" = $Env:COMPUTERNAME
        }
        Invoke-RestMethod -Method "POST" -URI $URI.URI -ContentType "Application/json" -Credential $Credentials -Body $JSON -Headers $Header
    }
}