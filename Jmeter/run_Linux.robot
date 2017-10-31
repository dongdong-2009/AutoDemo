*** Settings ***
Documentation    Jmeter Testsuites
...              Require Jmeter scripts, logfile with format such as jtl,html
...              The Jmeter_HOME has been set as environment variable

Resource          resources.robot
Default Tags      Jmeter

*** Variables ***
<<<<<<< 2e7ce99d4d5632429b52dcd0ecba9dcf23682740:Jmeter/csdn.robot
${scriptsFile}    Jmeter/JmeterScripts/csdn-cases/build-adv-web-test-csdn.jmx
${resultsFile}    Jmeter/JmeterScripts/csdn-cases/csdn.jtl
${JmeterClient}    127.0.0.1
${baiduScripts}    Jmeter/JmeterScripts/baidu1.jmx
${baiduResults}    Jmeter/JmeterScripts/baidu1.jtl
=======
${scriptsFile}    Jmeter/JmetterScripts/csdn-cases/build-adv-web-test-csdn.jmx
${resultsFile}    Jmeter/JmetterScripts/csdn-cases/csdn.jtl
${JmeterClient}    127.0.0.1
${baiduScripts}    Jmeter/JmetterScripts/baidu1.jmx
${baiduResults}    Jmeter/JmetterScripts/baidu1.jtl
>>>>>>> 3e666ae2bf87756a326f7881cb0ca339949ee731:Jmeter/jmeter_run_Linux.robot

*** Testcases ***

Execute CSDN Jmeter Test
    Run Specified Scripts And Result Format    ${scriptsFile}    ${resultsFile}

Execute Baidu Jmeter Test
    Run Specified Scripts And Result Format    ${baiduScripts}    ${baiduResults}
