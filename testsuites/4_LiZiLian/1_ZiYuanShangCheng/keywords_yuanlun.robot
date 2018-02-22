*** Settings ***
Documentation     资源商城后台测试关键字,包含资产类型管理，资产登记管理，流程类型管理。
...               Date：2018-02-05
...               Author: 原伦
...               Editor:Qinxing

Library           SeleniumLibrary

*** Variables ***

${back}           http://system-rest-enterprise.mall.xt.weilian.cn/
${browser}        chrome

*** Keywords ***
登录
    [Arguments]    ${username}    ${password}    ${browser}    ${Managerment Server}
    open browser    ${back}    ${browser}
    maximize browser window
    input text    id=login-username    ${username}
    input text    id=login-password    ${password}
    click element    xpath=//button[@type='submit']
    wait until page does not contain    记住密码
    title should be    资源商城管理平台

资产归属部门管理-新增
    [Arguments]    ${gsbmname}
    登录    seadmin    123456
    wait until element is enabled    xpath=//*[@id="sidebar-scroll"]/li[2]/a
    click element    xpath=//*[@id="sidebar-scroll"]/li[2]/a
    sleep    2
    click element    xpath=//a[@data-url='http://vr-goods-rest-enterprise.mall.xt.weilian.cn/static/goodsgsbmList.html']
    wait until page contains    新增
    click element    xpath=//a[@title='新增']
    wait until page contains    资产归属部门新增
    input text    id=gsbmname    ${gsbmname}
    click element    xpath=//*[@id="savebtn"]
    wait until page contains    新增成功
    click element    xpath=//*[@id="goodsgsbm_query"]
    wait until element is enabled    id=gsbmname
    input text    id=gsbmname    ${gsbmname}
    click element    id=queryGoodsgsbmBtn
    ${str}    get text    xpath=//*[@id="DataTables_Table_0"]/tbody/tr/td[4]
    should be equal    ${str}    ${gsbmname}
    close browser

资产归属部门管理-查询
    [Arguments]    ${gsbmname}
    登录    seadmin    123456
    wait until element is enabled    xpath=//*[@id="sidebar-scroll"]/li[2]/a
    click element    xpath=//*[@id="sidebar-scroll"]/li[2]/a
    sleep    3
    click element    xpath=//a[@data-url='http://vr-goods-rest-enterprise.mall.xt.weilian.cn/static/goodsgsbmList.html']
    wait until element is enabled    xpath=//a[@title='查询']
    click element    xpath=//a[@title='查询']
    sleep    2
    input text    id=gsbmname    ${gsbmname}
    click element    xpath=//*[@id="queryGoodsgsbmBtn"]

资产归属部门管理-编辑
    [Arguments]    ${gsbmnameold}    ${gsbmnamenew}
    资产归属部门管理-查询    ${gsbmnameold}
    sleep    5
    click element    xpath=//div[@class='icheckbox_square-blue']
    click element    xpath=//a[@title='编辑']
    sleep    3
    input text    id=gsbmname    ${gsbmnamenew}
    click element    xpath=//*[@id="savebtn"]
    wait until page contains    保存成功
    click element    xpath=//*[@id="goodsgsbm_query"]
    wait until element is enabled    id=gsbmname
    input text    id=gsbmname    ${gsbmnamenew}
    click element    id=queryGoodsgsbmBtn
    wait until element is enabled    xpath=//*[@id="DataTables_Table_0"]/tbody/tr/td[4]
    ${str}    get text    xpath=//*[@id="DataTables_Table_0"]/tbody/tr/td[4]
    should be equal    ${str}    ${gsbmnamenew}
    close browser

资产归属部门管理-删除
    [Arguments]    ${gsbmname}
    资产归属部门管理-查询    ${gsbmname}
    sleep    5
    click element    xpath=//div[@class='icheckbox_square-blue']
    click element    xpath=//a[@title='删除']
    wait until page contains    你确定删除所选记录吗？删除操作不能恢复!
    click element    xpath=//a[@class='layui-layer-btn0']
    wait until page contains    删除成功
    close browser

资产等级管理-新增
    [Arguments]    ${level}
    登录    seadmin    123456
    wait until element is enabled    xpath=//*[@id="sidebar-scroll"]/li[2]/a
    click element    xpath=//*[@id="sidebar-scroll"]/li[2]/a
    sleep    2
    click element    xpath=//a[@data-url='http://vr-goods-rest-enterprise.mall.xt.weilian.cn/static/goodslevelList.html']
    wait until page contains    新增
    click element    xpath=//a[@title='新增']
    wait until page contains    资产等级新增
    input text    id=level    ${level}
    click element    xpath=//*[@id="savebtn"]
    wait until page contains    新增成功
    click element    xpath=//a[@title='查询']
    sleep    2
    input text    id=level    ${level}
    click element    xpath=//*[@id="queryGoodslevelBtn"]
    ${str}    get text    xpath=//*[@id="DataTables_Table_0"]/tbody/tr[1]/td[4]
    should be equal    ${str}    ${level}
    close browser

