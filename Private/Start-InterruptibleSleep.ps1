function Start-InterruptibleSleep {
    [CmdletBinding()]
    Param(
        [int]$Seconds
    )

    $deadline = (Get-Date).AddSeconds($Seconds)
    $PollMs = (($Seconds * 100), 3000 | Measure-Object -Minimum).Minimum
    Start-Sleep -Milliseconds (100)

    while ((Get-Date) -lt $deadline) {
        Start-Sleep -Milliseconds $PollMs

        if ((Get-UserIdleMilliseconds) -lt $PollMs) {
            return $false
        }
    }

    return $true
}

function Get-UserIdleMilliseconds {
    if (-not ("Win32.UserInputNative" -as [type])) {
        Add-Type -TypeDefinition @"
using System.Runtime.InteropServices;

namespace Win32 {
    public static class UserInputNative {
        [StructLayout(LayoutKind.Sequential)]
        public struct LASTINPUTINFO {
            public uint cbSize;
            public uint dwTime;
        }

        [DllImport("user32.dll")]
        public static extern bool GetLastInputInfo(ref LASTINPUTINFO plii);
    }
}
"@
    }

    $lii = New-Object Win32.UserInputNative+LASTINPUTINFO
    $lii.cbSize = [Runtime.InteropServices.Marshal]::SizeOf($lii)
    $ok = [Win32.UserInputNative]::GetLastInputInfo([ref]$lii)
    if (-not $ok) {
        throw "GetLastInputInfo failed."
    }

    $now = [uint32][Environment]::TickCount
    $last = [uint32]$lii.dwTime
    return [long]([uint32]($now - $last))
}
