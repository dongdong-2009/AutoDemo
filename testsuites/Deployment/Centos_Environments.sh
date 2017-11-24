#!/bin/sh

#Auto install the docker,pypi repository


#Install git,ftp
yum install ftp -y
yum install git -y
#Install tcpdum
yum install tcpdump -y
#Install ntp
yum -y install ntp