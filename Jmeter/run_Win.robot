*** Settings ***
Documentation    Jmeter Testsuites
...              Require Jmeter scripts, logfile with format such as jtl,html
...              The Jmeter_HOME has been set as environment variable

Resource          resources.robot
Default Tags      Jmeter

*** Variables ***
${scriptsFile}    Jmeter/JmetterScripts/csdn-cases/build-adv-web-test-csdn.jmx
${resultsFile}    Jmeter/JmetterScripts/csdn-cases/csdn.jtl
${JmeterClient}    127.0.0.1
${baiduScripts}    Jmeter/JmetterScripts/baidu1.jmx
${baiduResults}    Jmeter/JmetterScripts/baidu1.jtl

*** Testcases ***

Execute CSDN Jmeter Test
    Run Specified Scripts And Result Format    ${scriptsFile}    ${resultsFile}

Execute Baidu Jmeter Test
    Run Specified Scripts And Result Format    ${baiduScripts}    ${baiduResults}