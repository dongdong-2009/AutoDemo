*** Settings ***
Documentation     使用谷歌浏览器测试资源商城前台业务.
...               选择分来商品->确认商品详情->确认领用->领用进度查询
...               This test is a workflow that is created using keywords in
...               the imported resource file.
Library           keywordsPy.py
Resource          keywords.robot

Force Tags      tid-4-1-2     owner-QinXing

*** Variable ***
${UserName}    setest01
${UserPasswd}   123456
${Title}     资源商城
${CMS Title}     系统登录
${UaseNamePath}    xpath=//*[@id="login-username"]
${UserPasswdPath}    xpath=//*[@id="login-password"]
${SubmitButton}    xpath=//*[@id="form-login"]/div[3]/div[2]/button
${Browser}        firefox
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
Login ZYSC CMS
    Open Browser To Login Page     ${CMS}     ${Browser} 
    Login Page Should Has Title    ${CMS Title}
    Input Username        ${UaseNamePath}     ${UserName}
    Input Password        ${UserPasswdPath}    ${UserPasswd}
    Submit Credentials    ${SubmitButton}
    
Manager Goods
    Add New Goods In CMS
    ${NewGood} =    Fake Goods         AZ    设备类
    Log     ${NewGood}
    Input Good Info In CMS    ${NewGood}
    #Set KuCun    ${NewGood}
    #ShangJia Good    ${NewGood}

Login ZYSC
    Open Browser To Login Page     ${Server}?sessionId=${SessionId}     ${Browser}
    Login Page Should Has Title    ${Title}

LingYong SheBai
    Select Device Class SheBai   
    Select One Device In Class
    Submit Order
    Check Order Log
    Check Order DaiFaHuo List
    Check Order DaiQueReng List
    Check Order Finished List
    

#Manager Orders
    #Open Order
    #[Teardown]    Close Browser
    
Clean ENV 
    Close All Browsers

*** Keywords ***
Add New Goods In CMS
    Wait Until Page Contains    商品管理
    Wait Until Element Is Visible     xpath=//*[@id="sidebar-scroll"]/li[3]/a/i[1]
    Click Element       xpath=//*[@id="sidebar-scroll"]/li[3]/a/i[1]
    Wait Until Page Contains    商品信息
    Wait Until Element Is Visible     xpath=//*[@id="sidebar-scroll"]/li[3]/ul/li[1]/a
    Click Element       xpath=//*[@id="sidebar-scroll"]/li[3]/ul/li[1]/a
    
    Wait Until Page Contains    新增
    Wait Until Element Is Visible     xpath=//*[@id="goods-manage-table"]/div/div/div/div[1]/div[1]/a
    Click Element       xpath=//*[@id="goods-manage-table"]/div/div/div/div[1]/div[1]/a
    
Input Good Info In CMS    
    [Arguments]   ${NewGood}
    Input Text    xpath=//*[@id="goodsname"]    ${NewGood['goodsName']}
    Wait Until Page Contains    选择
    
    Click Element       xpath=//*[@id="gm-addGoods-div"]/form/table/tbody/tr[3]/td[1]/input[4]
    Wait Until Element Is Visible     xpath=//*[@id="other-goodsclass_treeul_2_span"]
    Click Element       xpath=//*[@id="other-goodsclass_treeul_2_span"]
    Click Element       css=#layui-layer2 > div.layui-layer-btn > a
    Input Text    xpath=//*[@id="goodscode"]    ${NewGood['goodsNo']} 
    Input Text    xpath=//*[@id="gm-addGoods-div"]/form/table/tbody/tr[5]/td[1]/input     ${NewGood['price']} 
    Input Text    xpath=//*[@id="brandname"]    ${NewGood['brand']}  
    Input Text    xpath=//*[@id="goodsunit"]    ${NewGood['unitName']}  
    Input Text    xpath=//*[@id="gm-addGoods-div"]/form/table/tbody/tr[4]/td[2]/input    ${NewGood['goodModel']}  
    Input Text    xpath=//*[@id="goodsspec"]    ${NewGood['unitName']}  
    Click Element       xpath=//*[@id="layui-layer1"]/div[3]/a[1]
    
Set KuCun
    [Arguments]   ${NewGood}
    Wait Until Page Contains    调整库存
    #Wait Until Element Is Visible     xpath=//*[@id="DataTables_Table_0"]/tbody/tr[1]/td[1]/div/input
    Click Element       xpath=//*[@id="DataTables_Table_0"]/tbody/tr[1]/td[1]/div/input

    Click Element       xpath=//*[@id="level_stock"]
    
    Wait Until Page Contains    增减库存
    Wait Until Element Is Visible     xpath=//*[@id="stockqty"]
    Input Text    xpath=//*[@id="stockqty"]     1000
    
    Wait Until Element Is Visible     xpath=//*[@id="layui-layer7"]/div[3]/a[1]
    Click Element       xpath=//*[@id="layui-layer7"]/div[3]/a[1]
    

