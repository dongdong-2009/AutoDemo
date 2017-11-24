#!/usr/bin/python
#-*- coding:UTF-8 -*-

"""
   Use configparser to auto modify the config_xx.ini [Config] session arguments:product,pre_version,cur_previous
   [Config]
    product=dev1,aut2
    pre_version=123
    cur_previous=456
    include=
    exclude=
    suite=
    test=
    
   At first ,the variable of the testsuites will be set at the tester.py or other settings file;
   Be sure,the configuration path or testsuites is relative path,keep it unique alive in the system. 
   This is a example module,For example:
   >>> ConfigSetup().configer(conf_path="D:\\autotest\\autotest2.0\\run\settings",\
                               conf_list=["config_std_system.ini","config_tmp.ini"],\
                               conf_idlelist=["config_std_system.ini",],\
                               fw_version="456",\
                               fw_previous="1231",\
                               dut_list={'dut':['dev1'],'aut':['aut1']})
   config_tmp.ini reset configuration ok.
   
   Created on 2017年11月22日

   @author: outse
"""


import configparser
import os
import re

class ConfigSetup:
    def __init__(self):
        pass
    
    def get_sections(self,confPath):
        confSecs = configparser.Safeconfigparser()
        
        try:
            confSecs.read(confPath)
        except IOError as er:
            raise "There is no configuration file ! %s \n" % (er)
        return confSecs
    
    def save_sections(self,sections,confPath):
        try:
            with open(confPath,'w') as tmpConf:
                sections.write(tmpConf)
                tmpConf.flush()
        except IOError as er:
            print("There is no configuration file ! %s \n" % (er))
            
    def disable_dev(self,devName,disable="1",devConfPath="config ini path"):
        confDev = self.get_sections(devConfPath)
        for dcf in confDev.sections():
            if devName in dcf:
                if not confDev.getboolean(devName,"DISABLE"):
                    confDev.set(dcf,"DISABLE",disable)
        self.save_sections(confDev,devConfPath)

    def select_config(self,confPath,confList,confIdlelist):
        scripterList = []   
        for cf in range(0,len(confList)):
            if confList[cf] not in confIdlelist:
                    scripterList.append(os.path.join(confPath,confList[cf]))
        return scripterList

    def test_suiter(self,cfPath):
        suitesList = []
        sortTests = []
        testSuiter = self.get_sections(cfPath)
        for scf in testSuiter.sections():
            if "Test" in scf:
                for ops in testSuiter.options(testSuiter.sections()[testSuiter.sections().index(scf)]):
                    if "#" not in ops:
                        sortTests.append(ops)
                sortTests.sort()
                for sor in sortTests:    
                    suitesList.append(os.path.join(os.path.dirname(cfPath),testSuiter.get("Test",sor)))
        return suitesList
    
    def set_conf(self,paths,fw_version,fw_previous,devs):
        setConf = self.get_sections(paths)
        for scf in setConf.sections():
            if "Config" in scf:
                for ops in setConf.options(setConf.sections()[setConf.sections().index(scf)]):
                    if "fw_version" in ops:
                        if fw_version not in setConf.get("Config","fw_version"):
                            setConf.set("Config","fw_version",fw_version)
                    elif "product" in ops:
                        if (re.search('S|sytem',os.path.basename(paths))) or (re.search('U|update',os.path.basename(paths))):
                            setConf.set("Config","product",','.join(devs.get('dut') + devs.get('aut')))
                        else:
                            setConf.set("Config","product",','.join(devs.get('dut')))
                    elif "fw_previous" in ops:
                        if fw_previous not in setConf.get("Config","fw_previous"):
                            setConf.set("Config","fw_previous",fw_previous)
                    else:
                        continue 
                self.save_sections(setConf, paths)
                    
    def configer(self,conf_path,conf_list,conf_idlelist,fw_version,fw_previous,dut_list):
        confList = self.select_config(conf_path,conf_list,conf_idlelist)
        for confs in confList:
            self.set_conf(confs,fw_version,fw_previous,dut_list)
            print("Edit %s with test arguments ok." % (os.path.basename(confs))) 
       
if __name__ == '__main__':
    import doctest
    doctest.testmod() 
    ConfigSetup()
