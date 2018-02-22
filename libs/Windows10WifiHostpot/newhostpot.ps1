<#
#I new a wifi hostpot on windows system environment via powershell.
#============================================================================
#While config the ICS(internet connection share),I use the *Mike F Robbins* scripts [MrToolkit](http://mikefrobbins.com/2017/10/19/configure-internet-connection-sharing-with-powershell/)
#As take the virtual interface name with variables when start the hostednetwork,so it is more Convenience。
#
#The script only need ssid name and password as variable;besides network adapter interface name or status will be auto probed.
#*Note：*  Do not execute the script via mouse “RIGHT-ClICK”，it may cause exceptions.

# 在系统本地设置 wifi 热点,自动监测本地物理网络的连接状态，设置网络共享。
# 执行时需要输入要设置的SSID名称，密码；当然也要确认好电脑的无线网卡支持设置热点。
# 设置完成后，就可以在手机上搜索连接SSID，无线网络的物理特性依赖于电脑无线网卡的特性。
# 如果出现无法执行脚本，请设置 Set-ExecutionPolicy Unrestricted， 确认 yes
# 或者 powershell.exe -NonInteractive -ExecutionPolicy ByPass "& 'C:\Users\outse\AppData\Local\Temp\temp.ps1'"
# QinXing 2018-01-02 -assecurestring
#>

#Requires -Version 3.0
function Get-MrInternetConnectionSharing {
<#
.SYNOPSIS
    Retrieves the status of Internet connection sharing for the specified network adapter(s).
.DESCRIPTION
    Get-MrInternetConnectionSharing is an advanced function that retrieves the status of Internet connection sharing
    for the specified network adapter(s).
.PARAMETER InternetInterfaceName
    The name of the network adapter(s) to check the Internet connection sharing status for.
.EXAMPLE
    Get-MrInternetConnectionSharing -InternetInterfaceName Ethernet, 'Internal Virtual Switch'
.EXAMPLE
    'Ethernet', 'Internal Virtual Switch' | Get-MrInternetConnectionSharing
.EXAMPLE
    Get-NetAdapter | Get-MrInternetConnectionSharing
.INPUTS
    String
.OUTPUTS
    PSCustomObject
.NOTES
    Author:  Mike F Robbins
    Website: http://mikefrobbins.com
    Twitter: @mikefrobbins
#>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory,
                   ValueFromPipeline,
                   ValueFromPipelineByPropertyName)]
        [Alias('Name')]
        [string[]]$InternetInterfaceName
    )
    BEGIN {
        regsvr32.exe /s hnetcfg.dll
        $netShare = New-Object -ComObject HNetCfg.HNetShare
    }
    PROCESS {
        foreach ($Interface in $InternetInterfaceName){
            $publicConnection = $netShare.EnumEveryConnection |
            Where-Object {
                $netShare.NetConnectionProps.Invoke($_).Name -eq $Interface
            }
            try {
                $Results = $netShare.INetSharingConfigurationForINetConnection.Invoke($publicConnection)
            }
            catch {
                Write-Warning -Message "An unexpected error has occurred for network adapter: '$Interface'"
                Continue
            }
            [pscustomobject]@{
                Name = $Interface
                SharingEnabled = $Results.SharingEnabled
                SharingConnectionType = $Results.SharingConnectionType
                InternetFirewallEnabled = $Results.InternetFirewallEnabled
            }
        }
    }
}

