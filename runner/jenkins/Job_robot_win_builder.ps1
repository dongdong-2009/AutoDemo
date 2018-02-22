#该脚本为jnekins 构建脚本的备份：在 windows 环境下执行 robot 测试脚本 
#使用 jenkins 构建参数 TestCaseName 来指定测试用例名称，log 目录,log名称和report压缩包名称
$workspace = $env:workspace.Trim()
$testplan = $env:TestPlanName
$caseDir = $env:TestCaseDir
$include = $env:IncludeTid
$exclude = $env:ExcludeTid
$outPutDir = $env:TestReportDir
$process = $env:ProcessesCount
$FtpHost = $env:FtpServerHost
$FtpUser = $env:FtpUserName
$FtpPWD = $env:FtpUserPasswd
$RemotePath = $env:FtpServerReportDir

#Execute the robot scripts
C:\2_EclipseWorkspace\xtcAuto\runner\jenkins\Run_Robot_On_Slave_Windows10.ps1 $testplan $caseDir $include $exclude  $outPutDir $process
#Execute python scripts for zip logs and put reports
python $workspace\runner\jenkins\Package_RobotReport_On_Slave_Windows10.py  $outPutDir $testplan $FtpHost $FtpUser $FtpPWD $RemotePath 