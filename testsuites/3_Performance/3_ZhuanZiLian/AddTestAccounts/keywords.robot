*** Settings ***
Documentation     A resource file with reusable keywords and variables.
...               For xpomg login

Library           SeleniumLibrary    timeout=15.0    implicit_wait=5.0
Library           Dialogs

*** Variables ***

${DELAY}          0

*** Keywords ***
Open Browser To Login Page
    [Arguments]    ${Server}    ${LoginUrl}    ${Browser}
    Open Browser    ${Server}    ${Browser}
    Maximize Browser Window
    Set Selenium Speed    ${DELAY}
    Go To Login Page    ${LoginUrl}

Login Page Should Has Title
    [Arguments]    ${titls}
    Title Should Be    ${titls}

Go To Login Page
    [Arguments]   ${LoginUrl}
    Go To    ${LoginUrl}    

Input Username
    [Arguments]    ${paths}    ${username}
    Input Text    ${paths}    ${username}

Input Password
    [Arguments]    ${paths}    ${password}
    Input Text    ${paths}    ${password}

Submit By Clict Element
    [Arguments]    ${paths}
    Click Element    ${paths}

Open Windows By Click Element
    [Arguments]    ${paths}    
    Wait Until Page Contains Element    ${paths}
    Click Element    ${paths}

Open Windows By Click Link
    [Arguments]    ${paths}    
    Wait Until Page Contains Element    ${paths}
    Click Link    ${paths}

Submit Credentials
    [Arguments]    ${paths}
    Click Button    ${paths}
    


Welcome Page Should Be Open
    Location Should Be    ${WELCOME URL}
    Title Should Be    Welcome Page
