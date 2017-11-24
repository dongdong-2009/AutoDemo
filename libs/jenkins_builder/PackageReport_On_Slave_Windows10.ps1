Write-Host "开始清理环境和打包测试报告"
#定义临时log 目录,定义case目录,testcses 名称或标记
$outPutDir = $env:TestReportDir
$testcases = $env:TestCaseName

#创建report，log目录
$nowTime = Get-Date -Format 'dHms'
$newDir = $testcases+$nowTime
New-Item C:\2_EclipseWorkspace\xtcAuto\Output\$newDir -type directory

#执行完成之后，将jmeter 的log 文件*.jtl,nmon的监控记录和html report 移动到创建的目录中
Get-Item $outPutDir\TempReport\*.jtl | Move-Item -Destination $outPutDir\$newDir
Get-Item $outPutDir\TempReport\nmon\*.nmon | Move-Item -Destination $outPutDir\$newDir
Get-Item $outPutDir\TempReport\HtmlReport\* | Move-Item -Destination $outPutDir\$newDir
#确TempReport\目录为空，便于下次执行
Remove-Item  $outPutDir\TempReport\*.jtl -recurse
Remove-Item  $outPutDir\TempReport\nmon\*.nmon -recurse
Remove-Item  $outPutDir\TempReport\HtmlReport\* -recurse
#使用7z 将创建目录下的log，html报告压缩为5mb的包
cmd /c  7z.exe a -oC:\2_EclipseWorkspace\xtcAuto\Output\$newDir.zip -tzip -y  C:\2_EclipseWorkspace\xtcAuto\Output\$newDir