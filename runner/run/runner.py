#!/usr/bin/python
# -*- coding: utf-8 -*-

"""
    Use python Subprocess.Popen excute testsuites as backgroud issue;
    Put config_xx.ini in the serial sessions to be run one by one;
    Use Configsetup module set testsuites variable:fw_version, fw_previous,duts; 
    Then the report about the configPlan would be output by every config_xx.ini。 

    Created on 2017年11月22日
    
    @author: outse

"""

import os,time
import subprocess 
import pdb
from common.ConfiguraitonParser import ConfigSetup
import json
import re

Execute_host = "172.19.5.179"
fw_version = "version1"
fw_previous = "version2"
dut_list = {'dut':['dev1','dev2','dev3','dev4','dev5','dev6'],'aut':[]} #dut: devices under test,aut:assist devices for dut
currentDut_list = {'dut':['dev1','dev2',],'aut':['aut1','aut2']}
executer =  os.path.join(os.path.dirname(os.path.abspath(__file__)),"runner.py")


finished_conf = r"..\..\..\output\finished_list.log"
conf_list = ["tmp_Plan.conf",
             "ZYSC_CI_Plan.conf",
             "ZYSC_Full_Plan.conf",
             "ZYSC_Min_Plan.conf"          
             ]
conf_idlelist = [
            "tmp_Plan.conf",
            "ZYSC_Std_Plan.conf",        
              ]

class TestEachModule():
    def __init__(self):
        self.finished_list = []
        self.fail_list = []
        self._Execute_host = Execute_host
        self.processPool = str(8)
        self.testPlan_name = re.sub(' ','-',"".join(fw_version.split('.')))
    
    def finisherLog(self,finished_conf,finished_list):
        if len(finished_list): 
            with open(finished_conf,"w") as fin:
                fin.writelines(finished_list)
                fin.flush()
    def auto_deployThreadingpool(self):
        duts_count = len(dut_list["dut"])    
        if duts_count <= (len(currentDut_list)/2):
            self.processPool = str(duts_count * 2)
        else:
            self.processPool = str(duts_count)
       
    def getFinishedList(self):
        if os.path.isfile(finished_conf):
            with open(finished_conf,"r") as fin:
                finished_list = fin.readlines()
            return finished_list
        else:
            print ("Finished list is None")
            return None
    
    def runer(self,executer,finished_list=[]):
        issue_confs = ConfigSetup().select_config(conf_path,conf_list,conf_idlelist)
        fail_list = []
        self.auto_deployThreadingpool()
        if len(issue_confs):
            for cf in range(0,len(issue_confs)):
                #pdb.set_trace()
                Exec_Flag = None
                testrunner = subprocess.Popen(["python ", executer, issue_confs[cf],self.testPlan_name,self._Execute_host,self.processPool] ,bufsize=4096,startupinfo=subprocess.CREATE_NEW_PROCESS_GROUP)
                while Exec_Flag is None:
                    Exec_Flag = testrunner.poll()
                    time.sleep(0.1)
                if Exec_Flag is 0:
                    self.finished_list.append(issue_confs[cf] + ': PASS \n')
                else:
                    self.fail_list.append(issue_confs[cf])
            
            if len(self.fail_list):
                for fail_cf in range(0,len(self.fail_list)):
                    Exec_Flag = None
                    elapsed = 0
                    re_runner = subprocess.Popen(["python ", executer, self.fail_list[fail_cf]])
                    while Exec_Flag is None:
                        Exec_Flag = re_runner.poll()
                        time.sleep(0.1)
                        elapsed += 1 
            else:
                print ("--------------------------------------------------- All testsuites have finished !") 


class TestAllOnce():
    """
    The simple runner to for one config_xx.ini 
    config_ini = "config_std_AllInOne.ini"
    OneRunner = TestAllOnce(os.path.join(conf_path,config_ini))
    OneRunner.runer(executer)
    
    If use configParser to set variable such as frimware and devices,just add the config_xx.ini in the conf_list and conf-idlelist above;then call
    ConfigSetup().configer(conf_path,conf_list,conf_idlelist,fw_version,fw_previous,dut_list)
    """
    def __init__(self,config_ini):
        self.finished_list = []
        self.fail_list = []
        self.testsuites_config = config_ini
        pass

    def runer(self,executer,finished_list=[]):
        testrunner = subprocess.Popen(["python ", executer, self.testsuites_config],bufsize=4096)
        Exec_Flag = None
        while Exec_Flag is None:
            Exec_Flag = testrunner.poll()
            time.sleep(0.1)
        print "--------------------------------------------------- All testcases have finished !" 

            
if __name__ == "__main__":
    ConfigSetup().configer(conf_path,conf_list,conf_idlelist,fw_version,fw_previous,dut_list)
    runner = TestEachModule()
    runner.runer(executer) 

                  
