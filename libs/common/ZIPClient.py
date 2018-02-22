#!/usr/bin/env python3
#-*- coding: utf-8 -*-

import os
import zipfile

class ZIPClient(object):
    def __init__(self):
        pass
    
    def zip(self,src):
        zf = zipfile.ZipFile("%s.zip" % (src), "w", zipfile.ZIP_DEFLATED)
        abs_src = os.path.abspath(src)
        for dirname, subdirs, files in os.walk(src):
            for filename in files:
                absname = os.path.abspath(os.path.join(dirname, filename))
                arcname = absname[len(abs_src) + 1:]
                zf.write(absname, arcname)
        zf.close()
        
    def unzip(self,ArchivePath):     
        if zipfile.is_zipfile(ArchivePath):
            try:
                zf = zipfile.ZipFile("%s" % (ArchivePath), "r")
                ExtractPath = os.path.splitext(ArchivePath)[0]
                if not os.path.isdir(ExtractPath):
                    os.mkdir(ExtractPath)
                zf.extractall(path=ExtractPath, members=None, pwd=None)
            except Exception as e:
                print('*** unzip Caught exception: %s: %s' % (e.__class__, e))
                
if __name__ == "__main__":
    zfc = ZIPClient()
    #===========================================================================
    # ArchivePath = r"C:\2_EclipseWorkspace\xtcAuto\Output\zhuanzilian1201032.zip"
    # zfc.unzip(ArchivePath)
    #===========================================================================
            
            