# $Id: connect.py,v 1.1.1.1 2003/03/01 12:55:11 jb Exp $

import mim
import commands
import socket
        
class Test(mim.Test):
    def __init__(self, params):
        mim.Test.__init__(self, params)

    def __check(self):
        host = self.params[0]
        for portn in self.params[1:]:
            try:
                try:
                    port = int(portn)
                except ValueError:
                    port = socket.getservbyname(portn, "tcp")
                s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
                s.connect((host, port))
                s.close()
            except socket.error:
                return mim.TestResult(__name__ + str(self.params), 0, "Could not connect on port " + portn)
        return mim.TestResult(__name__ + str(self.params), 1, "All connects OK")
