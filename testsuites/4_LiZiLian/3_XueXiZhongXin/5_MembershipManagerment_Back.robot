*** Settings ***
Documentation     使用谷歌浏览器测试资源商城前台业务.
...               选择分来商品->确认商品详情->确认领用->领用进度查询
...               This test is a workflow that is created using keywords in
...               the imported resource file.
Library           keywordsPy.py
Resource          keywords.robot

Force Tags      tid-4-2-1     owner-QinXing

*** Variable ***
${User Name}    aaq5
${User Passwd}   admin123
${Admin Name}    admin
${Admin Passwd}   123456
${Title}     首页 - 学习中心
${CMS Title}     后台管理系统
${Browser}        chrome
${User Interface}            http://test.learncenter.wn.weilian.cn/back/
${CMS Server}         http://mall.xt.weilian.cn/mobile/#/main/home
${User SessionId}      f3fecf7602a74101aba2425efb9436b8


*** Test Cases ***
Login XXZX CMS
    Open Browser To Login Page     ${CMS}     ${Browser} 
    Login Page Should Has Title    ${CMS Title}
    Input Username        css = #userName     ${Admin Name}
    Input Password        css = #password    ${Admin Passwd}
    Submit Credentials    css = #but_login
    Wait Until Page Contains    欢迎使用学习中心后台管理系统
    Login Page Should Has Title    学习中心后台管理系统
    
System Managerment
    Wait Until Page Contains    系统管理
    Click Element    css = #_easyui_tree_15 > span.tree-icon.tree-folder.icon-security.tree-folder-open
    
    Manager User
    
    Manager Enterprise
    
    
    Add New Goods In CMS
    ${NewGood} =    Fake Goods         AZ    设备类
    Log     ${NewGood}
    Input Good Info In CMS    ${NewGood}

    
Clean ENV 
    Close All Browsers

*** Keywords ***

Manager User Add
    [Arguments]   ${New User}
    Wait Until Page Contains    系统用户
    Click Element    css = #_easyui_tree_16
    Wait Until Page Contains    添加
    Wait Until Element Is Visible    css = #tb-queryUser > div:nth-child(2) > a:nth-child(1) > span > span.l-btn-icon.icon-add
    Click Element    css = #tb-queryUser > div:nth-child(2) > a:nth-child(1) > span
    

Input Good Info In CMS    
    [Arguments]   ${NewGood}
    Wait Until Page Contains     资产名称
    Input Text    xpath=//*[@id="goodsname"]    ${NewGood['goodsName']}
    Wait Until Page Contains    资产分类
    
    Click Element       xpath=//*[@id="gm-addGoods-div"]/form/table/tbody/tr[3]/td[1]/input[4]
    Wait Until Element Is Visible     xpath=//*[@id="other-goodsclass_treeul_2_span"]
    Click Element       xpath=//*[@id="other-goodsclass_treeul_2_span"]
    Click Element       css=#layui-layer2 > div.layui-layer-btn > a
    Wait Until Page Contains    资产编码
    Input Text    xpath=//*[@id="goodscode"]    ${NewGood['goodsNo']} 
    Wait Until Page Contains    基本售价
    Input Text    xpath=//*[@id="gm-addGoods-div"]/form/table/tbody/tr[5]/td[1]/input     ${NewGood['price']} 
    Wait Until Page Contains    品牌
    Input Text    xpath=//*[@id="brandname"]    ${NewGood['brand']}  
    Wait Until Page Contains    计量单位
    Input Text    xpath=//*[@id="goodsunit"]    ${NewGood['unitName']}  
    Wait Until Page Contains    资产型号
    Input Text    xpath=//*[@id="gm-addGoods-div"]/form/table/tbody/tr[4]/td[2]/input    ${NewGood['goodModel']}  
    Wait Until Page Contains    状态
    Select From List By Value    xpath=//*[@id="status"]    1
    Wait Until Page Contains    资产规格
    Input Text    xpath=//*[@id="goodsspec"]    ${NewGood['size']}  
    Wait Until Page Contains    财务编码
    Input Text    xpath=//*[@id="gm-addGoods-div"]/form/table/tbody/tr[6]/td[2]/input    ${NewGood['account']}  
    Wait Until Page Contains    流程类型
    Select From List By Value    xpath=//*[@id="approvaltypeid"]    1
    Wait Until Page Contains    资产等级
    Select From List By Value    xpath=//*[@id="goodslevelid"]    4
    Wait Until Page Contains    资产归属部门
    Select From List By Value    xpath=//*[@id="gsbmid"]    3
    Click Element       xpath=//*[@id="layui-layer1"]/div[3]/a[1]
    

    
        