#!/usr/bin/python
#-*- coding utf-8 -*-

"""
读取device_list.ini,获取其中的设备名称和ip
通过ping，urllib2.urlopen()检查设备列表的状态
第一个状态值为ping status，第二个状态值为urlopen status
Created on 2017年11月28日

@author: outse
"""


import os
import threading
import cProfile
import configparser
import random
import urllib2
import time

class threadsRun(threading.Thread):
    threadLock = threading.Lock()
    def __init__(self,DevIP,resultList,timeout):
        threading.Thread.__init__(self)
        self.DevIP = DevIP
        self.resultList = resultList
        self.pingTimeout = timeout
        

    def run(self):
        self.ping_time(self.DevIP,self.resultList,self.pingTimeout)
        
    def ping_time(self,hosts,resultList,timeout):
        rst = []
        if not os.system("ping " + hosts + " -w 1"):
            if self.check_url_be_open(hosts,resultList):
                rst=["ON","ON"]
            else:
                rst=["ON","OFF"]
        else:
            rst=["OFF","OFF"]
        self.threadLock.acquire()
        resultList[hosts] = rst
        self.threadLock.release()
        return resultList
    
    def check_url_be_open(self, hosts, resultList,retry=12,timeout=3):
        URL_OPEN = 0  
        for try_time in range(int(retry)):
            try:
                urlop = urllib2.urlopen("http://" + str(hosts), str(timeout))
                urlop.close()          
                return True
            except urllib2.HTTPError as e:
                print(urllib2.HTTPError,e.code,hosts)
                URL_OPEN += 1
            except urllib2.URLError as e:
                print(urllib2.URLError,e.args,hosts)
                URL_OPEN += 1
            time.sleep(random.randint(timeout * (URL_OPEN - 1),(timeout * URL_OPEN))/2)
        if URL_OPEN:
            return False

class devicesStatus:    
    def print_reslut(self,devices,resultList):
            result = []
            sorted(devices)
            for ips in [keys for (keys, values) in sorted(devices.items())]:
                if ips not in broken_devices.keys():
                    print ("Dev: {:<20} IP: {:<20} Ping_WebStatus: {:<20} \n".format(ips ,devices[ips],resultList[devices[ips]]))
                
    def product_ipaddress(self,pro_mac):
        ip = int(pro_mac.split(':')[5], 16)
        if ip >=0 and ip <=4:
            ip+=160
        return "192.168.99." + str(ip)
    
    def devIplist(self,devicePath):
        if not os.path.isfile(devicePath):
            raise IOError("The Device file is not exist !")
        deviceSecs = configparser.ConfigParser()
        deviceSecs.read(devicesPath)
        secs = deviceSecs.sections()
        devIps = {}
        for sec  in secs:
            devIps[sec] = self.product_ipaddress(deviceSecs.get(sec,'mac'))
        #print devIps
        return devIps
    
    def thread_runner(self,devices,timeout):
        resultList = {devices[keys]:"" for keys in devices.keys()}
        threads = []
        for ips in devices.keys():
        #pdb.set_trace()
            if ips not in broken_devices.keys():
                threadNew = threadsRun(devices[ips],resultList,timeout)
                threadNew.start()
                threads.append(threadNew)
        for thr in threads:
            thr.join()
        print ("\n" + "*"*25 + " The Device Status " + "*"*25 )
        self.print_reslut(devices,resultList)        
    
if __name__ == '__main__':
    #Devices is broken or be remobed,add it to broken_devices list
    broken_devices = {
                      'abc_123':'192.168.99.168',
                      'localhost':'127.0.0.1',
                      'win_host':'169.165.0.1'}
    devicesPath = '.／devices.ini' 
    devices = devicesStatus().devIplist(devicesPath)
    ds = devicesStatus()
    ds.thread_runner(devices,timeout=500)

