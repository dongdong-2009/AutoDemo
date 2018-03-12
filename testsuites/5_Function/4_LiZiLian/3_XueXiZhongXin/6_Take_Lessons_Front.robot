*** Settings ***
Documentation     使用谷歌浏览器测试资源商城前台业务.
...               选择课程分类->课程->打开课程->学习课程和笔记、交流
...               This test is a workflow that is created using keywords in
...               the imported resource file.
Library           keywordsPy.py
Library           SeleniumLibrary    timeout=15.0    implicit_wait=5.0
Resource          keywords.robot

Force Tags      tid-4-3-6     owner-QinXing

*** Variable ***
${User Name}     aaq5
${User Passwd}    123456
${Admin Name}     admin
${Admin Passwd}    admin123
${Title}     威宁象谱-登录
${CMS Title}     后台管理系统
${Browser}        chrome
${User Interface}            http://xptest.sunmath.cn/weining0.5/login.html
${CMS Server}         http://mall.xt.weilian.cn/mobile/#/main/home
${User SessionId}      f3fecf7602a74101aba2425efb9436b8


*** Test Cases ***
Login XXZX
    Open Browser To Login Page     ${User Interface}     ${Browser} 
    Login Page Should Has Title    ${Title} 
    Wait Until Page Contains Element    css = body > div > div > div.login_box > img
    Input Username        css = #account     ${User Name} 
    Input Password        css = #password    ${User Passwd}
    Submit Credentials    css = #btn
    Wait Until Page Contains    学习中心
    #Click Element    css = #maincontent-id > div.container-fluid.content-main-class.layoutC.clearfix > div.row.tempalteJS > div:nth-child(5) > div   
    Go To     http://test.learncenter.wn.weilian.cn/web2?sessionId=fa14f81dd54341dab9bbb29bb0f74a09

View PPT Lisson
    Select Lessons    
    :For     ${index}    IN Range    0    100
    \      
    \    Log     View PPT-50 Pages For ${index} Times
    \    Take Lessons
    \    Go Back To Lesson Class
    
#Clean ENV 
#    Close All Browsers

*** Keywords ***
Select Lessons Class By Name
    [Arguments]   ${Lesson Class Name}
    Wait Until Page Contains    ${Lesson Class Name}
    Run Keyword If     '${Lesson Class Name}' == '老班长'    Click Element    css = #app > div.centerBanner > div.centerTitle > div > div > ul > li.active
    ...    Else If    '${Lesson Class Name}' == '企业文化'    Click Element    css = #app > div.centerBanner > div.centerTitle > div > div > ul > li:nth-child(3)
    ...    Else If    '${Lesson Class Name}' == '吃茶去'    Click Element    css = #app > div.centerBanner > div.centerTitle > div > div > ul > li:nth-child(4)
    ...    Else If    '${Lesson Class Name}' == '放风筝'    Click Element    css = #app > div.centerBanner > div.centerTitle > div > div > ul > li:nth-child(5)
    ...    Else If    '${Lesson Class Name}' == '安全生产'    Click Element    css = #app > div.centerBanner > div.centerTitle > div > div > ul > li:nth-child(6)
    ...    Else If    '${Lesson Class Name}' == '首页'    Click Element    css = #app > div.centerBanner > div.centerTitle > div > div > ul > li:nth-child(1) 
    ...    Else    Fail   Lesson Class ${Lesson Class Name} Is Not Find !

Select Lessons 
    Login Page Should Has Title    首页 - 学习中心
    Wait Until Page Contains     企业文化
    Wait Until Element Is Visible    xpath = //*[@id="app"]/div[1]/div[1]/div/div/ul/li[2]
    Run Keyword And Ignore Error    Click Element    xpath = //*[@id="app"]/div[1]/div[1]/div/div/ul/li[2]

Take Lessons
    Wait Until Page Contains    Test-PPT-50
    Wait Until Element Is Visible    css = #app > div.contentWrap.banxin > div > div:nth-child(3) > p:nth-child(1) > img
    Click Image    css = #app > div.contentWrap.banxin > div > div:nth-child(3) > p:nth-child(1) > img
    Wait Until Page Contains    课程详情
    Wait Until Element Is Visible    css = #courseVideo > div > div.learnSure
    Sleep    2
    
    Go To     http://learn.xt.weilian.cn/op/view.aspx?src=http://xpomg.weilian.cn/group1/M00/00/19/rBAoEVp0F3OAMf2oAAtJ-3G6w_s04.pptx
    :For     ${idx}    IN Range    0    50
    \    Click Element    css = #wacframe


Go Back To Lesson Class 
    Go To    http://test.learncenter.wn.weilian.cn/web2/page/train/detail.html?id=5b53db58a41d49e495dec35fac349c41
    Wait Until Element Is Visible    css = #app > div > div > div > div.breadbar.banxin > a:nth-child(3)
    Click Element    css = #app > div > div > div > div.breadbar.banxin > a:nth-child(3)

Take Lessons By Name 
    [Arguments]   ${Lesson Name} 
    Wait Until Page Contains    ${Lesson Name}
    ${count} =    Get Element Count    css = #app > div.contentWrap.banxin > div > div:nth-child > p.corTitle
    :FOR    index   IN Range     0    ${count}
    \    ${status}    ${errinfo} =    Run Keyword And Ignore Error    Element Text Should Be    
    \    css = #app > div.contentWrap.banxin > div > div:nth-child(2) > p.corTitle
    
Manager User Add
    [Arguments]   ${New User}
    Wait Until Page Contains    系统用户
    Click Element    css = #_easyui_tree_16
    Wait Until Page Contains    添加
    Wait Until Element Is Visible    css = #tb-queryUser > div:nth-child(2) > a:nth-child(1) > span > span.l-btn-icon.icon-add
    Click Element    css = #tb-queryUser > div:nth-child(2) > a:nth-child(1) > span
    


    
        