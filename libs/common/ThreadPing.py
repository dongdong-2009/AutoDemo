'''
多线程扫描网段或检查多个设备的IP状态
Created on 2018年1月25日
@author: QinXing
'''

import os
import sys

class ThreadPing(object):
    '''
    classdocs
    '''


    def __init__(self, params):
        '''
        Constructor
        '''
        self.PythonVersion = sys.version_info[0]
        self.SystemPlatform = os.name
        self.Iplist = params
        pass
    
    def ping(self,IpStr):
        try:
            if("nt" in self.SystemPlatform):
                return os.system("ping %s -n 4 -w 1"%(IpStr))   
            else:
                return os.system("ping %s -n 4 -w 1"%(IpStr))
            
          
        except IOError as err:
            return  err

            
    