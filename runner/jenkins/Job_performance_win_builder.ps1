#在 windows 环境下执行 jmeter 测试脚本 
#使用 jenkins 构建参数 TestCaseName 来指定测试用例名称，log 目录,log名称和report压缩包名称
$workspace = $env:workspace.Trim()
$caseDir = $env:TestCaseDir
$testcases = $env:TestCaseName
$outPutDir = $env:TestReportDir
$serverList = $env:ServerList
$FtpServerList = $env:FtpServerList
$RemotePath = $env:FtpServerReportDir

write-host "=================== Start Nmon ===================" 
python $workspace\runner\jenkins\Start_Nmon_On_Centos.py   $serverList   $FtpServerList
write-host "=================== Start Jmeter ==================="
C:\2_EclipseWorkspace\xtcAuto\runner\jenkins\Execute_Jmeter_On_Slave_Windows.ps1   $caseDir  $testcases  $outPutDir
write-host "=================== Stop Nmon ==================="
python $workspace\runner\jenkins\Stop_Nmon_On_Centos.py  $serverList  $outPutDir

write-host "=================== Zip Logs And Put Reports ==================="
python $workspace\runner\jenkins\Package_PerformanceReport_On_Slave_Windows.py  $outPutDir  $testcases   $RemotePath  $FtpServerList