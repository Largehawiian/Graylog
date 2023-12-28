$PSScript = $PSScriptRoot
$PublicFunc = @(Get-ChildItem -Exclude "UI.ps1" -Recurse -Path $PSScript\*.ps1 -ErrorAction SilentlyContinue)
Foreach ($Import in $PublicFunc) {
    try {
        . $import.fullname
    }
    catch {
        Write-Error -Message "Failled to import function $($import.fullname): $_"
    }
}
$Script:InputTypes = [hashtable]@{
    SyslogUDP        = "org.graylog2.inputs.syslog.udp.SyslogUDPInput"
    SyslogTCP        = "org.graylog2.inputs.syslog.tcp.SyslogTCPInput"
    Beats            = "org.graylog.plugins.beats.Beats2Input"
    HTTPMonitorInput = "org.graylog2.plugin.httpmonitor.HttpMonitorInput"
}
Export-ModuleMember -Function $PublicFunc.BaseName