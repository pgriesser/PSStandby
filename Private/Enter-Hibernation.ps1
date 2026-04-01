function Enter-Hibernation {
    [CmdletBinding(SupportsShouldProcess)]
    Param ()

    if ($PSCmdlet.ShouldProcess("this", "run shutdown /h command")) {
        shutdown /h
    }
}
