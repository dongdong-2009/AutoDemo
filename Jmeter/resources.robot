*** Settings ***
Documentation    Common resources for jmeter performance test suites
...              First we use the robotframework-jmeter library
...              Then we install the Jmeter client on the DUT system or some host to connect the system under test
...              We should be know that jmeter libary only wrap the CLI commands, the jtl or html format resoult and script must
...              be set before the execute the robot testsuites!

Library          JMeterLib
Library          Collections
Library          OperatingSystem

*** Variables ***
${JMETER PATH}      /usr/local/share/jmeter/bin/jmeter.sh
${RESULT PATH}      ../Jmeter/Jmetter-Scripts/result/jmeter.Log
${JMETER_HOME}      PATH

*** Keywords ***

Check Testscripts And Environment OK
    [Arguments]    ${scriptFile}    ${resultFile}
    File Should Exist     ${scriptFile}
    ${status}    ${runInfo} =    Run Keyword And Ignore Error    File Should Not Exist    ${resultFile}
    Run Keyword If    '${status}' != 'PASS'      Remove File    ${resultFile}
    ${env_vars} =    Get Environment Variable    ${JMETER_HOME}
    Should Contain    ${env_vars}    jmeter

Run Specified Scripts And Result Format
    [Arguments]    ${scriptFile}    ${resultFile}
    Check Testscripts And Environment OK    ${scriptFile}    ${resultFile}
    run jmeter    ${JMETER PATH}   ${scriptFile}    ${resultFile}
    Wait Until Keyword Succeeds    10    2s    File Should Exist    ${resultFile}
    #${html} =    Analyse Jtl Convert To Html    ${resultFile}
    #${dbs} =    Analyse Jtl Convert To Db    ${resultFile}
    #Log Many    ${html}    ${dbs}
