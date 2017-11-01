#! /usr/bin/env python
# -*- coding: UTF-8 -*-
"""
   This is Selenium & Webdriver for firefox Common Api example
   Editor: Qinxing
   Date: 2017-10-10
"""


from selenium import webdriver
from selenium.webdriver.common.keys import Keys
import time
import unittest
from selenium.webdriver.common.action_chains import ActionChains

class Firefox_common(unittest.TestCase):

    ROBOT_LIBRARY_VERSION = 1.0
    values = 0
    urls='http://xpomg.weilian.cn/omj/index.html'
    
    xiangpuUrl = '//*[@id="kaijitupian-one-id"]/img'
    paths = '//*[@id="kaijitupian-one-id"]'

    def openFirefox(self,urls):
        #tmp url: 'http://xpomg.weilian.cn/omj/index.html'
        self.browser = webdriver.Firefox()
        self.browser.get(urls)
        print (self.browser.title)
        assert '登录页面'.decode('utf-8') in self.browser.title
        
    def executeActions(self,paths,values):
        elem = self.browser.find_element_by_xpath(paths) 
        elem.send_keys(values,Keys.RETURN)
        
    def GoToPagesByClickElement(self,paths):
        elem = self.browser.find_element_by_css_selector(paths)
        actions = ActionChains(self.browser)
        actions.click(elem)
        
    def setUP(self):
        self.openFirefox(urls)
        
    def teardown(self):
        self.browser.quit()
        
    def testLogin(self):
        self.openFirefox("http://xpomg.weilian.cn/omj/index.html")
        self.GoToPagesByClickElement('#kaijitupian-one-id > img')  ##Go To xiangpu
        self.GoToPagesByClickElement('#author-password > img')  ##Go To Login
        self.executeActions('//*[@id="account"]',"qinxing@suneee.com") ##Input username
        self.executeActions('//*[@id="password"]','123456') ##Input password
        self.executeActions('//*[@id="btn"]')   
    
if __name__ == "__main__":
    unittest.main()


