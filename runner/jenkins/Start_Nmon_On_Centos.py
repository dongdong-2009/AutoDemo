#!/usr/bin/python
#-*- coding:UTF-8 -*-

"""
#===============================================================================
# Start up the nmon on background web server,before running jmeter scripts;
# Now,It is not need any. "Make sure add the ssh-key to client ~/.ssh/known_hosts‘
# 
#===============================================================================
"""

import traceback
import paramiko
import time
import socket
import os
import ast
import re
from _pytest.outcomes import fail

class SSHClient(object):
    def __init__(self, params):
        pass
    
    def connection(self,host,port,username,password,timeout=60.0): 
        try:
            client = paramiko.client.SSHClient()
            client.load_system_host_keys()
            client.set_missing_host_key_policy(paramiko.client.AutoAddPolicy())
            client.connect(host,int(port),username,password,timeout=60.0)
            stdin, stdout, stderr = client.exec_command("host",timeout)
            if stdout.readlines():
                print("SSHClient connection success. The host is: " + stdout.readlines()[0])
                    
        except Exception as e:
            print('*** Caught exception: %s: %s' % (e.__class__, e))
            traceback.print_exc()
            client.close()

        return client

    def install_ncftp(self,client):
        #默认安装ncftp
        installCount = 5
        while True:
            stdout = client.exec_command("sudo yum install  --nogpgcheck -y ncftp")
            if (stdout) and ("Installed" in stdout or "installed" in stdout):
                break
            else:
                installCount = installCount - 1
                if installCount :
                    time.sleep(5)
                else:
                    break
    
    def write_commands(self,client,cmds,timeout=15.0):
        try:        
            channel = client.invoke_shell()
            stdin = channel.makefile('wb')
            stdout = channel.makefile('rb')
            stdin.write(cmds)
            print(stdout.read())
            outs = stdout.read()
        except Exception as err:
            print(err)
        finally:
            print(outs)
            stdout.close()
            stdin.close()
            return None
        
    def stop_nmon(self,client): 
        try: 
            #===================================================================
            # #stdin, stdout, stderr = client.exec_command("ps aux | grep nmon |awk 'NR == 1' |awk '{print $2}'" )
            # #stdout = stdout.readlines()
            # #self.write_commands(client, "kill -USR2  %d" % (int(stdout[0])))
            #===================================================================
            self.write_commands(client, 'ps aux | grep "nmon" | cut -c 9-15 | xargs kill -9')
        except Exception as err:
            print("Stop nmon fial ! %s"%(err))
            return False
    
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
    
    def get_nmon(self,client,storageHost,storageName,filepath,storagePasswd):
        try:
            self.install_ncftp(client)
            client.exec_command("ncftpget -u %s -p %s -P 21 %s ./ %s " % (storageName,storagePasswd,storageHost,filepath),60)
            stdin, stdout, stderr = client.exec_command("ls -l ~/. | grep nmon",60)
            outs = stdout.readlines()
            if not outs:
                return None
            for lines in outs:
                if '.nmon' in os.path.splitext(lines.split(' ')[-1])[1]:
                    client.exec_command("rm -rf ~/*.nmon",60)
                    continue
                if "nmon" in os.path.splitext(lines.split(' ')[-1])[0]:
                    if len(lines.split(' ')[-1][:-1]) == len("nmon"):
                        continue
                    else:
                        #print("Download nmon: " + lines.split(' ')[-1][:-1])
                        client.exec_command("mv ~/%s ~/nmon -f"%(lines.split(' ')[-1][:-1]),60)
                        client.exec_command("chmod 777 ~/nmon",60)
        except:
            print("Get nmon Fail.........")
     
    def run_nmon(self,client,hostname, timeout=15.0):
        resultName = ''.join(hostname.split('.')) + socket.getfqdn().replace('.','').replace('-','') + time.strftime("%I%M%S") + ".nmon"
        #Remove the result file After upload finished
        client.exec_command("rm -rf %s " % ("/root/*.nmon"))
        client.exec_command("nohup ./nmon -F " + resultName + " -a -M -N -p -s 1 -c 86400 &")

    
if __name__ == "__main__":
    import sys
    #Passing jenkins environment variables,depend on different OS

    serverList = ast.literal_eval(sys.argv[1])
    FtpServer = ast.literal_eval(sys.argv[2])
    
    #===========================================================================
    # serverList = ast.literal_eval(os.environ['ServerList'])
    # FtpServer = ast.literal_eval(os.environ['FtpServerList'])
    # #filePath = os.environ['FtpServerFilePath']
    #===========================================================================
    
    #===========================================================================
    # filePath="common/nmon/nmon16e_x86_rhel65"
    # serverList = [{"host":"10.0.0.180","port":11622,"username":"root","password":"5K]SiXeZuf!s}R=6324}","centos":"7","root":"/root"},
    #               {"host":"10.0.0.180","port":11422,"username":"root","password":"6q7wvFu2)u@3)XL-8*DN","centos":"7","root":"/root"},
    #               {"host":"172.16.43.73","port":22,"username":"root","password":"c8&+7X38!G3Lg-$euWwX","centos":7,"root":"/root"}]
    # FtpServer = [{"host":"172.19.7.109","username":"tester","password":"autotester"},{"host":"172.19.7.109","username":"report","password":"autoreport"},]
    #===========================================================================
    filePath="common/nmon/nmon16e_x86_rhel65"
    sshc = SSHClient(object)
    for si in serverList:
        sshClient = sshc.connection(si["host"],si["port"], si["username"], si["password"])
        if sshc.nmon_status(sshClient):
            sshc.stop_nmon(sshClient)
        #===================================================================
        # if si["centos"] == 7:
        #     filePath="common/nmon/nmon16g_x86_rhel72"
        #===================================================================
        sshc.get_nmon(sshClient,FtpServer[0]["host"],FtpServer[0]["username"],filePath,FtpServer[0]["password"])
        sshc.run_nmon(sshClient,si["host"]) 
        if sshc.nmon_status(sshClient):
            print(">>>>>>>>>>>>>>>>>>>>> Start Nmon On %s :%s \n" % (si["host"],si["port"]))
        sshClient.close()
        
        