param([string]$testplan , [string]$caseDir,$include,$exclude,$outPutDir,$process)
Write-Host  "########## Jenkins execute RobotFramework Scripts via Powershell scripts ##########"
#使用jenkins构建参数TestCaseName来指定测试用例名称，log 目录,log名称和report压缩包名称
#$testplan = $env:TestPlanName
#$caseDir = $env:TestCaseDir
#$include = $env:IncludeTid
#$exclude = $env:ExcludeTid
#$outPutDir = $env:TestReportDir
#$process = $env:ProcessesCount

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

#执行Robot 脚本将log放在TempReport\RobotReport下
If (Test-path $outPutDir\TempReport\RobotReport\* )
    {
        Remove-Item  $outPutDir\TempReport\RobotReport\* -recurse
    }

If ($exclude)
    {
        pabot --pabotlibhost 127.0.0.1 --pabotlibport 8271 --processes $process --name $testplan  --include $include  --exclude   $exclude  --outputdir $outPutDir\TempReport\RobotReport  $caseDir
     }
Else
    {
        pabot --pabotlibhost 127.0.0.1 --pabotlibport 8271 --processes $process --name $testplan  --include $include  --outputdir $outPutDir\TempReport\RobotReport  $caseDir
    }


exit 0
