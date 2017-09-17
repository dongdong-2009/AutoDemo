*** Settings ***
Documentation    Jmeter Testsuites
...              Require Jmeter scripts, logfile with format such as jtl,html
...              The Jmeter_HOME has been set as environment variable

Resource          resources.robot
Default Tags      Jmeter

*** Variables ***
${scriptsFile}    C:/Users/Administrator/Documents/Jmetter-Scripts/csdn-cases/build-adv-web-test-csdn.jmx
${resultsFile}    C:/Users/Administrator/Documents/Jmetter-Scripts/csdn-cases/csdn.jtl
${JmeterClient}    127.0.0.1
${baiduScripts}    C:/Users/Administrator/Documents/Jmetter-Scripts/baidu1.jmx
${baiduResults}    C:/Users/Administrator/Documents/Jmetter-Scripts/baidu1.jtl

*** Testcases ***

Execute CSDN Jmeter Test
    Run Specified Scripts And Result Format    ${scriptsFile}    ${resultsFile}

Execute Baidu Jmeter Test
    Run Specified Scripts And Result Format    ${baiduScripts}    ${baiduResults}