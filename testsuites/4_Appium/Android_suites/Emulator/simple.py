#!/usr/bin/python
#-*- coding:UTF-8 -*-

'''
Created on 2018年3月8日

@author: outse
'''
import unittest
from appium import webdriver
from appium.webdriver.common.mobileby import MobileBy
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
import time

userName = "abc"
accessKey = "123"



#===============================================================================
# desired_caps = {}
# desired_caps['platformName'] = 'Android'
# desired_caps['platformVersion'] = '7.0'
# desired_caps['deviceName'] = 'Android Emulator'
# desired_caps['app'] = PATH('../../apps/test.app.zip')
# 
# self.driver = webdriver.Remote('http://localhost:4273/wd/hub',desired_caps)
# 
# # Switch windows to webviewer,
# current = driver.current_context()
# context_name = 'WEBView_1'
# driver.switch_to.context(context_name)
#===============================================================================

desired_caps = {
    "build": "Python Android",
    "device": "Samsung Galaxy S8 Plus",
    "app": "bs://<hashed app-id>"
}
 
driver = webdriver.Remote("http://" + userName + ":" + accessKey + "@hub-cloud.browserstack.com/wd/hub", desired_caps)
 
search_element = WebDriverWait(driver, 30).until(
    EC.element_to_be_clickable((MobileBy.ACCESSIBILITY_ID, "Search Wikipedia"))
)
search_element.click()
 
search_input = WebDriverWait(driver, 30).until(
    EC.element_to_be_clickable((MobileBy.ID, "org.wikipedia.alpha:id/search_src_text"))
)
search_input.send_keys("BrowserStack")
time.sleep(5)
 
search_results = driver.find_elements_by_class_name("android.widget.TextView")
assert(len(search_results) > 0)
 
driver.quit()

#===============================================================================
# class Test(unittest.TestCase):
# 
# 
#     def setUp(self):
#         pass
# 
# 
#     def tearDown(self):
#         pass
# 
# 
#     def testName(self):
#         pass
# 
# 
# if __name__ == "__main__":
#     #import sys;sys.argv = ['', 'Test.testName']
#     unittest.main()
#===============================================================================