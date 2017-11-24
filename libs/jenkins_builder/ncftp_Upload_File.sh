#Usage:  ncftp [flags] [<host> | <directory URL to browse>]
#Flags:
#  -u XX  Use username XX instead of anonymous.
#  -p XX  Use password XX with the username.
#  -P XX  Use port number XX instead of the default FTP service port (21).
#  -j XX  Use account XX with the username (rarely needed).
#  -F     Dump a sample $HOME/.ncftp/firewall prefs file to stdout and exit.
#
#Program version:  NcFTP 3.2.4/465 Apr 07 2010, 06:24 PM
#Library version:  LibNcFTP 3.2.4 (April 3, 2010)
#Build system:     Linux x86-05.phx2.fedoraproject.org 2.6.18-194.3.1.el5 #1...
#
#This is a freeware program by Mike Gleason (http://www.NcFTP.com).
#A directory URL ends in a slash, i.e. ftp://ftp.freebsd.org/pub/FreeBSD/
#Use ncftpget and ncftpput for command-line FTP and file URLs.

#Sample to upload file
ncftpput -u tools -p tools 172.19.5.179 /TestResults  /root/testftp.nmon

ncftpget -u tools -p tools 172.19.5.179 /TestResults  /root/testftp.nmon
