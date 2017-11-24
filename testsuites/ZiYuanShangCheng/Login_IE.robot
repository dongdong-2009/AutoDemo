*** Settings ***
Documentation     A test suite for valid login.
...
...               This test has a workflow that is created using keywords in
...               the imported resource file.

Resource          keywords.robot

*** Variable ***
${UserName}    qinxing@suneee.com
${UserPasswd}   123456
${Title}     登录页面
${UaseNamePath}    xpath=//*[@id="account"]
${UserPasswdPath}    xpath=//*[@id="password"]
${SubmitButton}    xpath=//*[@id="btn"]
${Browser}       IE
${Server}         http://xpomg.weilian.cn
${LoginUrl}      ${Server}/login.html  

*** Test Cases ***
Valid Login
    Open Browser To Login Page     ${Server}    ${LoginUrl}    ${Browser} 
    Login Page Should Has Title    ${Title}
    Input Username        ${UaseNamePath}     ${UserName}
    Input Password        ${UserPasswdPath}    ${UserPasswd}
    Submit Credentials    ${SubmitButton}
    [Teardown]    Close Browser
