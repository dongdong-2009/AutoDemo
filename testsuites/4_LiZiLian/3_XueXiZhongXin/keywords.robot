*** Settings ***
Documentation     A resource file with reusable keywords and variables.
...               For xpomg login

Library           SeleniumLibrary    timeout=15.0    implicit_wait=5.0

*** Variables ***

${DELAY}          0.2

*** Keywords ***
Open Browser To Login Page
    [Arguments]    ${Server}    ${Browser}
    Open Browser    ${Server}    ${Browser}
    Maximize Browser Window
    Set Selenium Speed    ${DELAY}

Login Page Should Has Title
    [Arguments]    ${titls}
    Title Should Be    ${titls}

Go To Login Page
    [Arguments]   ${LoginUrl}
    Go To    ${LoginUrl}    
    Wait Until Page Contains Element    css=#weilianhai
    Click Element   css=#weilianhai
    Wait Until Element Is Visible    class="weilianbtn weilianall flag"
    Click Image    xpath=//*[@id="author-password"]/img
    

Input Username
    [Arguments]    ${paths}    ${username}
    Input Text    ${paths}    ${username}

Input Password
    [Arguments]    ${paths}    ${password}
    Input Text    ${paths}    ${password}

Login With SessionID
    [Arguments]    ${SessionId}
    ${newUrl} =    Get Location
    Go To    ${newUrl}?sessionId=${SessionId}

Submit Credentials
    [Arguments]    ${paths}
    Click Button    ${paths}

Welcome Page Should Be Open
    Location Should Be    ${WELCOME URL}
    Title Should Be    Welcome Page
