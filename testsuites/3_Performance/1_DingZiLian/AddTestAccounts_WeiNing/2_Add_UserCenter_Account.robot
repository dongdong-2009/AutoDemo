*** Settings ***
Documentation     A test suite for valid login.
...
...               This test has a workflow that is created using keywords in
...               the imported resource file.

Force Tags      tid-3-5-2     owner-QinXing
Library           keywordsPy.py
Resource          keywords.robot

*** Variable ***
${UserName}    admin
${UserPasswd}   admin
${Title}     企业办公管理系统
${UaseNamePath}    xpath=//*[@id="form-login"]/center/div/div/div[2]/input
${UserPasswdPath}    xpath=//*[@id="form-login"]/center/div/div/div[3]/input
${SubmitButton}    css=#form-login > center > div > div > div.confirm > a.login_btn.btn.r
${Browser}        chrome
${Server}         http://172.19.6.176:8280
${LoginUrl}      ${Server}/bpmx/platform/console/main.ht

${ZuZhiGuanLi}    xpath=//*[@id="45"]
${YongHuGuanLi}    xpath=//*[@id="leftTree_1_a"]
${AddUser}     xpath=//*[contains(concat(' ', @href, ' '), ' edit.ht ')]  

#User Info
${account}     xpath=//*[@id="account"] 
${password}    xpath=//*[@id="password"] 
${fullname}    xpath= //*[@id="fullname"]
${mobileNo}    xpath=//*[@id="mobile"]
${email}       xpath=//*[@id="email"] 
${staff_no}    xpath=//*[@id="staffNo"]
${identification}    xpath=//*[@id="identification"]
${attend_no}    xpath=//*[@id="attendNo"]
${alias}       xpath=//*[@id="aliasName"]
${data_file_name}    fake_account.csv

*** Test Cases ***
Add Test Users
    ${QiYeGuanLi} =    QiYeGuanLi Login
    Open QuanXian GuanLi
    ${OA} =    OA Login
    Open YongHuGuanli Window    ${ZuZhiGuanLi}    ${YongHuGuanLi}
    Open Add User Page     ${AddUser}
    :For     ${index}    IN Range    600    619
    \    ${inx} =    Get Index Real Data    ${index} 
    \    ${NewUser} =    Fake Account    WeiNing    6000    ${inx}    ${data_file_name}
    \    Add User Info    ${NewUser}
    \    Set User Job
    \    Submit New Account
    \    Switch Browser    ${QiYeGuanLi}
    \    QiYeGuanLi Add Quanxian     ${NewUser}
    \    Switch Browser    ${OA}
    
   [Teardown]    Close All Browsers

*** Keywords ***
    
Open QuanXian GuanLi
 
    Wait Until Page Contains       权限管理
    Wait Until Element Is Visible    xpath=//*[@id="app"]/div/div[1]/div[2]/ul/li[4]/div/i[2]
    Click Element     xpath=//*[@id="app"]/div/div[1]/div[2]/ul/li[4]/div/i[2]    

    Wait Until Page Contains       角色类型控制
    Wait Until Element Is Visible    xpath=//*[@id="app"]/div/div[1]/div[2]/ul/li[4]/ul/li[3]/div/i
    Click Element     xpath=//*[@id="app"]/div/div[1]/div[2]/ul/li[4]/ul/li[3]/div/i  
    
    Mouse Over    xpath=//*[@id="app"]/div/div[1]/div[2]/ul/li[4]/ul/li[3]
    Drag And Drop    xpath=//*[@id="app"]/div/div[1]/div[2]/ul/li[4]/ul/li[3]/ul/li[1]        xpath=//*[@id="app"]/div/div[1]/div[2]/ul/li[4]/ul/li[3]/ul/li[7]
    Wait Until Page Contains       尚龙测试企业112222
    Wait Until Element Is Visible    xpath=//*[@id="app"]/div/div[1]/div[2]/ul/li[4]/ul/li[3]/ul/li[6]/div/span
    Click Element     xpath=//*[@id="app"]/div/div[1]/div[2]/ul/li[4]/ul/li[3]/ul/li[5]/div/span
                                   
    Wait Until Page Contains       用户角色管理
    Wait Until Element Is Visible    xpath=//*[@id="app"]/div/div[2]/div/div[1]/div/label[6]
    Click Element     xpath=//*[@id="app"]/div/div[2]/div/div[1]/div/label[6]
    Wait Until Page Contains       威宁组织部
    