#Requires -Version 3.0 -Modules NetAdapter
function Set-MrInternetConnectionSharing {
<#
.SYNOPSIS
    Configures Internet connection sharing for the specified network adapter(s).
.DESCRIPTION
    Set-MrInternetConnectionSharing is an advanced function that configures Internet connection sharing
    for the specified network adapter(s). The specified network adapter(s) must exist and must be enabled.
    To enable Internet connection sharing, Internet connection sharing cannot already be enabled on any
    network adapters.
.PARAMETER InternetInterfaceName
    The name of the network adapter to enable or disable Internet connection sharing for.
 .PARAMETER LocalInterfaceName
    The name of the network adapter to share the Internet connection with.
 .PARAMETER Enabled
    Boolean value to specify whether to enable or disable Internet connection sharing.
.EXAMPLE
    Set-MrInternetConnectionSharing -InternetInterfaceName Ethernet -LocalInterfaceName 'Internal Virtual Switch' -Enabled $true
.EXAMPLE
    'Ethernet' | Set-MrInternetConnectionSharing -LocalInterfaceName 'Internal Virtual Switch' -Enabled $false
.EXAMPLE
    Get-NetAdapter -Name Ethernet | Set-MrInternetConnectionSharing -LocalInterfaceName 'Internal Virtual Switch' -Enabled $true
.INPUTS
    String
.OUTPUTS
    PSCustomObject
.NOTES
    Author:  Mike F Robbins
    Website: http://mikefrobbins.com
    Twitter: @mikefrobbins
#>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory,
                   ValueFromPipeline,
                   ValueFromPipelineByPropertyName)]
        [ValidateScript({
            If ((Get-NetAdapter -Name $_ -ErrorAction SilentlyContinue -OutVariable INetNIC) -and (($INetNIC).Status -ne 'Disabled' -or ($INetNIC).Status -ne 'Not Present')) {
                $True
            }
            else {
                Throw "$_ is either not a valid network adapter of it's currently disabled."
            }
        })]
        [Alias('Name')]
        [string]$InternetInterfaceName,
        [ValidateScript({
            If ((Get-NetAdapter -Name $_ -ErrorAction SilentlyContinue -OutVariable LocalNIC) -and (($LocalNIC).Status -ne 'Disabled' -or ($INetNIC).Status -ne 'Not Present')) {
                $True
            }
            else {
                Throw "$_ is either not a valid network adapter of it's currently disabled."
            }
        })]
        [string]$LocalInterfaceName,
        [Parameter(Mandatory)]
        [bool]$Enabled
    )
    BEGIN {
        if ((Get-NetAdapter | Get-MrInternetConnectionSharing).SharingEnabled -contains $true -and $Enabled) {
            Write-Warning -Message 'Unable to continue due to Internet connection sharing already being enabled for one or more network adapters.'
            Break
        }
        regsvr32.exe /s hnetcfg.dll
        $netShare = New-Object -ComObject HNetCfg.HNetShare
    }
    PROCESS {
        $publicConnection = $netShare.EnumEveryConnection |
        Where-Object {
            $netShare.NetConnectionProps.Invoke($_).Name -eq $InternetInterfaceName
        }
        $publicConfig = $netShare.INetSharingConfigurationForINetConnection.Invoke($publicConnection)
        if ($PSBoundParameters.LocalInterfaceName) {
            $privateConnection = $netShare.EnumEveryConnection |
            Where-Object {
                $netShare.NetConnectionProps.Invoke($_).Name -eq $LocalInterfaceName
            }
            $privateConfig = $netShare.INetSharingConfigurationForINetConnection.Invoke($privateConnection)
        }
        if ($Enabled) {
            $publicConfig.EnableSharing(0)
            if ($PSBoundParameters.LocalInterfaceName) {
                $privateConfig.EnableSharing(1)
            }
        }
        else {
            $publicConfig.DisableSharing()
            if ($PSBoundParameters.LocalInterfaceName) {
                $privateConfig.DisableSharing()
            }
        }
    }
}

if(Test-Connection -computer www.baidu.com -count 3 -quiet){

    try{
        $stopStatus = netsh wlan stop hostednetwork
        $wlanNIC = netsh wlan show interface
        $wlanName = $wlanNIC[3].split(':')[1]
      }
    Catch{
         write-host "The ethernet cannot be connect, will be exit ! "
         Start-Sleep -s 30
         exit 0
     }
    $ssidName = Read-Host "Please enter your ssid name"
    $ssidPasswd = Read-Host "Please enter your ssid password"
    $EthernetInterfaceName = (Get-NetAdapter -physical | where status -eq 'up' | select name).name
    netsh wlan set hostednetwork mode=allow ssid=$ssidName key=$ssidPasswd keyUsage=persistent
    $oldInterfaces = netsh interface show interface
    netsh wlan start hostednetwork
    $newInterfaces = netsh interface show interface
    $ShareToInterface = ""
    $NInameReg = [regex]"\S+[* ]\d+"
    if($newInterfaces.Length -gt $oldInterfaces.Length){
        foreach ($ni in $newInterfaces){
            if (($ni.Length) -and ($oldInterfaces -notcontains $ni)){
                    $ShareToInterface = $NInameReg.match($ni.Trim())
                    break
                    }
                }
        }
    Write-host "Hostpot Interface："$ShareToInterface
    if($ShareToInterface.Length -ne 0){

        #If old wifi hostpot existed,we will stop and remove the ICS at first
        if((Get-NetAdapter | Get-MrInternetConnectionSharing).SharingEnabled -contains $true -and $Enabled -eq "False"){
           Set-MrInternetConnectionSharing -InternetInterfaceName $EthernetInterfaceName -LocalInterfaceName $ShareToInterface -Enabled $true
            }
        else{
           Set-MrInternetConnectionSharing -InternetInterfaceName $EthernetInterfaceName -LocalInterfaceName $ShareToInterface -Enabled $false
           Set-MrInternetConnectionSharing -InternetInterfaceName $EthernetInterfaceName -LocalInterfaceName $ShareToInterface -Enabled $true
           Write-Warning -Message "ICS reset finished."
           }

        write-host "====================== Hostednetwork Start Successfully ======================"
        netsh wlan show hostednetwork
    }
    else{
        write-Warning -Message "Physical network be exception， please re-run the script !"
        Start-Sleep -s 30
     }
}
