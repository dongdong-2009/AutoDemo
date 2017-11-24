#!/usr/bin/python
#-*- coding:UTF-8 -*-


import paramiko
import time   
 
class RemoteFTP(object):
    def __init__(self, params):
        pass
    
    def ssh_connection(self,hostname,username,password,timeout=60.0): 
        port = 22
        try:
            client = paramiko.SSHClient()
            client.load_system_host_keys()
            client.set_missing_host_key_policy(paramiko.WarningPolicy())
            client.connect(hostname, port,username,password,timeout=60.0)
        except Exception as e:
            client.close()
        return client
    
    def write_commands(self,client,cmds,timeout=30.0):
        try:
            stdin, stdout, stderr = client.exec_command(cmds,timeout)
        except Exception as e:
            client.close()
            print ("write_commands Error: %s \n" % (e))
        return stderr.readlines(), stdout.readlines()
    
    def select_valid_nmon_result(self,SSHClient,localFilepath):
        try:
            Cmds = "ls -l %s | grep *.nmon | awk '{print $9}'" % (localFilepath)
            stdout = self.write_commands(SSHClient, Cmds) 
            stderr,stdout = stdout.readlines()
            return stderr
        except Exception as e:
            print('*** select_valid_nmon_result: %s: %s' % (e.__class__, e))
            return None
        
    def upload_file_bash(self,SSHClient,ftpServer,ftpUser,ftpPasswd,logServerPath,localFilepath):  
        # Un-stable，could not be used  
        FtpPutBash = """
        #!/bin/bash
        ftp -inv $%s << EOF
        user $%s $%s
        cd %s
        put %s\*.nmon
        bye
        EOF
        """ % (ftpServer,ftpUser,ftpPasswd,logServerPath,localFilepath)
        try:
            self.write_commands(SSHClient, "echo FtpPutBash >> /usr/tmp/ftpbash.sh") 
            stdout = self.write_commands(SSHClient, "/bin/bash /usr/tmp/ftpbash.sh")  
        except Exception as e:
            print('*** ftp_connection: %s: %s' % (e.__class__, e))
            return None
    
    def upload_file_ncftpput(self,SSHClient,ftpServer,ftpUser,ftpPasswd,logServerPath,localFilepath):
        ncftpputCmds = "/usr/bin/ncftpput -u %s -p %s  %s  %s  %s/*.nmon" % (ftpUser,ftpPasswd,ftpServer,logServerPath,localFilepath)
        try:
            stdout = self.write_commands(SSHClient, ncftpputCmds) 
        except Exception as e:
            print('*** ftp_connection: %s: %s' % (e.__class__, e))
            return None
        
    def run_upload(self,hostname,username,password,ftpServer,ftpUser,ftpPasswd,logServerPath,localFilepath,timeout=15.0):
        SSHClient = self.ssh_connection(hostname, username, password)
        if not self.upload_file_ncftpput(SSHClient,ftpServer,ftpUser,ftpPasswd,logServerPath,localFilepath):
            print("Upload nmon result Successfully ！")
            #Remove the result file After upload finished
            Cmds = "rm -rf %s " % ("*.nmon") 
            self.write_commands(SSHClient, Cmds)
        SSHClient.close()
    
        
if __name__ == "__main__":
    hostname = '172.19.6.176'
    username='root'
    password='suneee'
    ftpServer = '172.19.5.179'
    ftpUser = 'tools'
    ftpPasswd = 'tools'
    logServerPath = '/TestResults'
    localFilepath = '/root'
    
    sshc = SSHClient(object)
    sshc.run_upload(hostname,username,password,ftpServer,ftpUser,ftpPasswd,logServerPath,localFilepath)      
     
     