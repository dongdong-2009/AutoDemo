#!/bin/bash
#在Linux 环境下执行jmeter 

caseDir=${env.TestCaseDir}
testcases=${env.TestCaseName}
outPutDir=${env.TestReportDir}

#OPTIONS=    #Jmeter server other options.

#python  环境
pip install 

pwd

echo "Jmeter start"

jmeter -n -t $caseDir/$testcases.jmx -l $outPutDir/TempReport/$testcases.jtl  -e -o $outPutDir/TempReport/JmeterReport

# If you want quit the jmeter-server ,please set JMeter property server.exitaftertest=true
# otherwise ，when start jmeter client add the '-X' options 
