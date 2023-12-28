<#
.SYNOPSIS
    Generates a JSON object for use with New-GraylogInput
.DESCRIPTION
    Generates a JSON object for use with New-GraylogInput
.NOTES
    Types enabled in this function at time of publishing are SyslogUDP, SyslogTCP, Beats and HTTPMonitorInput. These can be adjusted by modifying
    the ValidateSet in the function param block and by updating the hashtable in Graylog.psm1 with the java class name.
.LINK

.EXAMPLE
    New-GraylogInputConfiguration -ExpandStructuredData $false -ReceiveBufferSize 262144 -Port 514 -NumberWorkerThreads 16 -CharSet UTF-8 -ForceRDNS $false -AllowOverrideDate $true -BindAddress 0.0.0.0 -StoreFullMessage $true -Global $false -Title "Test" -Type SyslogTCP
#>
Function New-GraylogInputConfiguration {
    [cmdletbinding()]
    param(
        [parameter()][String]$Node,
        [parameter()][bool]$Global,
        [parameter(Mandatory)][String]$Title,
        [parameter(Mandatory)]
        [ValidateSet("SyslogUDP", "SyslogTCP", "Beats", "HTTPMonitorInput")]
        [String]$Type,
        [parameter()][bool]$ExpandStructuredData,
        [parameter()][int]$ReceiveBufferSize,
        [parameter()][int]$Port,
        [parameter()][int]$NumberWorkerThreads,
        [parameter()][String]$TimeZone,
        [parameter()][bool]$OverrideSource,
        [parameter()][String]$CharSet,
        [parameter()][bool]$ForceRDNS,
        [parameter()][bool]$AllowOverrideDate,
        [parameter()][String]$BindAddress,
        [parameter()][bool]$StoreFullMessage
    )
    $LookupType = $Script:InputTypes[$Type]
    $Obj = [PSCustomObject]@{
        node          = $Node
        configuration = @{
            "expand_structured_data" = $ExpandStructuredData
            "recv_buffer_size"       = $ReceiveBufferSize
            port                     = $Port
            "number_worker_threads"  = $NumberWorkerThreads
            timezone                 = $TimeZone
            override_source          = $OverrideSource
            charset_name             = $CharSet
            "force_rdns"             = $ForceRDNS
            "allow_override_date"    = $AllowOverrideDate
            "bind_address"           = $BindAddress
            "store_full_message"     = $StoreFullMessage
        }
        global        = $Global
        title         = $Title
        type          = $LookupType
    }
    $Obj | ConvertTo-Json
}