资产等级管理-查询
    [Arguments]    ${level}
    登录    seadmin    123456
    wait until element is enabled    xpath=//*[@id="sidebar-scroll"]/li[2]/a
    click element    xpath=//*[@id="sidebar-scroll"]/li[2]/a
    sleep    2
    click element    xpath=//a[@data-url='http://vr-goods-rest-enterprise.mall.xt.weilian.cn/static/goodslevelList.html']
    wait until element is enabled    xpath=//a[@title='查询']
    click element    xpath=//a[@title='查询']
    sleep    2
    input text    id=level    ${level}
    click element    xpath=//*[@id="queryGoodslevelBtn"]

资产等级管理-编辑
    [Arguments]    ${levelold}    ${levelnew}
    资产等级管理-查询    ${levelold}
    sleep    5
    click element    xpath=//div[@class='icheckbox_square-blue']
    click element    xpath=//a[@title='编辑']
    sleep    3
    input text    id=level    ${levelnew}
    click element    xpath=//*[@id="savebtn"]
    wait until page contains    保存成功
    click element    xpath=//a[@title='查询']
    sleep    2
    input text    id=level    ${levelnew}
    click element    xpath=//*[@id="queryGoodslevelBtn"]
    wait until element is enabled    xpath=//*[@id="DataTables_Table_0"]/tbody/tr[1]/td[4]
    ${str}    get text    xpath=//*[@id="DataTables_Table_0"]/tbody/tr[1]/td[4]
    should be equal    ${str}    ${levelnew}
    close browser

资产等级管理-删除
    [Arguments]    ${level}
    资产等级管理-查询    ${level}
    sleep    5
    click element    xpath=//div[@class='icheckbox_square-blue']
    click element    xpath=//a[@title='删除']
    wait until page contains    你确定删除所选记录吗？删除操作不能恢复!
    click element    xpath=//a[@class='layui-layer-btn0']
    wait until page contains    删除成功
    close browser

流程类型管理-新增
    [Arguments]    ${approvaltypename}    ${actdefid}
    登录    seadmin    123456
    wait until element is enabled    xpath=//*[@id="sidebar-scroll"]/li[2]/a
    click element    xpath=//*[@id="sidebar-scroll"]/li[2]/a
    sleep    3
    click element    xpath=//a[@data-url='http://vr-goods-rest-enterprise.mall.xt.weilian.cn/static/approvalTypeList.html']
    wait until page contains    新增
    click element    xpath=//a[@title='新增']
    wait until page contains    流程类型新增
    input text    id=approvaltypename    ${approvaltypename}
    input text    id=actdefid    ${actdefid}
    click element    xpath=//*[@id="savebtn"]
    wait until page contains    新增成功
    wait until element is enabled    xpath=//*[@id="DataTables_Table_0"]/tbody/tr/td[4]
    ${str1}    get text    xpath=//*[@id="DataTables_Table_0"]/tbody/tr/td[4]
    should be equal    ${str1}    ${approvaltypename}
    ${str2}    get text    xpath=//*[@id="DataTables_Table_0"]/tbody/tr/td[5]
    should be equal    ${str2}    ${actdefid}
    close browser

流程类型管理-查询
    [Arguments]    ${approvaltypename}
    登录    seadmin    123456
    wait until element is enabled    xpath=//*[@id="sidebar-scroll"]/li[2]/a
    click element    xpath=//*[@id="sidebar-scroll"]/li[2]/a
    sleep    3
    click element    xpath=//a[@data-url='http://vr-goods-rest-enterprise.mall.xt.weilian.cn/static/approvalTypeList.html']
    wait until element is enabled    xpath=//a[@title='查询']
    click element    xpath=//a[@title='查询']
    sleep    3
    input text    id=approvaltypename    ${approvaltypename}
    click element    xpath=//*[@id="queryApprovalTypeBtn"]

流程类型管理-编辑
    [Arguments]    ${approvaltypenameold}    ${approvaltypenamenew}    ${actdefid}
    流程类型管理-查询    ${approvaltypenameold}
    sleep    5
    click element    xpath=//div[@class='icheckbox_square-blue']
    click element    xpath=//a[@title='编辑']
    sleep    3
    input text    id=approvaltypename    ${approvaltypenamenew}
    input text    id=actdefid    ${actdefid}
    click element    xpath=//*[@id="savebtn"]
    wait until page contains    保存成功
    click element    xpath=//a[@title='查询']
    sleep    3
    input text    id=approvaltypename    ${approvaltypenamenew}
    click element    xpath=//*[@id="queryApprovalTypeBtn"]
    ${str1}    get text    xpath=//*[@id="DataTables_Table_0"]/tbody/tr/td[4]
    should be equal    ${str1}    ${approvaltypenamenew}
    ${str2}    get text    xpath=//*[@id="DataTables_Table_0"]/tbody/tr/td[5]
    should be equal    ${str2}    ${actdefid}
    close browser

流程类型管理-删除
    [Arguments]    ${approvaltypename}
    流程类型管理-查询    ${approvaltypename}
    sleep    5
    click element    xpath=//div[@class='icheckbox_square-blue']
    click element    xpath=//a[@title='删除']
    wait until page contains    你确定删除所选记录吗？删除操作不能恢复!
    click element    xpath=//a[@class='layui-layer-btn0']
    wait until page contains    删除成功
    close browser
