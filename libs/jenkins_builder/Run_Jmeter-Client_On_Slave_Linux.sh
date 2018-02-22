#!/bin/bash
#在Linux 环境下执行jmeter 

caseDir=${env.TestCaseDir}
testcases=${env.TestCaseName}
outPutDir=${env.TestReportDir}
serverList=${env.JmeterServerList}

OPTIONS=    #Jmeter server other options.

pwd

echo "Jmeter start"

./jmeter.sh -n -t $caseDir/$testcases.jmx -l $outPutDir/TempReport/$testcases.jtl  -e -o $outPutDir/TempReport/JmeterReport  -R $serverList -X

# If you want quit the jmeter-server ,please set JMeter property server.exitaftertest=true
#otherwise ，when start jmeter client add the '-X' options 
