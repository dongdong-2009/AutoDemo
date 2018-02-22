#!/usr/bin/python
#-*- coding:UTF-8 -*-

"""
#===============================================================================
# After Jmeter, nmon test finished, we will zip the temp results dir as "TestCaseNameTimeString.zip"
# It is easy to upload zip on LogServer
#===============================================================================
"""

import zipfile
from ftplib import FTP
import os
import shutil
import time 
from fileinput import filename
from test.test_modulefinder import package_test
import ast

class PackageReport(object):
    def __init__(self):
        pass
    
    def zip(self,src):
        zf = zipfile.ZipFile("%s.zip" % (src), "w", zipfile.ZIP_DEFLATED)
        abs_src = os.path.abspath(src)
        for dirname, subdirs, files in os.walk(src):
            for filename in files:
                absname = os.path.abspath(os.path.join(dirname, filename))
                arcname = absname[len(abs_src) + 1:]
                zf.write(absname, arcname)
        zf.close()
    
    def clean_folder(self,FolderPath):
        try:
            for fds in os.listdir(FolderPath):
                temp = os.path.join(FolderPath,fds)
                if os.path.isfile(temp):
                    os.remove(temp)
                if os.path.isdir(temp):
                    shutil.rmtree(temp)
        except BaseException as e:
            print ('*** clean_folder Caught exception: %s: %s' % (e.__class__, e))
        
    def copy_result(self,OutPutDir,TestCaseName):
        TestCaseName = TestCaseName + time.strftime("%I%M%S")
        PackageDir = os.path.join(OutPutDir,TestCaseName)
        if not os.path.isdir(PackageDir):
            os.mkdir(PackageDir)
        TempDir = os.path.join(OutPutDir,"TempReport")
        for root,folders,files in os.walk(TempDir):
            for fi in files:
                if '.jtl' in os.path.splitext(fi):
                    shutil.copyfile(os.path.join(TempDir,fi), os.path.join(PackageDir,fi))
            for fdi in folders:          
                if "NmonReport" in fdi:
                    shutil.copytree(os.path.join(TempDir,fdi), os.path.join(PackageDir,fdi))
                if "JmeterReport" in fdi:
                    shutil.copytree(os.path.join(TempDir,fdi), os.path.join(PackageDir,fdi))
        return  TestCaseName  
    
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
    
    def upload_file(self,hostname,username,password,remote_path,local_path,filename):
        bufsize = 1024
        ftp_client = self.ftp_connection(hostname,username,password)
        with open(os.path.join(local_path,filename),'rb') as fp:  
            ftp_client.cwd(remote_path)      
            ftp_client.storbinary('STOR '+filename,fp,bufsize)
            ftp_client.set_debuglevel(0)
            ftp_client.quit()
        
    def clean_env(self,TempResult):
        try:
            #===================================================================
            # TempFolder = os.path.join(OutPutDir,"TempReport")
            # for fds in os.listdir(TempFolder):
            #     temp = os.path.join(TempFolder,fds)
            #     if os.path.isfile(temp):
            #         os.remove(temp)
            #     else:
            #         self.clean_folder(temp)
            #===================================================================
            if os.path.isdir(TempResult):
                shutil.rmtree(TempResult,True)
        except Exception as e:
            print ('*** clear_env Caught exception: %s: %s' % (e.__class__, e))  
            
    def package_upload_result(self,OutPutDir,TestCaseName,ftphost,ftpuser,ftppwd,remote_path):
        ResltFolder = self.copy_result(OutPutDir,TestCaseName)
        self.zip(os.path.join(OutPutDir,ResltFolder))
        self.upload_file(ftphost, ftpuser, ftppwd, remote_path, OutPutDir, ResltFolder + ".zip")
        self.clean_env(os.path.join(OutPutDir,ResltFolder))
        #When delete the result folder the jenkins performance plugin will not find the "*.jtl" fie
        #shutil.rmtree(os.path.join(OutPutDir,TestResltFolder))
        
    
if __name__ == "__main__":
    import sys
    OutPutDir = sys.argv[1]
    TestCaseName = sys.argv[2] 
    RemotePath = sys.argv[3] 
    FtpServer = ast.literal_eval(sys.argv[4])

    #===========================================================================
    # OutPutDir = os.environ['TestReportDir']
    # TestCaseName = os.environ['TestCaseName']
    # RemotePath = os.environ['FtpServerReportDir']
    # FtpServer = ast.literal_eval(os.environ['FtpServerList'])
    #===========================================================================
    #===========================================================================
    # OutPutDir = r"C:\2_EclipseWorkspace\xtcAuto\output"
    # TestCaseName = "ggggggggggggggggo"
    # RemotePath = "PerformanceTestReport"
    # FtpServer = [{"host":"172.19.7.109","username":"tester","password":"autotester"},{"host":"172.19.7.109","username":"report","password":"autoreport"},]
    #  
    #===========================================================================
    pk = PackageReport()
    pk.package_upload_result(OutPutDir,TestCaseName,FtpServer[1]["host"],FtpServer[1]["username"],FtpServer[1]["password"],RemotePath)

