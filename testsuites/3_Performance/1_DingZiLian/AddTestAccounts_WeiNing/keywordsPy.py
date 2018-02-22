#!/usr/bin/env python
# -*- coding: utf-8 -*-

import random
import string
import os


"""
Creak fake user for Add User robot
"""

class keywordsPy(object):

    ROBOT_LIBRARY_VERSION = 1.0

    def __init__(self):
        pass

    def fake_accountname(self,basename,index):
        return basename + str(index)
    
    def fake_fullname(self,basename,index):
        return basename + str(index)
        
    def fake_mobilenno(self):
        return random.choice(['139','188','185','136','158','151'])+"".join(random.choice("0123456789") for i in range(8))
    
    def fake_email(self,basename,index):
        return basename + str(index) + '@suneee.com'
    
    def fake_staff_no(self,preno,index):
        return 'SE' + str(preno + index)
    
    def fake_identification(self,size=18):
        return ''.join(random.choice(string.digits) for n in range(size)) 

    def fake_attendno(self,preno,index):
        return  str(preno + index)
    
    def fake_alias(self,basename,index):
        return basename + str(index)
    
    def correct_type(self,item):
        if isinstance(item, int):
            return str(item)
        
    def new_index_list(self,count):
        return [x for x in range(int(count))]
    
    def get_index_real_data(self,data):
        return str(data)
    
    def fake_account(self,basename,preno,index=0,data_file_name = "fake_account.csv"):
        tmp_account = {}
        tmp_account['account'] = self.fake_accountname(basename, index)
        tmp_account['password'] = '123456'
        tmp_account['fullname'] = self.fake_fullname(basename, index)
        tmp_account['mobileNo'] = self.fake_mobilenno()
        tmp_account['email'] = self.fake_email(basename, index)
        tmp_account['staff_no'] = self.fake_staff_no(preno, index)
        tmp_account['identification'] = self.fake_identification(18)
        tmp_account['attend_no'] = self.fake_attendno(preno, index)
        tmp_account['alias'] = self.fake_alias(basename, index)
        
        with open(os.path.join(os.path.abspath(r"testsuites/3_Performance/1_DingZiLian/Data/"),data_file_name),'a') as fd:
            fd.write(tmp_account['account'] + ',' + tmp_account['password'] + "\n")
        return tmp_account

    def check_account(self,basename,preno,index=0):
        tmp_account = {}
        tmp_account['account'] = self.fake_accountname(basename, index)
        tmp_account['password'] = '123456'
        tmp_account['fullname'] = self.fake_fullname(basename, index)
        tmp_account['mobileNo'] = self.fake_mobilenno()
        tmp_account['email'] = self.fake_email(basename, index)
        tmp_account['staff_no'] = self.fake_staff_no(preno, index)
        tmp_account['identification'] = self.fake_identification(18)
        tmp_account['attend_no'] = self.fake_attendno(preno, index)
        tmp_account['alias'] = self.fake_alias(basename, index)
        return tmp_account
    
if __name__ == "__main__":
    fc = keywordsPy()
    #===========================================================================
    # basename = "xtcAuto"
    # preno = 6000
    # index = 14
    # fc.fake_account(basename,preno,index,data_file_name = "")
    #===========================================================================
        
        