#!/usr/bin/python
#-*- coding:UTF-8 -*-

"""
#===============================================================================
# Before running jmeter scripts,start up the nmon on background web server
#===============================================================================
"""

import traceback
import paramiko
import time
import socket
import os


class SSHClient(object):
    def __init__(self, params):
        pass
    
    def connection(self,hostname,username,password,timeout=60.0): 
        port = 22
        try:
            client = paramiko.SSHClient()
            client.load_system_host_keys()
            client.set_missing_host_key_policy(paramiko.WarningPolicy())
            client.connect(hostname, port,username,password,timeout=60.0)
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
    
    def nmon_running(self,client):
        GetNmonPidCmds = "ps aux | grep nmon |awk 'NR == 1' |awk '{print $2 }'" 
        stdout = self.write_commands(client, GetNmonPidCmds)
        stdout = stdout.readlines()[0]
        if len(stdout) and ('grep' not in stdout):
            return True
        else:
            return False
     
    def run_nmon(self,client,hostname, username, password,timeout=15.0):
        resultName = ''.join(hostname.split('.')) + socket.getfqdn().replace('.','').replace('-','') + time.strftime("%I%M%S") + ".nmon"
        #Remove the result file After upload finished
        Cmds = "rm -rf %s " % ("/root/*.nmon") 
        self.write_commands(client, Cmds)
        runCmds = "./nmon -F" + resultName + " -p -s 1 "
        stdout = self.write_commands(client, runCmds)
        stdout = stdout.readlines()
        client.close()
        return stdout
    
if __name__ == "__main__":
    #Passing jenkins environment variables,depend on different OS
    hostname = os.environ['ServerHost']
    username=os.environ['ServerRoot']
    password=os.environ['ServerPasswd']
    #===========================================================================
    # hostname = "172.19.6.176"
    # username="root"
    # password="suneee"
    #===========================================================================
    sshc = SSHClient(object)
    clinet = sshc.connection(hostname, username, password)
    if sshc.nmon_running(clinet):
        sshc.run_nmon(clinet,hostname, username,password) 
    
    
     
     