Write-Host  "Jenkins 在Windows 环境下使用Powershell构建Jmeter Running"
#使用jenkins构建参数TestCaseName来指定测试用例名称，log 目录,log名称和report压缩包名称
$caseDir = $env:TestCaseDir
$testcases = $env:TestCaseName
$outPutDir = $env:TestReportDir

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

#执行Jmeter 脚本将log放在TempReport\下，html报告放在TempReport\HtmlReport
If (-not ((Test-path $outPutDir\TempReport\*.jtl) -or (Test-path $outPutDir\TempReport\JmeterReport\* ) -or (Test-path $outPutDir\TempReport\NmonReport\* )))
    {
    cmd /c jmeter.bat -n -t $caseDir\$testcases.jmx -l $outPutDir\TempReport\$testcases.jtl  -e -o $outPutDir\TempReport\JmeterReport
    }
Else 
    {Remove-Item  $outPutDir\TempReport\*.jtl -recurse
     Remove-Item  $outPutDir\TempReport\NmonReport\*.nmon -recurse
     Remove-Item  $outPutDir\TempReport\JmeterReport\* -recurse
     cmd /c jmeter.bat -n -t $caseDir\$testcases.jmx -l $outPutDir\TempReport\$testcases.jtl  -e -o $outPutDir\TempReport\JmeterReport
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
