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
import os,sys
import ast

class SSHClient(object):

    def __init__(self, params):
        pass
    
    def connection(self,host,port,username,password,timeout=60.0): 
        
        try:
            client = paramiko.SSHClient()
            client.load_system_host_keys()
            client.set_missing_host_key_policy(paramiko.WarningPolicy())
            client.connect(host,int(port),username,password,timeout=60.0)
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

    def nmon_status(self,client):
        try:
            stdout = ""
            for looktimes in range (5):
                stdin, stdout, stderr = client.exec_command("ps aux | grep nmon |awk '{print $2,$11 }'" )
                stdout = stdout.readlines()  
            running_count = 0 
            for outline in  stdout:
                if 'nmon' in outline:
                    running_count = running_count + 1
            if running_count == 1 :
                return True                
            else:
                return False
        except Exception :
            return False
           
    def stop_nmon(self,client):  
        try:
            self.write_commands(client, 'ps aux | grep "nmon" | cut -c 9-15 | xargs kill -9')
            if not self.nmon_status(client):
                return True
            else:
                return False
        except Exception as err:
            print("Stop nmon fial on %s ! %s"%(err))
            return False
        
    def upload_file_ncftpput(self,SSHClient,ftpServer,ftpUser,ftpPasswd,logServerPath,LocalFilepath):
        ncftpputCmds = "/usr/bin/ncftpput -u %s -p %s  %s  %s  %s/*.nmon" % (ftpUser,ftpPasswd,ftpServer,logServerPath,LocalFilepath)
        try:
            stdout = self.write_commands(SSHClient, ncftpputCmds) 
        except Exception as e:
            print('*** ftp_connection: %s: %s' % (e.__class__, e))
            return None
        
    def connect_sftp(self,host,port,username,password):
        try:
            t = paramiko.Transport((host,int(port)))               
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
        
    def upload_nmonResult_sftp(self,host,port,username,password,remotepath, localpath):
        try:
            sftp_client = self.connect_sftp(host,port,username,password)
            for files in self.listdir_sftp(sftp_client,remotepath):
                if "nmon" in os.path.splitext(files)[1]:
                    self.getfile_sftp(sftp_client,remotepath+"/"+files, os.path.join(localpath,files))
            return True
        except Exception as e:
            print('*** upload_nmonResult_sftp Caught exception: %s: %s' % (e.__class__, e))
            return False
        finally:
            sftp_client.close()
        
    def run_upload(self,host,port,username,password,RemoteServerPath,LocalFilepath,timeout=15.0):
        try:
            SSHClient = self.connection(host,port,username,password)
            if self.stop_nmon(SSHClient):
                print(">>>>>>>>>>>>>>>>>>>>> Stop Nmon On %s : %s \n" % (host,port)) 
            if self.upload_nmonResult_sftp(host,port,username,password,RemoteServerPath,LocalFilepath):
                print("Upload nmon result on %s:%s result successfully !"%(host,port))
            self.write_commands(SSHClient,"yum remove -y ncftp") 
        finally:
            SSHClient.close()
            
if __name__ == "__main__":
    #Passing jenkins environment variables,depend on different OS
    
    serverList = ast.literal_eval(sys.argv[1])
    LocalFilepath = os.path.join((r'%s'%(sys.argv[2])) , r'TempReport\NmonReport')
    RemoteServerPath = '/root'
      
    #===========================================================================
    # serverList = ast.literal_eval(os.environ['ServerList'])
    # LocalFilepath = os.path.join(os.environ['TestReportDir'] , "/TempReport/NmonReport")
    # RemoteServerPath = '/root'
    # LocalFilepath = r"C:\2_EclipseWorkspace\xtcAuto\output" + "\\TempReport\\NmonReport"
    #===========================================================================
    #===========================================================================
    # LocalFilepath = r"C:\2_EclipseWorkspace\xtcAuto\output" + "\\TempReport\\NmonReport"
    # #serverList = [{"host":"172.16.43.73","username":"root","password":"c8&+7X38!G3Lg-$euWwX","centos":7,"root":"/root"}]
    # serverList = [{"host":"10.0.0.180","port":11622,"username":"root","password":"5K]SiXeZuf!s}R>6324}","centos":"7","root":"/root"},
    #               {"host":"10.0.0.180","port":11422,"username":"root","password":"6q7wvFu2)u@3)XL-8*DN","centos":"7","root":"/root"},
    #               {"host":"172.16.43.73","port":22,"username":"root","password":"c8&+7X38!G3Lg-$euWwX","centos":7,"root":"/root"}]
    #  
    #===========================================================================
    sshc = SSHClient(object)
    for si in serverList:
        sshc.run_upload(si["host"],  si["port"],si["username"], si["password"],RemoteServerPath,LocalFilepath,timeout=15.0)
               