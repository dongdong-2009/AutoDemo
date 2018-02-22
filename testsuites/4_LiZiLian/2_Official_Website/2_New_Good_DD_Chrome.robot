*** Settings ***
Documentation     使用谷歌浏览器测试资源商城前台业务.
...               选择分来商品->确认商品详情->确认领用->领用进度查询
...               This test is a workflow that is created using keywords in
...               the imported resource file.
Library           keywordsPy.py
Resource          keywords.robot
Force Tags      tid-4-2-2     owner-QinXing

*** Variable ***
${UserName}    setest01
${UserPasswd}   123456
${Title}     资源商城
${CMS Title}     系统登录
${UaseNamePath}    xpath=//*[@id="login-username"]
${UserPasswdPath}    xpath=//*[@id="login-password"]
${SubmitButton}    xpath=//*[@id="form-login"]/div[3]/div[2]/button
${Browser}        chrome
${Server}         http://mall.xt.weilian.cn/mobile/#/main/home
${CMS}            http://system-rest-enterprise.mall.xt.weilian.cn
${SessionId}      c64e81e93c044466af14e53f6a8df5e5


${DeviceClass}    xpath=//*[@id="app"]/div/div[2]/div[2]/ul[1]/li[1]/a/span
${DeviceInfo}     xpath=//*[@id="app"]/div/div[2]/div[2]/div/ul/li[1]/div/div[1]/img
${GetDevice}      xpath=//*[@id="add_to_car"]
${SubmitOrder}    xpath=/html/body/div[2]/div/div[2]/button[2]
${CancelOrder}    xpath=/html/body/div[2]/div/div[2]/button[1]
${OrderInfo}      xpath=//*[@id="app"]/div/div/p[4]/span

${WaitForSent}    xpath=//*[@id="app"]/div/div[1]/div/ul/li[3]

*** Test Cases ***
Login ZYSC CMS And Open New Goods 
    Open Browser To Login Page     ${CMS}     ${Browser} 
    Login Page Should Has Title    ${CMS Title}
    Input Username        ${UaseNamePath}     ${UserName}
    Input Password        ${UserPasswdPath}    ${UserPasswd}
    Submit Credentials    ${SubmitButton}
    
Check Goods Info Datas Form
    [Template]    Input Good Info In CMS
    #${goodsName}    ${goodsNo}     ${price}    ${brand}    ${unitName}   ${goodModel}   ${size}   ${account}    
    测试商品85          0202285        999         普罗旺斯              无单位                        NO000002        9*9*8    PJ88888 
    测试商品73          0202221        993         普罗旺斯              无单位                        NO000013        9*9*1    PJ99999 
       
Clean ENV 
    Close All Browsers

*** Keywords ***
Add New Goods In CMS
    Wait Until Page Contains    资产管理
    Wait Until Element Is Visible     xpath=//*[@id="sidebar-scroll"]/li[1]/a/i[1]
    Click Element       xpath=//*[@id="sidebar-scroll"]/li[1]/a/i[1]
    Wait Until Page Contains    资产信息
    Wait Until Element Is Visible     xpath=//*[@id="sidebar-scroll"]/li[1]/ul/li[1]/a
    Click Element       xpath=//*[@id="sidebar-scroll"]/li[1]/ul/li[1]/a
    
    Wait Until Page Contains    新增
    Wait Until Element Is Visible     xpath=//*[@id="goods-manage-table"]/div/div/div/div[1]/div[2]/a[1]
    Click Element       xpath=//*[@id="goods-manage-table"]/div/div/div/div[1]/div[2]/a[1]
    
Input Good Info In CMS    
    [Arguments]   ${goodsName}    ${goodsNo}     ${price}    ${brand}    ${unitName}   ${goodModel}   ${size}   ${account} 
    Add New Goods In CMS
    Wait Until Page Contains     资产名称
    Input Text    xpath=//*[@id="goodsname"]    ${goodsName}
    Wait Until Page Contains    资产分类  
    Click Element       xpath=//*[@id="gm-addGoods-div"]/form/table/tbody/tr[3]/td[1]/input[4]
    Wait Until Element Is Visible     xpath=//*[@id="other-goodsclass_treeul_3_span"]
    Click Element       xpath=//*[@id="other-goodsclass_treeul_3_span"]
    ${status}    ${errinfo} =    Run Keyword And Ignore Error    Click Element       css=#layui-layer2 > div.layui-layer-btn > a
    Run Keyword IF    '${status}' != 'PASS'    Click Element       css=#layui-layer5 > span.layui-layer-setwin > a.layui-layer-ico.layui-layer-close.layui-layer-close1
    Wait Until Page Contains    资产编码
    Input Text    xpath=//*[@id="goodscode"]    ${goodsNo} 
    Wait Until Page Contains    基本售价
    Input Text    xpath=//*[@id="gm-addGoods-div"]/form/table/tbody/tr[5]/td[1]/input     ${price} 
    Wait Until Page Contains    品牌
    Input Text    xpath=//*[@id="brandname"]    ${brand}  
    Wait Until Page Contains    计量单位
    Input Text    xpath=//*[@id="goodsunit"]    ${unitName}  
    Wait Until Page Contains    资产型号
    Input Text    xpath=//*[@id="gm-addGoods-div"]/form/table/tbody/tr[4]/td[2]/input    ${goodModel}  
    Wait Until Page Contains    状态
    Select From List By Value    xpath=//*[@id="status"]    1
    Wait Until Page Contains    资产规格
    Input Text    xpath=//*[@id="goodsspec"]    ${size}  
    Wait Until Page Contains    财务编码
    Input Text    xpath=//*[@id="gm-addGoods-div"]/form/table/tbody/tr[6]/td[2]/input    ${account}  
    Wait Until Page Contains    流程类型
    Select From List By Value    xpath=//*[@id="approvaltypeid"]    1
    Wait Until Page Contains    资产等级
    Select From List By Value    xpath=//*[@id="goodslevelid"]    4
    Wait Until Page Contains    资产归属部门
    Select From List By Value    xpath=//*[@id="gsbmid"]    3
    ${status}    ${errinfo} =    Run Keyword And Ignore Error    Click Element       xpath=//*[@id="layui-layer1"]/div[3]/a[1]
    Run Keyword IF    '${status}' != 'PASS'    Run Keyword And Ignore Error    Click Element       css=#layui-layer4 > div.layui-layer-btn > a.layui-layer-btn0
    Sleep   5
