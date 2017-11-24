#使用MessageBox 窗口提示系统环境检查结果
[System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")

if(-not (10 -eq [System.Environment]::OSVersion.Version.Major))
  {   $oReturn=[System.Windows.Forms.MessageBox]::Show("检测到操作系统不是 Windows 10,请确认！选择OK,将继续执行；选择Cancel将会退出","操作系统检查",[System.Windows.Forms.MessageBoxButtons]::OKCancel)	
    switch ($oReturn){
    "OK" {
	       write-host "将继续执行，请注意异常！"
		   } 
	"Cancel" {
		    write-host "现在，将不再往下执行脚本 !"
		    exit 0
	      } 
     }
}


#确认Jmeter 执行完毕
$ProcessName = "jmeter.bat"
do{
    #$Process = (Get-Process -Name $ProcessName -ErrorAction SilentlyContinue)
    $Process = (Get-WmiObject Win32_Process | Select ProcessID, ParentProcessID,CSName,CommandLine |  FT -Auto | findstr $ProcessName)

     If (($Process.Length -ne 0) -and ($Process.Contains($ProcessName))) {
	     Write-Host $ProcessName" is Running..." 
         start-sleep -s 2
	     #$Process.Kill()
         }
    Else
        {Write-Host "Jmeter 执行结束"
          }
}while($Process.Length -ne 0)
exit 0