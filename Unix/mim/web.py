# $Id: web.py,v 1.1.1.1 2003/03/01 12:55:11 jb Exp $

import mim
import re
import urllib
    
class Test(mim.Test):
    def __init__(self, params):
        """
        params[0] -- url
        params[1] -- regexp
        params[2] -- 1/0 (should match, should not match)
        """
        assert len(params) == 3
        mim.Test.__init__(self, params)
        self.url = params[0]
        self.re = params[1]
        self.shouldMatch = int(params[2])

    def __check(self):
        try:
            page = urllib.urlopen(self.url)
            data = page.read()
            pm = re.search(self.re, data)

            if pm and not self.shouldMatch:
                return mim.TestResult(__name__ + str(self.params), 0, self.url + " matched " + self.re)
            elif not pm and self.shouldMatch:
                return mim.TestResult(__name__ + str(self.params), 0, self.url + " didn't match " + self.re)
            else:
                return mim.TestResult(__name__ + str(self.params), 1, self.url + " OK")
        except:
            return mim.TestResult(__name__ + str(self.params), 0, "Unspecified error getting " + self.url)
