*** Settings ***
Documentation    Jmeter Testsuites
...              Require Jmeter scripts, logfile with format such as jtl,html
...              The Jmeter_HOME has been set as environment variable

Resource          resources.robot
Default Tags      Jmeter    Mac    

*** Variables ***
${JMETER SERVER HOST}    127.0.0.1
${JMETER PATH}     /usr/local/bin/jmeter
${Testsuite Path}     JmeterScripts/
${Testcase Name}    web_basement
${Log Name}    Run_ON_Mac


*** Testcases ***
Execute Jmeter Web Basement Test
    Run Specified Scripts And Result Format    ${JMETER PATH}     ${Testsuite Path}    ${Testcase Name}     ${Log Name} 

Execute Jmeter Web Advance Test
    Run Specified Scripts And Result Format    ${baiduScripts}    ${baiduResults}
    
Execute Jmeter FTP Test   
    
Execute Jmeter JDBC Test
