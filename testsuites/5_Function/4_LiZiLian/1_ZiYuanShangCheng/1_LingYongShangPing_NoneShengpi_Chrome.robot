*** Settings ***
Documentation     使用谷歌浏览器测试资源商城前台业务.
...               选择分来商品->确认商品详情->确认领用->领用进度查询
...

Library           fakegoods.py
Library           RequestsLibrary
Library           Collections
Resource          keywords.robot

Force Tags      tid-4-1-1     owner-QinXing

*** Variable ***
${DELAY}    0.1
${UserName}    setest01
${UserPasswd}   123456
${Title}     资源商城
${Managerment Title}     系统登录
${Browser}        chrome
${Server}         http://mall.xt.weilian.cn/mobile/#/main/home
${Managerment Server}            http://system-rest-enterprise.mall.xt.weilian.cn
${SessionId}      c64e81e93c044466af14e53f6a8df5e5

${pics}      C:\2_EclipseWorkspace\mall\project\UI图稿\产品图片整理2017-11-22（压缩）\办公用品类图片\得力白板笔\主图.png

*** Test Cases ***
Login ZYSC CMS
    Open Browser To Login Page     ${Managerment Server}     ${Browser}     ${DELAY}
    Title Should Be        ${Managerment Title}
    Input Text        xpath = //*[@id="login-username"]     ${UserName}
    Input Text        xpath = //*[@id="login-password"]     ${UserPasswd}
    Submit Credentials    xpath = //*[@id="form-login"]/div[4]/div/button
    
Manager Goods
    Open Goods Info In CMS
    ${NewGood} =    Fake Goods         设备名称        设备类
    Log     ${NewGood}
    New Good Info In CMS    ${NewGood}
    Upload Goods Pictures
    Submit New Good Info
    #Set KuCun    ${NewGood}
    #ShangJia Good    ${NewGood}
    
Clean ENV 
    Sleep    50
    Close All Browsers

*** Keywords ***
Open Goods Info In CMS
    Wait Until Page Contains    资产管理
    Wait Until Element Is Visible     xpath=//*[@id="sidebar-scroll"]/li[1]/a
    Click Element       xpath=//*[@id="sidebar-scroll"]/li[1]/a
    Wait Until Page Contains    资产信息
    Wait Until Element Is Visible     xpath=//*[@id="sidebar-scroll"]/li[1]/ul/li[1]/a
    Click Element       xpath=//*[@id="sidebar-scroll"]/li[1]/ul/li[1]/a
    
    Wait Until Page Contains    新增
    Wait Until Element Is Visible     xpath=//*[@id="goods-manage-table"]/div/div/div/div[1]/div[2]/a[1]
    Click Element       xpath=//*[@id="goods-manage-table"]/div/div/div/div[1]/div[2]/a[1]
    
New Good Info In CMS    
    [Arguments]   ${NewGood}
    Wait Until Page Contains    资产名称
    Input Text    xpath=//*[@id="goodsname"]    ${NewGood['goodsName']}
    
    Wait Until Page Contains    资产分类
    Click Element       xpath=//*[@id="gm-addGoods-div"]/form/table/tbody/tr[3]/td[1]/input[4]
    Wait Until Element Is Visible     xpath=//*[@id="other-goodsclass_treeul_2_span"]
    Click Element       xpath=//*[@id="other-goodsclass_treeul_2_span"]
    Click Element       css=#layui-layer2 > div.layui-layer-btn > a
    
    Wait Until Page Contains    资产ID
    Wait Until Page Contains    状态
    Select From List By Value    xpath = //*[@id="status"]    1
    
    Wait Until Page Contains    资产规格
    Input Text    xpath = //*[@id="goodsspec"]    ${NewGood['goodSize']} 
    
    Wait Until Page Contains    资产型号
    Input Text    xpath = //*[@id="gm-addGoods-div"]/form/table/tbody/tr[4]/td[2]/input    ${NewGood['goodModel']}  
    
    Wait Until Page Contains    资产价格
    Input Text    xpath = //*[@id="baseprice"]     ${NewGood['price']} 
    
    Wait Until Page Contains    计量单位
    Input Text    xpath = //*[@id="goodsunit"]    ${NewGood['unitName']}  
    
    Wait Until Page Contains    品牌
    Input Text    xpath = //*[@id="brandname"]    ${NewGood['brand']}  
    Sleep    2
    Run Keyword And Ignore Error     Click Element    xpath = //*[@id="bigAutocompleteContent"]/table/tbody/tr/td[1]/div
    
    Wait Until Page Contains    财务编码
    Input Text    xpath = //*[@id="gm-addGoods-div"]/form/table/tbody/tr[6]/td[2]/input      ${NewGood['AccountNo']}
    
    Wait Until Page Contains    流程类型
    Select From List By Label    xpath = //*[@id="approvaltypeid"]    ${NewGood['goodOAFlow']}
    
    Wait Until Page Contains    资产归属部门
    Select From List By Label    xpath = //*[@id="gsbmid"]    ${NewGood['goodDepartment']}
    
    Wait Until Page Contains    资产等级
    Select From List By Label    xpath = //*[@id="goodslevelid"]    ${NewGood['goodIndex']}
    
    Wait Until Page Contains    关联角色
    Wait Until Page Contains    登记人
    Wait Until Page Contains    登记时间
    
    Wait Until Page Contains    资产主图上传
    Wait Until Page Contains    资产基本图片上传
    Wait Until Page Contains    资产详情

Submit New Good Info    
    Wait Until Page Contains    确定
    Click Element       xpath = //*[@id="layui-layer1"]/div[3]/a[1]

Upload Goods Pictures
    Run Keyword And Ignore Error    Click Element    xpath = //*[@id="layui-layer1"]/span[1]/a[2]
    Wait Until Page Contains    资产主图上传
    Click Element    xpath = //*[@id="upload2"]/div
    Input Text    xpath = //*[@id="upload2"]/div       ${pics}
    #${goodpics} =    Create Session    http://cms.mall.xt.weilian.cn/upload
    Wait Until Page Contains    资产基本图片上传
    
Add Goods Info
    Wait Until Page Contains    资产详情
    
    
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
    
        