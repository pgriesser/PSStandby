# PSStandby

PSStandby is a small PowerShell module that puts Windows into standby.

It supports:
- S0 low-power idle (Modern Standby)
- S3 standby (classic sleep)
- Optional delay before entering standby
- Aborting if input is detected
- Running from session 0 (for example, via Task Scheduler)

## Exported command

- `Enter-Standby`

## Requirements

- Windows PowerShell 5.1 or PowerShell 7+
- Windows system that supports S0ix or S3
- **PsExec must be available in the system-wide `PATH` environment variable when running via Scheduled Task (session 0).**

### Why PsExec is required for scheduled tasks

When `Enter-Standby` runs in session 0, the module uses `psexec` to invoke standby logic in an interactive user session. If `psexec` is not in the machine-level `PATH`, scheduled tasks may fail to enter standby.

## Basic usage

```powershell
Import-Module PSStandby

# Enter standby immediately
Enter-Standby

# Wait 30 seconds, then enter standby
Enter-Standby -DelaySeconds 30

# Enter standby after 30 seconds if no input is detected
Enter-Standby -DelaySeconds 30 -AbortOnInput
```

## Scheduled Task note

If your task runs as `SYSTEM` (or another non-interactive account), confirm `psexec.exe` is discoverable from that context via the system-wide `PATH`.
