#!/usr/bin/python
# -*- coding: utf-8 -*-

import unittest
from selenium import webdriver
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.common.by import By
from win32netcon import PASSWORD_EXPIRED
import time

LoginSession = {'UserName':'setest01','UserPasswd':'123456','SessionId':'c64e81e93c044466af14e53f6a8df5e5','browser':'chrome','website':'https://pan.baidu.com/','title':'百度网盘，让美好永远陪伴',}
Testdatas = {'ManagermentTitle':'系统登录','pics':''}
pics= r'C:\2_EclipseWorkspace\mall\project\UI图稿\产品图片整理2017-11-22（压缩）\办公用品类图片\得力白板笔\主图.png'


class OrgSearch(unittest.TestCase):

    def setUp(self):
        #=======================================================================
        # self.browser = LoginSession['browser']
        # self.website = LoginSession['website']
        # self.title = LoginSession['title']
        # self.UserName = LoginSession['UserName']
        # self.UserPasswd = LoginSession['UserPasswd']
        #=======================================================================
        self.driver = webdriver.Chrome()
        self.driver.implicitly_wait(15)
        
    def test_open_new_website(self):
        self.driver.get(LoginSession['website'])
        self.driver.maximize_window()
        self.assertIn(LoginSession['title'], self.driver.title)
        wait = WebDriverWait(self.driver,10)
        wait.until(EC.visibility_of_element_located((By.XPATH,'//*[@id="TANGRAM__PSP_4__footerULoginBtn')))        
        self.driver.find_element_by_xpath('//*[@id="TANGRAM__PSP_4__footerULoginBtn"]').click()
        self.driver.find_element_by_xpath('//*[@id="TANGRAM__PSP_4__userName"]').send_keys("seadmin")
        self.driver.find_element_by_xpath('//*[@id="TANGRAM__PSP_4__password"]').send_keys("123456")
        self.driver.find_element_by_xpath('//*[@id="TANGRAM__PSP_4__submit"]').submit()
        
    #===========================================================================
    #     
    # def test_sign_in(self):
    #     #driver = self.driver
    #     
    #     self.driver.find_elements_by_xpath('//*[@id="login-username"]').send_keys("seadmin")
    #     self.driver.find_elements_by_xpath('//*[@id="login-password"]').send_keys("123456")
    #     self.driver.find_elements_by_xpath('//*[@id="form-login"]/div[4]/div/button').submit()
    #      
    # def test_good_managerment(self):
    #     driver = self.driver
    #     driver.find_elements_by_xpath('//*[@id="sidebar-scroll"]/li[2]/a/span').click()
    #      
    #     driver.find_elements_by_xpath('//*[@id="sidebar-scroll"]/li[2]/ul/li[1]/a').click()
    #      
    #     driver.find_elements_by_xpath('//*[@id="goods-manage-table"]/div/div/div/div[1]/div[2]/a[1]').click()
    #      
    #     assert "资源商城管理平台" not in self.driver.page_source
    #===========================================================================
    def tearDown(self):     
        self.driver.close()


def testSuite():
    suite = unittest.TestSuite()
    #suite.addTest(OrgSearch("test_open_new_website"))
    #suite.addTest(OrgSearch("test_sign_in"))
    return suite

if __name__ == "__main__":
    unittest.main()
    
    #===========================================================================
    # runner = unittest.TextTestRunner()
    # runner.run(testSuite())
    #===========================================================================

    
    