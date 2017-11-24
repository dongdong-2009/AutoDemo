#!/usr/bin/python
#-*- coding:UTF-8 -*-

'''
#===============================================================================
# Set SSH Client with paramiko to connect the Web Server 
# And Start the commands at Server
# After commands is finished 
# Then put the results or logs to log server
# Created on 2017-10-30
# @author: QinXing
#===============================================================================
'''

import traceback
import paramiko
import time
import socket
import sys


class SSHClient(object):

    #Simple SSH Client for execute the nmon at the VM Master.
    
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
    
    def listdir_sftp(self,hostname,username,password, dir_root):
        sftp_client = self.connect_sftp(hostname,username,password)
        dirlist = sftp_client.listdir(dir_root)
        sftp_client.close()
        return dirlist
    
    def getfile_sftp(self, hostname,username,password, remotepath, localpath = None):
        sftp_client = self.connect_sftp(hostname,username,password)
        sftp_client.get(remotepath, localpath)
        sftp_client.close()
        
    def putfile_sftp(self,hostname,username,password, remotepath, localpath = None):
        sftp_client = self.connect_sftp(hostname,username,password)
        sftp_client.get(localpath, remotepath)
        sftp_client.close()
        
    def run_nmon(self,hostname, username, password,timeout=15.0):
        client = self.connection(hostname, username, password)
        resultName = ''.join(hostname.split('.')) + socket.getfqdn().replace('.','').replace('-','') + time.strftime("%I%M%S") + ".nmon"
        runCmds = "./nmon -F" + resultName + " -p -s 1 "
        stdout = self.write_commands(client, runCmds)
        stdout = stdout.readlines()
        client.close()
        return stdout
        
    def run_nmon_counts(self,hostname, username, password,counts,timeout=15.0):
        client = self.connection(hostname, username, password)
        resultName = ''.join(hostname.split('.')) + socket.getfqdn().replace('.','').replace('-','') + time.strftime("%I%M%S")
        runCmds = "/root/nmon -F" + resultName + " -p -s 1 -c " + str(counts)
        stdout = self.write_commands(client, runCmds)
        stdout = stdout.readlines()
        client.close()
        return stdout
        
    def stop_nmon(self,hostname, username, password):  
        client = self.connection(hostname, username, password)
        getNmonPidCmds = "ps aux | grep nmon |awk 'NR == 1' |awk '{print $2}'" 
        stdout = self.write_commands(client, getNmonPidCmds)
        stdout = stdout.readlines()
        stdout = self.write_commands(client, "kill -USR2  %d" % (int(stdout[0])))
        client.close()
        
if __name__ == "__main__":
    SSHClient(object)
 #==============================================================================
 #    hostname = '172.19.6.176'
 #    username='root'
 #    password='suneee'
 #    remotefile = "./172196176DESKTOP65TQ8I2weiliancn080943.nmon"
 #    localpath = "C:\\2_EclipseWorkspace\\xtcAuto\\Output"
 #    localpath = "C:\\Users\\outse\\Documents\\123.nmon"
 #    sshc = SSHClient(object)
 #    sshc.getfile_sftp(hostname,username,password,remotefile,localpath)
 #    sshc.run_nmon(hostname, username,password)
 # 
 #    sshc.stop_nmon(hostname, username,password)
 #==============================================================================
    
    