#!/usr/bin/python
#-*- coding:UTF-8 -*-

"""
#===============================================================================
# After robot test finished, we will zip the temp results dir as "TestPlanNameTimeString.zip"
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
    
    def clean_folder_contents(self,FolderPath):
        try:
            for fds in os.listdir(FolderPath):
                temp = os.path.join(FolderPath,fds)
                if os.path.isfile(temp):
                    os.remove(temp)
                if os.path.isdir(temp):
                    shutil.rmtree(temp,True)
        except BaseException as e:
            print ('*** clean_folder Caught exception: %s: %s' % (e.__class__, e))
        
    def copy_result(self,OutPutDir,TestPlanName):
        TestPlanName = TestPlanName + time.strftime("%I%M%S")
        PackageDir = os.path.join(OutPutDir,TestPlanName)
        shutil.copytree(os.path.join(OutPutDir,"TempReport\RobotReport"), PackageDir)
        return  TestPlanName  
    
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
            if os.path.isdir(TempResult):
                shutil.rmtree(TempResult,True)
        except Exception as e:
            print ('*** clear_env Caught exception: %s: %s' % (e.__class__, e))  
            
    def package_upload_result(self,OutPutDir,TestPlanName,ftphost,ftpuser,ftppwd,remote_path):
        ResltFolder = self.copy_result(OutPutDir,TestPlanName)
        self.zip(os.path.join(OutPutDir,ResltFolder))
        self.upload_file(ftphost, ftpuser, ftppwd, remote_path, OutPutDir, ResltFolder + ".zip")
        self.clean_env(os.path.join(OutPutDir,ResltFolder))
        #When delete the result folder the jenkins performance plugin will not find the "*.jtl" fie
        #shutil.rmtree(os.path.join(OutPutDir,TestResltFolder))
        
    
if __name__ == "__main__":
    import sys
    OutPutDir = sys.argv[1]
    TestPlanName = sys.argv[2]
    FtpHost = sys.argv[3]
    FtpUser = sys.argv[4]
    FtpPWD = sys.argv[5]
    RemotePath = sys.argv[6]
       
    #===========================================================================
    # OutPutDir = os.environ['TestReportDir']
    # TestPlanName = os.environ['TestPlanName']
    # FtpHost = os.environ['FtpServerHost']
    # FtpUser = os.environ['FtpUserName']
    # FtpPWD = os.environ['FtpUserPasswd']
    # RemotePath = os.environ['FtpServerReportDir']
    #===========================================================================
    #===========================================================================
    # OutPutDir = r"C:\2_EclipseWorkspace\xtcAuto\Output"
    # TestPlanName = "ggggggggggggggggo"
    # FtpHost = "172.19.7.109"
    # FtpUser = "report"
    # FtpPWD = "autoreport"
    # RemotePath = "PerformanceTestReport"
    #===========================================================================
    print("########## Zip the current report and logs,then put it to ftpserver ##########")
    pk = PackageReport()
    pk.package_upload_result(OutPutDir,TestPlanName,FtpHost,FtpUser,FtpPWD,RemotePath)


