#!/usr/bin/python
#-*- coding:UTF-8 -*-

"""
#===============================================================================
# Stop Nmon monitoring,when jmeter finished
# Upload nmon result *.nmon fils to xtcAuto project folder TempReportmonReport
#===============================================================================
"""

import traceback
import paramiko
import time
import os


class SSHClient(object):

    def __init__(self, params):
        self.port = 22
    
    def connection(self,hostname,username,password,timeout=60.0): 
        
        try:
            client = paramiko.SSHClient()
            client.load_system_host_keys()
            client.set_missing_host_key_policy(paramiko.WarningPolicy())
            client.connect(hostname, self.port,username,password,timeout=60.0)
        except Exception as e:
            print('*** Caught exception: %s: %s' % (e.__class__, e))
            traceback.print_exc()
            client.close()
        return client
    
    def write_commands(self,client,cmds,timeout=15.0):
        try:
            stdin, stdout, stderr = client.exec_command(cmds,timeout)
        except Exception as e:
            client.close()
            return e
        return stdout
           
    def stop_nmon(self,hostname, username, password):  
        client = self.connection(hostname, username, password)
        GetNmonPidCmds = "ps aux | grep nmon |awk 'NR == 1' |awk '{print $2}'" 
        stdout = self.write_commands(client, GetNmonPidCmds)
        stdout = stdout.readlines()
        stdout = self.write_commands(client, "kill -USR2  %d" % (int(stdout[0])))

        
    def upload_file_ncftpput(self,SSHClient,ftpServer,ftpUser,ftpPasswd,logServerPath,LocalFilepath):
        ncftpputCmds = "/usr/bin/ncftpput -u %s -p %s  %s  %s  %s/*.nmon" % (ftpUser,ftpPasswd,ftpServer,logServerPath,LocalFilepath)
        try:
            stdout = self.write_commands(SSHClient, ncftpputCmds) 
        except Exception as e:
            print('*** ftp_connection: %s: %s' % (e.__class__, e))
            return None
        
    def connect_sftp(self,hostname,username,password):
        try:
            t = paramiko.Transport((hostname,self.port))               
            t.connect(username = username,password = password)
            sftp = paramiko.SFTPClient.from_transport(t)
            return sftp
        except Exception as e:
            print('*** Connect_sftp Caught exception: %s: %s' % (e.__class__, e))
            traceback.print_exc()
            try:
                t.close()
            except:
                pass
            sys.exit(1)
    
    def listdir_sftp(self,sftp_client,dir_root):
        return sftp_client.listdir(dir_root)
    
    def getfile_sftp(self, sftp_client,remotepath, localpath=None):
        sftp_client.get(remotepath, localpath)  
        
    def upload_nmonResult_sftp(self,hostname,username,password,remotepath, localpath):
        try:
            sftp_client = self.connect_sftp(hostname,username,password)
            for files in self.listdir_sftp(sftp_client,remotepath):
                if "nmon" in os.path.splitext(files)[1]:
                    self.getfile_sftp(sftp_client,remotepath+"/"+files, os.path.join(localpath,files))
                    return True
        except Exception as e:
            print('*** upload_nmonResult_sftp Caught exception: %s: %s' % (e.__class__, e))
            return False
        
    def run_upload(self,hostname,username,password,RemoteServerPath,LocalFilepath,timeout=15.0):
        SSHClient = self.connection(hostname, username, password)
        if not self.upload_nmonResult_sftp(hostname,username,password,RemoteServerPath,LocalFilepath):
            print("Stop nmon and Upload nmon result Successfully !")
        SSHClient.close()
        
if __name__ == "__main__":
    #Passing jenkins environment variables,depend on different OS
    #===========================================================================
    # hostname = os.environ['ServerHost']
    # username=os.environ['ServerRoot']
    # password=os.environ['ServerPasswd']
    #===========================================================================
    hostname = "172.19.6.176"
    username="root"
    password="suneee"
    
    #===========================================================================
    # ftpServer = os.environ['FtpServerHost'] 
    # ftpUser = os.environ['FtpUserName']  
    # ftpPasswd = os.environ['FtpUserPasswd']  
    #===========================================================================
    #当前还是用执行机本地的路径
    RemoteServerPath = '/root'
    #LocalFilepath = os.environ['TestReportDir'] + "/TempReport/NmonReport"
    LocalFilepath = r"C:\2_EclipseWorkspace\xtcAuto\output" + "\\TempReport\\NmonReport"
    sshc = SSHClient(object)
    sshc.stop_nmon(hostname, username,password)
    time.sleep(5.0)
    sshc.run_upload(hostname,username,password,RemoteServerPath,LocalFilepath,timeout=15.0)   

