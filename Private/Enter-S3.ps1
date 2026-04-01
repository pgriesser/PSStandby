function Enter-S3 {
    [CmdletBinding(SupportsShouldProcess)]
    Param ()

    if ($PSCmdlet.ShouldProcess("this", "Call rundll32.exe SetSuspendState")) {
        Start-Process -FilePath 'rundll32.exe' -ArgumentList 'powrprof.dll,SetSuspendState 0,1,0' -NoNewWindow -Wait
    }
}
