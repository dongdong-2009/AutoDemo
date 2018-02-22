*** Settings ***
Documentation     A test suite for valid login.
...
...               This test has a workflow that is created using keywords in
...               the imported resource file.

Force Tags      tid-3-5-2     owner-QinXing
Library           keywordsPy.py
Library           Dialogs
Resource          keywords.robot

*** Variable ***
${Browser}        chrome
${AddUser}     xpath=//*[contains(concat(' ', @href, ' '), ' edit.ht ')]  
${ServerHost}    http://172.19.6.103/weining0.5/login.html

*** Test Cases ***
Add Test Users
    ${QiYeGuanLi} =    QiYeGuanLi Login
    Open QuanXian GuanLi
    Open Browser    http://172.19.6.103/weining0.5/login.html    ${Browser}    weiningtong
    Maximize Browser Window
    Set Selenium Speed    0     
    :For     ${index}    IN Range    0    619
    \    ${inx} =    Get Index Real Data    ${index} 
    \    ${NewUser} =    Check Account    testing    6000    ${inx}  
    \    ${status} =    ReLogin WeiNingTong    ${NewUser}
    \    Run Keyword IF    '${status}' != 'PASS'     Pause Execution    ${NewUser['account']} Login Fail !
    \    Run Keyword And Ignore Error    Click Element     xpath=//*[@id="indexout"]    
    \    Sleep    2
    
   [Teardown]    Close All Browsers

*** Keywords ***
ReLogin WeiNingTong
    [Arguments]     ${NewUser}	
    Wait Until Element Is Visible        xpath=//*[@id="account"]
    Input Text         xpath=//*[@id="account"]     ${NewUser['account']}
    Input Text         xpath=//*[@id="password"]    123456
    Click Button     xpath=//*[@id="btn"]
    ${status}    ${errinfo} =    Run Keyword And Ignore Error    Wait Until Page Contains       威宁通

    [Return]    ${status}



QiYeGuanLi Login
    Open Browser    http://172.19.6.103:81    ${Browser}     QiYeGuanLi
    Maximize Browser Window
    Set Selenium Speed    0
    Input Text         xpath=//*[@id="companyName"]/input     platform_admin
    Input Text         xpath=//*[@id="app"]/div/div[2]/div/form/div[2]/div/div/input    123456
    Submit By Clict Element     xpath=//*[@id="app"]/div/div[2]/div/form/div[3]/button
    [Return]    QiYeGuanLi

Open QuanXian GuanLi
    Wait Until Page Contains       权限管理
    Wait Until Element Is Visible    xpath=//*[@id="app"]/div/div[1]/div[2]/ul/li[4]/div/i[2]
    Click Element     xpath=//*[@id="app"]/div/div[1]/div[2]/ul/li[4]/div/i[2]    

    Wait Until Page Contains       角色类型控制
    Wait Until Element Is Visible    xpath=//*[@id="app"]/div/div[1]/div[2]/ul/li[4]/ul/li[4]/div/i
    Click Element     xpath=//*[@id="app"]/div/div[1]/div[2]/ul/li[4]/ul/li[4]/div/i
    
    Mouse Over    xpath=//*[@id="app"]/div/div[1]/div[2]/ul/li[4]/ul/li[3]
    #rag And Drop    xpath=//*[@id="app"]/div/div[1]/div[2]/ul/li[4]/ul/li[3]/ul/li[1]        xpath=//*[@id="app"]/div/div[1]/div[2]/ul/li[4]/ul/li[3]/ul/li[7]
    Wait Until Page Contains       尚龙测试企业112222
    Wait Until Element Is Visible    xpath=//*[@id="app"]/div/div[1]/div[2]/ul/li[4]/ul/li[4]/ul/li[3]/div/i
    Click Element     xpath=//*[@id="app"]/div/div[1]/div[2]/ul/li[4]/ul/li[4]/ul/li[3]/div/i
                                   
    Wait Until Page Contains       用户角色管理
    Wait Until Element Is Visible    xpath=//*[@id="app"]/div/div[2]/div/div[1]/div/label[6]
    Click Element     xpath=//*[@id="app"]/div/div[2]/div/div[1]/div/label[6]
    
    
QiYeGuanLi Add Quanxian
    [Arguments]    ${NewUser}    ${alais}
    Switch Browser     ${alais}
    Wait Until Element Is Visible    xpath=//*[@id="app"]/div/div[2]/div/div[2]/div[1]/input
    Sleep    1
    Clear Element Text    xpath=//*[@id="app"]/div/div[2]/div/div[2]/div[1]/input
    Sleep    2
    Input Text         xpath=//*[@id="app"]/div/div[2]/div/div[2]/div[1]/input    ${NewUser['alias']}

    Wait Until Page Contains       ${NewUser['alias']}
    Wait Until Element Is Visible    xpath=//*[@id="app"]/div/div[2]/div/div[2]/div[3]/ul/li
    Click Element     xpath=//*[@id="app"]/div/div[2]/div/div[2]/div[3]/ul/li
    Wait Until Page Contains       组织一部成员
    Wait Until Element Is Visible    xpath=//*[@id="role_id"]/div[1]/div[2]/div/div[2]/div/div[2]/div/div[1]/label/span
    Click Element     xpath=//*[@id="role_id"]/div[1]/div[2]/div/div[2]/div/div[2]/div/div[1]/label/span/span
    
    Wait Until Page Contains       授权
    Wait Until Element Is Visible      xpath=//*[@id="app"]/div/div[2]/div/div[2]/div[2]/button
    Click Button     xpath=//*[@id="app"]/div/div[2]/div/div[2]/div[2]/button    
    
    
    
    
    