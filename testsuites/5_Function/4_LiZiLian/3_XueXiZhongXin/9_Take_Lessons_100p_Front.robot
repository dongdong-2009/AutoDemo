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
${User Name}     18665939001
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

Clean ENV
    Close All Browsers

*** Keywords ***
Select Lessons
    Login Page Should Has Title    首页 - 学习中心
    Wait Until Page Contains     企业文化
    Wait Until Element Is Visible    xpath = //*[@id="app"]/div[1]/div[1]/div/div/ul/li[3]
    Run Keyword And Ignore Error    Click Element    xpath = //*[@id="app"]/div[1]/div[1]/div/div/ul/li[3]

Take Lessons
    Wait Until Page Contains    Test-PPT-100
    Wait Until Element Is Visible    css = #app > div.contentWrap.banxin > div > div:nth-child(3) > p:nth-child(1) > img
    Click Image    css = #app > div.contentWrap.banxin > div > div:nth-child(3) > p:nth-child(1) > img
    Wait Until Page Contains    课程详情
    Wait Until Element Is Visible    css = #courseVideo > div > div.learnSure
    Sleep    2

    Go To     http://learn.xt.weilian.cn/op/view.aspx?src=http://xpomg.weilian.cn/group1/M00/00/19/rBAoEVp0F92ASfP-AHR4DsD70P426.pptx
    :For     ${idx}    IN Range    0    100
    \    Click Element    css = #wacframe
    \    Sleep    2


Go Back To Lesson Class
    Go Back
    Wait Until Element Is Visible    css = #app > div > div > div > div.breadbar.banxin > a:nth-child(3)
    Click Element    css = #app > div > div > div > div.breadbar.banxin > a:nth-child(3)
