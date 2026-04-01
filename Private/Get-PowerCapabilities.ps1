# Source - https://stackoverflow.com/a/75087675
# Posted by JonathonFS
# Retrieved 2026-03-30, License - CC BY-SA 4.0

Function Get-PowerCapabilities
{
    Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;
using System.Diagnostics;

public static class PowerCfg
{
    [DllImport("PowrProf.dll")]
    public static extern bool GetPwrCapabilities(out SYSTEM_POWER_CAPABILITIES lpSystemPowerCapabilities);

    public static SYSTEM_POWER_CAPABILITIES GetCapabilities()
    {
        SYSTEM_POWER_CAPABILITIES spc;
        bool well = GetPwrCapabilities(out spc);
        return spc;
    }

    // https://github.com/MicrosoftDocs/sdk-api/blob/docs/sdk-api-src/content/winnt/ns-winnt-system_power_capabilities.md
    // https://www.pinvoke.net/default.aspx/Structures/SYSTEM_POWER_CAPABILITIES.html
    [Serializable]
    public struct SYSTEM_POWER_CAPABILITIES
    {
        [MarshalAs(UnmanagedType.I1)]
        public bool PowerButtonPresent;   //If this member is TRUE, there is a system power button.
        [MarshalAs(UnmanagedType.I1)]
        public bool SleepButtonPresent;   //If this member is TRUE, there is a system sleep button.
        [MarshalAs(UnmanagedType.I1)]
        public bool LidPresent;           //If this member is TRUE, there is a lid switch.
        [MarshalAs(UnmanagedType.I1)]
        public bool SystemS1;             //If this member is TRUE, the operating system supports sleep state S1.
        [MarshalAs(UnmanagedType.I1)]
        public bool SystemS2;             //If this member is TRUE, the operating system supports sleep state S2.
        [MarshalAs(UnmanagedType.I1)]
        public bool SystemS3;             //If this member is TRUE, the operating system supports sleep state S3.
        [MarshalAs(UnmanagedType.I1)]
        public bool SystemS4;             //If this member is TRUE, the operating system supports sleep state S4 (hibernation).
        [MarshalAs(UnmanagedType.I1)]
        public bool SystemS5;             //If this member is TRUE, the operating system supports power off state S5 (soft off).
        [MarshalAs(UnmanagedType.I1)]
        public bool HiberFilePresent;     //If this member is TRUE, the system hibernation file is present.
        [MarshalAs(UnmanagedType.I1)]
        public bool FullWake;             //If this member is TRUE, the system supports wake capabilities.
        [MarshalAs(UnmanagedType.I1)]
        public bool VideoDimPresent;      //If this member is TRUE, the system supports video display dimming capabilities.
        [MarshalAs(UnmanagedType.I1)]
        public bool ApmPresent;           //If this member is TRUE, the system supports APM BIOS power management features.
        [MarshalAs(UnmanagedType.I1)]
        public bool UpsPresent;           //If this member is TRUE, there is an uninterruptible power supply (UPS).
        [MarshalAs(UnmanagedType.I1)]
        public bool ThermalControl;       //If this member is TRUE, the system supports thermal zones.
        [MarshalAs(UnmanagedType.I1)]
        public bool ProcessorThrottle;    //If this member is TRUE, the system supports processor throttling.
        public byte ProcessorMinThrottle; //The minimum level of system processor throttling supported, expressed as a percentage.
        public byte ProcessorMaxThrottle; //The maximum level of system processor throttling supported, expressed as a percentage. Also known as ProcessorThrottleScale before Windows XP
        [MarshalAs(UnmanagedType.I1)]
        public bool FastSystemS4;         //If this member is TRUE, the system supports the hybrid sleep state.
        [MarshalAs(UnmanagedType.I1)]
        public bool Hiberboot;            //If this member is set to TRUE, the system is currently capable of performing a fast startup transition. This setting is based on whether the machine is capable of hibernate, whether the machine currently has hibernate enabled (hiberfile exists), and the local and group policy settings for using hibernate (including the Hibernate option in the Power control panel).
        [MarshalAs(UnmanagedType.I1)]
        public bool WakeAlarmPresent;     //If this member is TRUE, the platform has support for ACPI wake alarm devices.
        [MarshalAs(UnmanagedType.I1)]
        public bool AoAc;                 //If this member is TRUE, the system supports the S0 low power idle model.
        [MarshalAs(UnmanagedType.ByValArray, SizeConst = 3)]
        public byte[] spare2;             //Unknown
        [MarshalAs(UnmanagedType.I1)]
        public bool DiskSpinDown;         //If this member is TRUE, the system supports allowing the removal of power to fixed disk devices.
        public byte HiberFileType;        //Unknown
        [MarshalAs(UnmanagedType.I1)]
        public bool AoAcConnectivitySupported;           //Unknown
        [MarshalAs(UnmanagedType.ByValArray, SizeConst = 8)]
        public byte[] spare3;                            //Reserved
        [MarshalAs(UnmanagedType.I1)]
        public bool SystemBatteriesPresent;              //If this member is TRUE, there are one or more batteries in the system.
        [MarshalAs(UnmanagedType.I1)]
        public bool BatteriesAreShortTerm;               //If this member is TRUE, the system batteries are short-term. Short-term batteries are used in uninterruptible power supplies (UPS).
        [MarshalAs(UnmanagedType.ByValArray, SizeConst = 3)]
        public BATTERY_REPORTING_SCALE[] BatteryScale;   //A BATTERY_REPORTING_SCALE structure that contains information about how system battery metrics are reported.
        public SYSTEM_POWER_STATE AcOnLineWake;          //The lowest system sleep state (Sx) that will generate a wake event when the system is on AC power.
        public SYSTEM_POWER_STATE SoftLidWake;           //The lowest system sleep state (Sx) that will generate a wake event via the lid switch.
        public SYSTEM_POWER_STATE RtcWake;               //The lowest system sleep state (Sx) supported by hardware that will generate a wake event via the Real Time Clock (RTC).
        public SYSTEM_POWER_STATE MinDeviceWakeState;    //The minimum allowable system power state supporting wake events. Note that this state may change as different device drivers are installed on the system.
        public SYSTEM_POWER_STATE DefaultLowLatencyWake; //The default system power state used if an application calls RequestWakeupLatency with LT_LOWEST_LATENCY.
    }

    // https://github.com/MicrosoftDocs/sdk-api/blob/docs/sdk-api-src/content/winnt/ns-winnt-battery_reporting_scale.md
    public struct BATTERY_REPORTING_SCALE
    {
        public UInt32 Granularity;
        public UInt32 Capacity;
    }

    // https://learn.microsoft.com/en-us/windows/win32/api/winnt/ne-winnt-system_power_state
    public enum SYSTEM_POWER_STATE
    {
        PowerSystemUnspecified = 0, //Unspecified system power state.
        PowerSystemWorking = 1,     //Specifies system power state S0.
        PowerSystemSleeping1 = 2,   //Specifies system power state S1.
        PowerSystemSleeping2 = 3,   //Specifies system power state S2.
        PowerSystemSleeping3 = 4,   //Specifies system power state S3.
        PowerSystemHibernate = 5,   //Specifies system power state S4 (HIBERNATE).
        PowerSystemShutdown = 6,    //Specifies system power state S5 (OFF).
        PowerSystemMaximum = 7      //Specifies the maximum enumeration value.
    }
}
"@
    [PowerCfg]::GetCapabilities()
}
