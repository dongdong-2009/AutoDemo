#!/usr/bin/python
#-*- coding:UTF-8 -*-

'''
#===============================================================================
# Set FTP Client with ftplib to connect the Web Server 
# put the results or logs to log server
# Created on 2017-10-30
# @author: QinXing
#===============================================================================
'''

import os
from ftplib import FTP

class FTPClient(object):

    #Simple FTP Client for upload nmon result file to log server.

    def __init__(self, params):
        pass
    
    def ftp_connection(self,hostname,username,password,timeout=60.0): 
        port = 21
        ftp_client = FTP()
        ftp_client.set_debuglevel(2)
        try:
            ftp_client.connect(hostname,port)
            ftp_client.login(username,password)
        except Exception as e:
            print('*** Caught exception: %s: %s' % (e.__class__, e))
            ftp_client.quit()
            return e
        return  ftp_client
    
    def download_file(self,hostname,username,password,remote_path,local_path):
        bufsize = 1024
        fp = open(local_path,'wb')
        ftp_client = self.ftp_connection(hostname,username,password)
        ftp_client.retrbinary('RETR ' + remote_path,fp.write,bufsize)
        ftp_client.set_debuglevel(0)
        ftp_client.quit()
    
    def upload_file(self,hostname,username,password,remote_path,local_path,filename):
        bufsize = 1024
        ftp_client = self.ftp_connection(hostname,username,password)
        with open(os.path.join(local_path,filename),'rb') as fp:  
            ftp_client.cwd(remote_path)      
            ftp_client.storbinary('STOR '+filename,fp,bufsize)
            ftp_client.set_debuglevel(0)
            ftp_client.quit()
        
if __name__ == "__main__":
    FTPClient(object)
    
    #===========================================================================
    # hostname = '172.19.7.110'
    # local_file = "C:\\Users\\outse\\Downloads\\TestResults.csv"
    # remote_file = "/TesterTools/TestResults.csv"
    # remoteFile = "/TesterTools/nmon/nmon16g_x86_rhel72"
    # localFile = "C:\\Users\\outse\\Downloads\\nmon"
    # ftp = FTPClient(object)
    # ftp.upload_file('127.0.0.1','tools','tools',remote_file,local_file)
    # ftp.download_file('127.0.0.1','tools','tools', remote_path=remoteFile, local_path=localFile)
    #===========================================================================