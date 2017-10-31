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
<<<<<<< 2e7ce99d4d5632429b52dcd0ecba9dcf23682740:Jmeter/resources.robot
${JMETER PATH}      /usr/local/share/jmeter/bin/jmeter.sh
${RESULT PATH}      Jmeter/JmeterScripts/result/jmeter.Log
${JMETER_HOME}      PATH

=======
${RESULT PATH}      ..／output/
${NMON HOME}      root/
>>>>>>> 3e666ae2bf87756a326f7881cb0ca339949ee731:Jmeter/resources_nmon.robot
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
