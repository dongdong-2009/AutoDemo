*** Settings ***
Documentation     A test suite for valid login.
...
...               This test has a workflow that is created using keywords in
...               the imported resource file.

Library           keywordsPy.py
Resource          keywords.robot

*** Variable ***
${UserName}    zhaowen
${UserPasswd}   123456
${Title}     企业办公管理系统
${UaseNamePath}    xpath=//*[@id="form-login"]/center/div/div/div[2]/input
${UserPasswdPath}    xpath=//*[@id="form-login"]/center/div/div/div[3]/input
${SubmitButton}    css=#form-login > center > div > div > div.confirm > a.login_btn.btn.r
${Browser}        chrome
${Server}         http://172.19.6.177:8280
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
${data_file_name}    zhuanzilian_fake_OA_account.csv

*** Test Cases ***
Valid Login
    Open Browser To Login Page     ${Server}    ${LoginUrl}    ${Browser} 
    Login Page Should Has Title    ${Title}
    Input Text         ${UaseNamePath}     ${UserName}
    Input Text         ${UserPasswdPath}    ${UserPasswd}
    Submit By Clict Element     ${SubmitButton}

Add Test Users
    #Pause Execution    Now Add Test 
    Open YongHuGuanli Window    ${ZuZhiGuanLi}    ${YongHuGuanLi}
    Open Add User Page     ${AddUser}
    :For     ${index}    IN Range    0    600
    \    ${inx} =    Get Index Real Data    ${index} 
    \    Log Many     xtcAuto   6000   ${index}    ${inx}
    \    ${NewUser} =    Fake Account    xtcAuto    6000    ${inx}    ${data_file_name}
    \    Add User Info    ${NewUser}
    \    Set User Job
    \    Set User Role
    \    Submit New Account
    
   #[Teardown]    Close Browser

*** Keywords ***
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
    Open Windows By Click Element     xpath=//*[@id="tabMyInfo"]/div[1]/ul/li[2]
    Open Windows By Click Element     xpath=//*[@id="orgTree_2_switch"]  
    Wait Until Element Is Visible     css=#orgTree_6_check
    Click Element     css=#orgTree_6_check   
    Open Windows By Click Element     xpath=//*[@id="orgTree_4_switch"]
    Open Windows By Click Element     xpath=//*[@id="orgTree_64_a"]
    Open Windows By Click Element     xpath=//*[@id="orgPosTree_2"]
    Wait Until Element Is Visible     xpath=//*[@id="orgPosAdd"]
    Click Element     xpath=//*[@id="orgPosAdd"]
    Select Checkbox     xpath=//*[@id="10000001280780"]/td[4]/input
    Select Checkbox     xpath=//*[@id="10000001280780"]/td[5]/input

Set User Role
    Open Windows By Click Element    xpath=//*[@id="tabMyInfo"]/div[1]/ul/li[3]    
    Open Windows By Click Element    xpath=//*[@id="rolTree_4_switch"]
    Wait Until Element Is Visible    xpath=//*[@id="rolTree_5_a"]
    Click Element     xpath=//*[@id="rolTree_5_a"]
    Click Element     xpath=//*[@id="rolAdd"]

ReRun When Save Fail
    Wait Until Page Contains   用户保存失败!
    Wait Until Element Is Visible     css=body > div.l-dialog > table > tbody > tr:nth-child(2) > td.l-dialog-cc > div > div.l-dialog-buttons > div > div.l-dialog-btn > div.l-dialog-btn-inner
    Click Element    css=body > div.l-dialog > table > tbody > tr:nth-child(2) > td.l-dialog-cc > div > div.l-dialog-buttons > div > div.l-dialog-btn > div.l-dialog-btn-inner
    Click Link       xpath=/html/body/div[1]/div/div[2]/div/div[3]/a
    
Submit New Account
    #Choose Ok On Next Confirmation
    Click Button      xpath=//*[@id="dataFormSave"]
    ${status}    ${errinfo} =    Run Keyword And Ignore Error    Click Element     xpath=/html/body/div[4]/table/tbody/tr[2]/td[2]/div/div[3]/div/div[2]/div[3]
    Run Keyword IF    '${status}' != 'PASS'    ReRun When Save Fail      
    #Confirm Action
