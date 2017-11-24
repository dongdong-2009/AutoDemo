#!/bin/bash

HOST=ftp.server.com  #This is the FTP servers host or IP address.
USER=ftpuser             #This is the FTP user that has access to the server.
PASS=password          #This is the password for the FTP user.

# Call 1. Uses the ftp command with the -inv switches. 
#-i turns off interactive prompting. 
#-n Restrains FTP from attempting the auto-login feature. 
#-v enables verbose and progress. 

ftp -inv $HOST << EOF

# Call 2. Here the login credentials are supplied by calling the variables.

user $USER $PASS

# Call 3. Here you will change to the directory where you want to put or get
cd /path/to/file

# Call4.  Here you will tell FTP to put or get the file.
put test.txt

# End FTP Connection
bye

EOF

#After configuring and saving the .sh script, make it executable:
#chmod +x ftpscript.sh
#Lastly, configure your cronjob