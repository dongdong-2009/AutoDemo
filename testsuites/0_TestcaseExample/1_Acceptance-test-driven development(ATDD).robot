*** Settings ***
Documentation   Workflow mode

Suite Setup    Check Device Online
Suite Teardown    Close Browser

Test Setup     Set Env
Test Teardown     Clean Env

*** Variables ***
${Device}      dev


*** Test Cases ***
User status is stored in database
    [Tags]    variables    database
    Create Valid User    ${USERNAME}    ${PASSWORD}
    Database Should Contain    ${USERNAME}    ${PASSWORD}    Inactive
    Login    ${USERNAME}    ${PASSWORD}
    Database Should Contain    ${USERNAME}    ${PASSWORD}    Active

*** Keywords ***
Database Should Contain
    [Arguments]    ${username}    ${password}    ${status}
    ${database} =     Get File    ${DATABASE FILE}
    Should Contain    ${database}    ${username}\t${password}\t${status}\n