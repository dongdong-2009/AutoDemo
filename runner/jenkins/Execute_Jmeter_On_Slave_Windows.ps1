param([string]$caseDir , [string]$testcases,$outPutDir)
Write-Host  "Jenkins Start Jmeter Running via Powershell"
#使用jenkins构建参数TestCaseName来指定测试用例名称，log 目录,log名称和report压缩包名称
#$caseDir = $env:TestCaseDir
#$testcases = $env:TestCaseName
#$outPutDir = $env:TestReportDir

#使用MessageBox 窗口提示系统环境检查结果
[System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
if(-not (10 -eq [System.Environment]::OSVersion.Version.Major))
   {   $oReturn=[System.Windows.Forms.MessageBox]::Show("The system that under test is not Windows 10,Are you sure! Select OK,Continue; Select Cancel,Quit","Varify System",[System.Windows.Forms.MessageBoxButtons]::OKCancel)	
    switch ($oReturn){
    "OK" {
	       write-host "Continue,please attention the exception!"
		   } 
	"Cancel" {
		    write-host "Now，Quit!"
		    exit 0
	      } 
        }
    }

#执行Jmeter 脚本将log放在TempReport\下，html报告放在TempReport\HtmlReport
If (-not ((Test-path $outPutDir\TempReport\*.jtl) -or (Test-path $outPutDir\TempReport\JmeterReport\* ) -or (Test-path $outPutDir\TempReport\NmonReport\* )))
    {
    cmd /c jmeter.bat -Jprocess=2 -n -t $caseDir\$testcases.jmx -l $outPutDir\TempReport\$testcases.jtl  -e -o $outPutDir\TempReport\JmeterReport 
    }
Else 
    {Remove-Item  $outPutDir\TempReport\*.jtl -recurse
     Remove-Item  $outPutDir\TempReport\NmonReport\*.nmon -recurse
     Remove-Item  $outPutDir\TempReport\JmeterReport\* -recurse
     cmd /c jmeter.bat -Jprocess=2 -n  -t $caseDir\$testcases.jmx -l $outPutDir\TempReport\$testcases.jtl  -e -o $outPutDir\TempReport\JmeterReport 
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
        {Write-Host "Jmeter Finished"
          }
}while($Process.Length -ne 0)
exit 0