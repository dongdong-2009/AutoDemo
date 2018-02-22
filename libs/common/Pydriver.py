#!/usr/bin/env python
# -*- coding: utf-8 -*-
'''
Created on 2018年2月7日

@author: outse
'''

from selenium import webdriver
#from selenium.webdriver.comon.keys import Keys
from pywinauto.application import Application
from pywinauto import Desktop

class pydriver(object):
    
    def __init__(self):
        pass
    
    def open_new_browser(self,browser_name):
        if 'firefox' in browser_name: 
            new_browser = webdriver.Firefox()   
        elif ('ie' in browser_name or 'IE' in browser_name ):
            new_browser = webdriver.Ie()
        elif 'safari' in browser_name:
            new_browser = webdriver.Safari()
        else:
            new_browser = webdriver.Chrome()
        
        return new_browser
    
    def go_to_pages(self,browser_handle, url):
        browser_handle.get(url)
        
    def assert_title(self,browser_handle,title_string):
        assert title_string in browser_handle.title
    
    def click_by_TagPosition(self,browser_handle,tag,position):
        if 'id' in tag:
            browser_handle.find_element_by_id(position)
        elif 'link' in tag:
            browser_handle.find_element_by_link_text(position)
        elif 'name' in tag:
            browser_handle.find_element_by_name(position)
        elif 'css' in tag:
            browser_handle.find_element_by_css_selector(position)
        elif 'class' in tag:
            browser_handle.find_element_by_class_name(position)
        else:
            return None
        return True
          
    def get_windows_handle(self,browser_handle):
        WindowsHandle = browser_handle.GetWindow()
        return WindowsHandle 
    
    def select_file_in_windows_explorer(self,file,WindowsHandle):
        
        pass

    

if __name__ == '__main__':
    new_browser = pydriver()

    
    
    