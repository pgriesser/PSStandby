function Enter-S0ix {
    [CmdletBinding(SupportsShouldProcess)]
    Param ()

    if ($PSCmdlet.ShouldProcess("this", "Send SC_MONITORPOWER")) {
        $signature = @'
[DllImport("user32.dll", SetLastError = true)]
public static extern bool SendNotifyMessage(IntPtr hWnd, uint Msg, IntPtr wParam, IntPtr lParam);
'@
        if (-not ([System.Management.Automation.PSTypeName]'Win32SendMessage').Type) {
            Add-Type -MemberDefinition $signature -Name 'Win32SendMessage' -Namespace 'Win32'
        }

        # hWnd = HWND_BROADCAST
        # Msg = WM_SYSCOMMAND, wParam = SC_MONITORPOWER
        # lParam: -1 -> screen on, 1 -> screen standby, 2 -> screen off
        [Win32.Win32SendMessage]::SendNotifyMessage([IntPtr]0xFFFF, 0x0112, [IntPtr]0xF170, [IntPtr]2) | Out-Null
    }
}
