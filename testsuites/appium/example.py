#!/usr/bin/env python
# -*- coding:utf-8 -*-
"""
This is a example for learn how to use appium test Android app
Copy from the appium gihub 
Editor: banrieen
"""



#Android environment
import unittest
from appium import webdriver


desired_caps = {}
desired_caps['platformName'] = 'Android'
desired_caps['platformVersion'] = '7.1'
desired_caps['deviceName'] = 'Android Emulator'
desired_caps['app'] = PATH('../../../apps/selendroid-test-app.apk')

self.driver = webdriver.Remote('htt://localhost:4723/wd/hub',desired_caps)

#Ios environment
import unittest
desired_caps = {}
desired_caps['platformName'] = 'iOS'
desired_caps['platformVersion'] = '7.1'
desired_caps['deviceName'] = 'iPhone Emulator'
desired_caps['app'] = PATH('../../../apps/UICatalog-app.zip')

self.driver = webdriver.Remote('htt://localhost:4723/wd/hub',desired_caps)
