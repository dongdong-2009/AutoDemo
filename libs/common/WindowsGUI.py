#! /usr/bin python
# -*- coding utf-8 -*- 

'''
Created on 2018年2月6日

@author: outse

This is the example for this module
#>>>
#
#...
'''
   

from pywinauto.application import Application
from subprocess import Popen
from pywinauto import Desktop

#===============================================================================
# Popen('calc.exe', shell=True)
# dlg = Desktop(backend="uia").Calculator
# dlg.wait('visible')
#===============================================================================

class WindowsGui(object):
    
    def __init__(self):
        
        pass
    
    def connect_current_window(self):
        app = Application().connect(path = r"C:\Windows\explorer.exe")
        #dlg = app.top_window_()
        app["File Explorer"].maximize()
        #app.connect(process = 9276)
        
        #windows = app.WindowSpecification
        
if __name__ == '__main__':
    import doctest
    #doctest.testmod()
    connect_current_window()
            