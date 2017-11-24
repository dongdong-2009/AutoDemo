#!/usr/bin/python
#-*- coding:UTF-8 -*-

"""
Use python libs for .robot
"""

import zipfile
import os
from fileinput import filename

class resources(object):

    ROBOT_LIBRARY_VERSION = 1.0

    def __init__(self):
        pass

    def zip(self,src,dst):
        with zipfile.ZipFile("%s.zip" % (dst),"w",zipfile.ZIP_DEFLATED) as zf:
            abs_path = os.path.abspath(src)
            for dirname,subdirs,files in os.walk(src):
                for filename in files:
                    asbname = os.path.abspath(os.path.join(dirname,filename))
                    arcname = absname[len(abs_src) + 1:]
                    print 'zipping %s as %s ' % (os.path.join(dirname,filenname),arcname)
                    zf.write(absname,arcname)

        
    
    def unzip(self):
        pass