QiYeGuanLi Add Quanxian
    [Arguments]    ${NewUser}
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
    
    #Wait Until Page Contains       授权管理
    #Wait Until Element Is Visible      xpath=//*[@id="app"]/div/div[2]/div/div[1]/div/label[7]/input
    #Click Button     xpath=//*[@id="app"]/div/div[2]/div/div[1]/div/label[7]/input
    
OA Login
    ${OA} =    Open Browser To Login Page     ${Server}    ${LoginUrl}    ${Browser}     OA
    Login Page Should Has Title    ${Title}
    Input Text         ${UaseNamePath}     ${UserName}
    Input Text         ${UserPasswdPath}    ${UserPasswd}
    Submit By Clict Element     ${SubmitButton}
    [Return]    ${OA}

QiYeGuanLi Login
    Open Browser    http://172.19.6.103:81    ${Browser}     QiYeGuanLi
    Maximize Browser Window
    Set Selenium Speed    0
    Input Text         xpath=//*[@id="companyName"]/input     platform_admin
    Input Text         xpath=//*[@id="app"]/div/div[2]/div/form/div[2]/div/div/input    123456
    Submit By Clict Element     xpath=//*[@id="app"]/div/div[2]/div/form/div[3]/button
    [Return]    QiYeGuanLi
    
Open YongHuGuanli Window
    [Arguments]    ${ZuZhiGuanLi}    ${YongHuGuanLi}
    Open Windows By Click Element     ${ZuZhiGuanLi} 
    Open Windows By Click Element     ${YongHuGuanLi} 
    
Open Add User Page
    [Arguments]    ${AddUser} 
    #Page Should Contain Link     ${AddUser} 
    ${CurrentLink} =    Get Location
    Go To     ${Server}/bpmx/platform/system/sysUser/edit.ht
                      
Add User Info
    [Arguments]     ${NewUser}	 						
    Input Text      ${account}     ${NewUser['account']}
    Input Text      ${password}    ${NewUser['password']}
    Input Text      ${fullname}    ${NewUser['fullname']}
    Input Text      ${mobileNo}    ${NewUser['mobileNo']}
    Input Text      ${email}     ${NewUser['email']}
    Input Text      ${staff_no}    ${NewUser['staff_no']}
    Input Text      ${identification}    ${NewUser['identification']}
    Input Text      ${attend_no}    ${NewUser['attend_no']}
    Input Text      ${alias}        ${NewUser['alias']}
    
Set User Job
    Wait Until Page Contains       岗位选择
    Open Windows By Click Element     xpath=//*[@id="tabMyInfo"]/div[1]/ul/li[2]
    Open Windows By Click Element     xpath=//*[@id="orgTree_39_switch"]
    Wait Until Element Is Visible     css=#orgTree_57_check
    Click Element     css=#orgTree_57_check
    Wait Until Element Is Visible     xpath=//*[@id="orgPosTree_2_check"]
    Click Element     xpath=//*[@id="orgPosTree_2_check"]
    Click Element     xpath=//*[@id="orgPosAdd"] 
    Select Checkbox     xpath=//*[@id="10000001561068"]/td[3]/input
    Select Checkbox     xpath=//*[@id="10000001561068"]/td[4]/input

Set User Role
    Wait Until Page Contains       角色选择
    Open Windows By Click Element    xpath=//*[@id="tabMyInfo"]/div[1]/ul/li[3]
    Open Windows By Click Element    xpath=//*[@id="rolTree_6_switch"]
    Wait Until Element Is Visible    xpath=//*[@id="rolTree_8"]
    Click Element     xpath=//*[@id="rolTree_8_check"]
    Click Element     xpath=//*[@id="rolAdd"]

ReRun When Save Fail
    Wait Until Page Contains   用户保存失败!
    Wait Until Element Is Visible     css=body > div.l-dialog > table > tbody > tr:nth-child(2) > td.l-dialog-cc > div > div.l-dialog-buttons > div > div.l-dialog-btn > div.l-dialog-btn-inner
    Click Element    css=body > div.l-dialog > table > tbody > tr:nth-child(2) > td.l-dialog-cc > div > div.l-dialog-buttons > div > div.l-dialog-btn > div.l-dialog-btn-inner
    Click Link       xpath=/html/body/div[1]/div/div[2]/div/div[3]/a
    
Submit New Account
    Click Button      xpath=//*[@id="dataFormSave"]
    ${status}    ${errinfo} =    Run Keyword And Ignore Error    Click Element     xpath=/html/body/div[4]/table/tbody/tr[2]/td[2]/div/div[3]/div/div[2]/div[3]
    Run Keyword IF    '${status}' != 'PASS'    ReRun When Save Fail      
    
    
    
    
    
    