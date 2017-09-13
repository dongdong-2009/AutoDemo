#!/usr/bin/env python
# -*- coding: utf-8 -*-

"""
    edit haiyuan,2017-07
"""

import smtplib

# Import the email modules we'll need
#from email.mime.text import MIMEText
#fp = open(textfile,'rb')
sender = "banrieen@163.com"
recevier = ["934786891@qq.com"]

message = From: From Person <%s>
to: To Person<%s>
Subject:SMTP email test 

This is a e-mail message.
%(sender,recevier)
print message
try:
	smtpObj = smtplib.SMTP("smtp.163.com")
	smtpObj.login("banrieen@163.com","18209188642git")
    smtpObj.sendmail(sender,receiver,message)
    print "Successfully sent email "
except SMTPExpection:
	print "Error:unable to send email"

smtpObj.quit()