*** Settings ***
Documentation    Common resources for jmeter performance test suites
...              First we use the robotframework-jmeter library
...              Then we install the Jmeter client on the DUT system or some host to connect the system under test
...              We should be know that jmeter libary only wrap the CLI commands, the jtl or html format resoult and script must
...              be set before the execute the robot testsuites!

Library          Process
Library          Collections
Library          OperatingSystem

*** Variables ***
${RESULT PATH}      ..／output/
${JMETER HOME}      jmeter/bin

*** Keywords ***
Check Test Environment Be Ready
    [Arguments]    ${Testsuite Path}    ${Testcase Name}    ${RESULT PATH}
    File Should Exist     ${Testsuite Path}/${Testcase Name}.jmx    
    ${status}    ${runInfo} =    Run Keyword And Ignore Error    Directory Should Be Empty    ${RESULT PATH}/Temporary
    Run Keyword If    '${status}' != 'PASS'      Remove Files    ${RESULT PATH}/Temporary/*.jtl
    ${status}    ${runInfo} =    Run Keyword And Ignore Error    Directory Should Be Empty    ${RESULT PATH}Temporary/HtmlReport
    Run Keyword If    '${status}' != 'PASS'      Remove Files    ${RESULT PATH}/Temporary/HtmlReport/*
    ${env_vars} =    Get Environment Variable    ${JMETER_HOME}
    Should Not Be Empty    ${env_vars}
    
Run Jmeter Stand Alone On Windows
    [Arguments]    ${Testsuite Path}    ${Testcase Name}    ${Log Name}
    #Check Testscripts And Environment OK    ${scriptFile}    ${resultFile}
    $jmeterCmds} =    ${JMETER PATH}   ${Testsuite Path}${/}${Testcase Name}  -l ${Log Name}.jtl -e -o 
    ${rc}    ${stdout} =     Run And Return Rc   ${JMETER PATH}   ${Testsuite Path}${/}${Testcase Name}  -l ${RESULT PATH}/Temporary/${Log Name}.jtl -e -o ${RESULT PATH}Temporary/HtmlReport
    Should Be Equal As Integers 	  ${rc} 	  0
    #Wait Until Keyword Succeeds    10    2s    File Should Exist    ${resultFile}


Run Jmeter Stand Alone On Linux
    
    
Run Jmeter Distributed On Windows


Run Jmeter Distributed On Linux

Run Jmeter Server On Windows
    [Arguments]    ${Node Host}    ${Option}   


Check Jmeter Node Online On Windows
    [Arguments]    ${Node List}    

   
Run Jmeter Server On Linux
    [Arguments]    ${Node Host}    ${Option}   


Check Jmeter Node Online On Linux
    [Arguments]    ${Node List}   
    