ShangJia Good
    [Arguments]   ${NewGood}
    Wait Until Page Contains    上下架列表
    Wait Until Element Is Visible     xpath=//*[@id="sidebar-scroll"]/li[3]/ul/li[4]/a
    Click Element       xpath=//*[@id="sidebar-scroll"]/li[3]/ul/li[4]/a
    
    Wait Until Page Contains    上架
    Wait Until Element Is Visible     xpath=//*[@id="DataTables_Table_2"]/tbody/tr[1]/td[1]/div/ins
    Click Element       xpath=//*[@id="DataTables_Table_2"]/tbody/tr[1]/td[1]/div/ins
    
    Wait Until Element Is Visible     xpath=//*[@id="onGoodscontrolBtn"]
    Click Element       xpath=//*[@id="onGoodscontrolBtn"]
    
    Wait Until Page Contains    确认上架
    Wait Until Element Is Visible     xpath=//*[@id="layui-layer9"]/div[3]/a[1]
    Click Element       xpath=//*[@id="layui-layer9"]/div[3]/a[1]

Open Order
    [Arguments]   ${NewGood}
    Wait Until Page Contains    资源订单管理
    Wait Until Element Is Visible     xpath=//*[@id="sidebar-scroll"]/li[4]/a/span
    Click Element       xpath=//*[@id="sidebar-scroll"]/li[4]/a/span

    Wait Until Page Contains    订单管理
    Wait Until Element Is Visible     xpath=//*[@id="sidebar-scroll"]/li[4]/ul/li/a
    Click Element       xpath=//*[@id="sidebar-scroll"]/li[4]/ul/li/a
    
    
    
    

Select Device Class SheBai
    Wait Until Page Contains    设备类
    Wait Until Element Is Visible     xpath=//*[@id="app"]/div/div[2]/div[2]/ul[1]/li[1]/a/span
    Go To       http://mall.xt.weilian.cn/mobile/#/device/01
    
Select Device Class HaoCai
    Wait Until Page Contains    耗材类
    Wait Until Element Is Visible     xpath=//*[@id="app"]/div/div[2]/div[2]/ul[1]/li[2]
    Click Link       xpath=//*[@id="app"]/div/div[2]/div[2]/ul[1]/li[2]
    
Select Device Class ChangDi
    Wait Until Page Contains    场地类
    Wait Until Element Is Visible     xpath=//*[@id="app"]/div/div[2]/div[2]/ul[1]/li[3]
    Click Link       xpath=//*[@id="app"]/div/div[2]/div[2]/ul[1]/li[3]
    
Select Device Class FuWu
    Wait Until Page Contains    服务类
    Wait Until Element Is Visible     xpath=//*[@id="app"]/div/div[2]/div[2]/ul[1]/li[4]
    Click Link       xpath=//*[@id="app"]/div/div[2]/div[2]/ul[1]/li[4]
    
Select One Device In Class
    #[Arguments]    ${Server}    ${Browser}
    Wait Until Element Is Visible     xpath=//*[@id="app"]/div/div[2]/div[2]/div/ul/li[1]/div/div[1]/img
    Click Element       xpath=//*[@id="app"]/div/div[2]/div[2]/div/ul/li[1]/div/div[2]
  
Submit Order
    Wait Until Element Is Visible     xpath=//*[@id="add_to_car"]
    Click Element       xpath=//*[@id="add_to_car"]
    Wait Until Element Is Visible     xpath=/html/body/div[2]/div/div[2]/button[2]
    Click Button       xpath=/html/body/div[2]/div/div[2]/button[2]


Check Order Log
    Wait Until Page Contains     领用成功
    Wait Until Element Is Visible     xpath=//*[@id="app"]/div/div/p[4]/span
    Click Element       xpath=//*[@id="app"]/div/div/p[4]/span 
   
Check Order DaiFaHuo List
    Wait Until Page Contains     待配发
    Wait Until Element Is Visible     xpath=//*[@id="app"]/div/div[1]/div/ul/li[3]
    Click Element       xpath=//*[@id="app"]/div/div[1]/div/ul/li[3] 

Check Order DaiQueReng List
    Wait Until Page Contains     待确认
    Wait Until Element Is Visible     xpath=//*[@id="app"]/div/div[1]/div/ul/li[4]
    Click Element       xpath=//*[@id="app"]/div/div[1]/div/ul/li[4] 

Check Order Finished List
    Wait Until Page Contains     已完成
    Wait Until Element Is Visible     xpath=//*[@id="app"]/div/div[1]/div/ul/li[5]
    Click Element       xpath=//*[@id="app"]/div/div[1]/div/ul/li[5]
    
        