#!/usr/bin/python
#-*- coding:UTF-8 -*-

#===============================================================================
# """
#    Use configparser to read or modify the xxx.conf：
#    [Config]
#     product=dev1,aut2
#     pre_version=123
#     cur_previous=456
#     include=
#     exclude=
#     suite=
#     test=
#     
#    At first ,the variable of the testsuites will be set at the tester.py or other settings file;
#    Be sure,the configuration path or testsuites is relative path,keep it unique alive in the system. 
#    This is a example module,For example:
#    >>> ConfigSetup().configer(conf_path="C:\2_EclipseWorkspace\xtcAuto\resources",\
#                                conf_list=["ZYSC_Plan.conf",],\
#                                conf_idlelist=["config_std_system.ini",],\
#                                fw_version="version1",\
#                                fw_previous="version2",\
#                                dut_list={'dut':['dev1'],'aut':['aut1']})
#    config_tmp.ini reset configuration ok.
#    
#    Created on 2017年11月22日
# 
#    @author: outse
#      
# """
#===============================================================================


import configparser
import os
import re
from _overlapped import NULL

class ConfigSetup:
    def __init__(self):
        pass
    
    def read_conf(self,confPath):
        if not os.path.isfile(confPath):
            return None
        conf = configparser.ConfigParser()
        try:
            conf.read(confPath)
        except IOError as er:
            raise "There is no configuration file ! %s \n" % (er)
        
        for cf in conf.sections():
            print(cf) 
        return conf
    
    def select_section(self,conf,tag):
        if not conf:
            return None
        for sec in  conf.sections():
            if re.match(tag , sec):
                print(sec)
                return sec
        return None
    
    def select_option(self,conf,sec,tag):
        if not sec:
            return None
        for opn in  conf.options():
            if re.match(tag , opn):
                print(opn)
                return opn
        return None
    
    def get_option_value(self,conf,sec,opn):
        if opn:
            return conf.get(sec,opn)
        return None
    
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
    #===========================================================================
    # import doctest
    # doctest.testmod() 
    # ConfigSetup()
    #===========================================================================
    
    confPath = r"C:\2_EclipseWorkspace\xtcAuto\testplan\ZYSC_Plan.conf"
    cs = ConfigSetup()
    print(cs.get_sections(confPath))
