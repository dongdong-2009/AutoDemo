*** Settings ***
Documentation    Common resources for linux performance test suites
...              First we use the nmon collect the linux info for CPU,MEM,NETWORK,IO...


Library          Process
Library          Collections
Library          OperatingSystem

*** Variables ***
${RESULT PATH}      ..／output/
${NMON HOME}      root/
 
*** Keywords ***
   ${Testsuite Path}    ${Testcase Name}
Check Test Environment Be Ready
    [Arguments]    ${Testsuite Path}    ${Testcase Name}    ${RESULT PATH}
    File Should Exist     ${Testsuite Path}/${Testcase Name}.jmx    
    ${status}    ${runInfo} =    Run Keyword And Ignore Error    Directory Should Be Empty    ${RESULT PATH}/Temporary
    Run Keyword If    '${status}' != 'PASS'      Remove Files    ${RESULT PATH}/Temporary/*.jtl
    ${status}    ${runInfo} =    Run Keyword And Ignore Error    Directory Should Be Empty    ${RESULT PATH}Temporary/HtmlReport
    Run Keyword If    '${status}' != 'PASS'      Remove Files    ${RESULT PATH}/Temporary/HtmlReport/*
    ${env_vars} =    Get Environment Variable    ${JMETER_HOME}
    Should Not Be Empty    ${env_vars}

Run Specified Scripts And Result Format
    [Arguments]    ${Testsuite Path}    ${Testcase Name}    ${Log Name}
    #Check Testscripts And Environment OK    ${scriptFile}    ${resultFile}
    run jmeter    ${JMETER PATH}   ${scriptFile}    ${resultFile}
    Wait Until Keyword Succeeds    10    2s    File Should Exist    ${resultFile}
    #${html} =    Analyse Jtl Convert To Html    ${resultFile}
    #${dbs} =    Analyse Jtl Convert To Db    ${resultFile}
    #Log Many    ${html}    ${dbs}
    
Check Testcases FilePath
