function Enter-Standby {
    <#
    .SYNOPSIS
    Enters standby (S0 low-power idle or S3) after an optional delay.

    .DESCRIPTION
    Initiates the system to enter the system's supported standby state.
    If running in session 0 (system session), the command uses PsExec to
    trigger standby in an appropriate context.
    Supports a configurable delay before entering standby.

    .PARAMETER DelaySeconds
    Delay in seconds before entering standby. Default is 0 (immediate).
    Must be between 0 and 3600 (1 hour).

    .PARAMETER AbortOnInput
    If specified, the standby operation will be aborted if user input is
    detected during the delay period.
    Only applicable when used together with (non-zero) DelaySeconds.

    .PARAMETER Hibernate
    If specified, the system will hibernate instead of entering standby.

    .OUTPUTS
    $true if standby was successfully initiated
    $false if input was detected

    .EXAMPLE
    Enter-Standby

    Enters standby immediately.

    .EXAMPLE
    Enter-Standby -DelaySeconds 30

    Waits 30 seconds, then enters standby.

    .EXAMPLE
    Enter-Standby -DelaySeconds 30 -AbortOnInput

    If no user input (e.g. mouse movement or keyboard input) is detected
    for the next 30 seconds, enters standby.

    .EXAMPLE
    Enter-Standby -Hibernate

    Hibernates the system instead of entering standby.
    Can also be combined with the delay and abort options.
    #>
    [CmdletBinding(SupportsShouldProcess)]
    Param(
        [Parameter()]
        [ValidateRange(0, 3600)]
        [int]$DelaySeconds = 0,

        [Parameter()]
        [switch]$AbortOnInput,

        [Parameter()]
        [switch]$Hibernate
    )

    # Check if we're in Session 0
    $currentSessionId = [System.Diagnostics.Process]::GetCurrentProcess().SessionId
    
    if ($currentSessionId -eq 0) {
        if ($DelaySeconds -gt 0) {
            if ($AbortOnInput) {
                $uninterrupted = Invoke-FromInteractiveSession -ScriptPath $script:InterruptibleSleepPSScriptPath -CommandParameters "-Seconds $DelaySeconds"

                if (-not $uninterrupted) {
                    return $false
                }
            }
            else {
                Start-Sleep -Seconds $DelaySeconds
            }
        }

        if ($Hibernate) {
            Enter-Hibernation
        }
        elseif ((Get-PowerCapabilities).AoAc) {
            Invoke-FromInteractiveSession -ScriptPath $script:ModernStandbyPSScriptPath
        }
        else {
            Enter-S3
        }

        return $true
    }
    else {
        if (-not $PSBoundParameters.ContainsKey("DelaySeconds")) {
            $DelaySeconds = 1
        }

        if ($DelaySeconds -gt 0) {
            if ($AbortOnInput) {
                $uninterrupted = Start-InterruptibleSleep -Seconds $DelaySeconds

                if (-not $uninterrupted) {
                    $PSCmdlet.ShouldProcess("this", "Operation aborted due to user input") | Out-Null

                    return $false
                }
            }
            else {
                Start-Sleep -Seconds $DelaySeconds
            }
        }

        if ($Hibernate) {
            Enter-Hibernation
        }
        elseif ((Get-PowerCapabilities).AoAc) {
            Enter-S0ix
        }
        else {
            Enter-S3
        }

        return $true
    }
}
