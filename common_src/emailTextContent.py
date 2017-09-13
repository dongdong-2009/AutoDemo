# Import smtplib for the actual sending function
import smtplib

# Import the email modules we'll need
from email.mime.text import MIMEText

# Open a plain text file for reading.  For this example, assume that
# the text file contains only ASCII characters.
textfile = r"/Users/lizhen/sendmail.txt"
fp = open(textfile, 'rb')
# Create a text/plain message
msg = MIMEText(fp.read())
fp.close()

# me == the sender's email address
# you == the recipient's email address
msg['Subject'] = 'The contents of %s' % textfile
msg['From'] = 'banrieen@163.com'
msg['To'] = '934786891@qq.com'

# Send the message via our own SMTP server, but don't include the
# envelope header.
localhost = 'smtp.163.com'
user = {"name":'banrieen@163.com',"passwd":"18209188642git"}
s = smtplib.SMTP(localhost)
s.login(user["name"],user["passwd"])
s.sendmail('banrieen@163.com', ['934786891@qq.com'], msg.as_string())
s.quit()