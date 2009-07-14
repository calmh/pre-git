# $Id: log.py,v 1.1.1.1 2003/03/01 12:55:11 jb Exp $

import mim
import commands
import socket
import shelve
import re
import os
        
class Test(mim.Test):
    def __init__(self, params):
        """
        params[0] -- logfile
        params[1] -- alarm regexp
        """
        mim.Test.__init__(self, params)

    def __check(self):
        try:
            offsets = shelve.open("offsets.db")
            if offsets.has_key(__name__ + str(self.params)):
                offset = offsets[__name__ + str(self.params)]
            else:
                offset = 0
            
                size = os.stat(self.params[0]).st_size
                logfile = file(self.params[0])
                if size >= offset:
                    logfile.seek(offset)

                exp = re.compile(self.params[1])
                line = logfile.readline()
                while line:
                    offset = logfile.tell()
                    offsets[__name__ + str(self.params)] = offset
                    if exp.search(line):
                        offsets.close()
                        return mim.TestResult(__name__ + str(self.params), 0, line)
                    line = logfile.readline()
        except:
            offsets.close()
            return mim.TestResult(__name__ + str(self.params), 0, "Error reading log!")            

        offsets.close()
        return mim.TestResult(__name__ + str(self.params), 1, "No alarm found")
